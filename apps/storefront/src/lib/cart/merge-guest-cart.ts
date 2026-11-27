import { applyGuestCartMerge, planGuestCartMerge } from '@/actions/guest-cart.actions';
import { describeMergeNotices, type GuestLine } from '@/lib/cart/guest-cart';
import { GUEST_CART_STORAGE_KEY, useGuestCartStore } from '@/stores/guest-cart-store';

/**
 * Runs a guest-cart merge, in the one order that survives being interrupted.
 *
 *   1. plan          read-only; nothing has changed if it fails
 *   2. FREEZE        the plan is persisted before a single write happens
 *   3. apply         absolute quantities, so re-applying changes nothing
 *   4. confirm       the basket is emptied only now
 *
 * Step 2 is the one that is easy to leave out and the one the whole guarantee
 * rests on. Without it, a retry re-plans against a cart that already holds some
 * of the guest quantities and adds them a second time.
 *
 * ## Never throws, never blocks sign-in
 *
 * A merge is a convenience attached to logging in, not part of logging in. A
 * failure here leaves the basket exactly as it was — the customer keeps it, and
 * the next sign-in tries again — and returns a message rather than raising.
 * Nothing a delisted product does may stop somebody reaching their account.
 */
export interface MergeOutcome {
  /** True when the API confirmed the cart; the basket has been emptied. */
  readonly merged: boolean;
  /** A sentence for the customer, or `null` when everything moved cleanly. */
  readonly message: string | null;
}

const NOTHING_TO_DO: MergeOutcome = { merged: false, message: null };

/**
 * The merge currently running in this tab, if any.
 *
 * ## Why a second caller must never start a second merge
 *
 * The freeze only protects against a SEQUENTIAL retry. Two invocations
 * running CONCURRENTLY both read `pendingMerge: null`, both plan, and the
 * second plan is summed against a cart the first one's apply may already
 * have written — then its `beginMerge` overwrites the frozen plan with
 * those doubled targets, and the overwrite is what gets applied and
 * confirmed. Measured in the browser suite: server cart 3, guest basket 2,
 * two racing invocations, final cart 7 instead of 5.
 *
 * Callers are React effects, and effects multiply — Strict Mode, a
 * remount, a second mounted trigger, a second tab's worth of confidence in
 * a per-mount ref. The guard therefore lives here, in the one function
 * every caller funnels through, not in any component: concurrent callers
 * share the running merge and its outcome.
 */
let inFlight: Promise<MergeOutcome> | null = null;

export function mergeGuestCartOnLogin(): Promise<MergeOutcome> {
  if (inFlight !== null) return inFlight;

  inFlight = runMerge().finally(() => {
    inFlight = null;
  });

  return inFlight;
}

/**
 * The basket as PERSISTED, read straight from `localStorage`.
 *
 * ## Why the in-memory store is not enough
 *
 * This module — and the store with it — can be evaluated more than once in
 * the same page (the dev bundler does it; a second tab is the same shape
 * with a bigger gap). Each evaluation gets its own in-memory store, and
 * zustand's persist middleware does not sync instances within a document,
 * so instance B's `getState()` can still say `pendingMerge: null` after
 * instance A froze a plan. The one thing every instance shares is the
 * persisted value, and a synchronous read of it is atomic with respect to
 * everything else on this thread — which makes it the coordination point
 * the freeze protocol below is built on.
 *
 * Anything unreadable or malformed reads as "no information", never as an
 * empty basket: a corrupt value must not talk a merge out of existing.
 */
function readPersistedBasket(): { items: GuestLine[]; pendingMerge: GuestLine[] } | null {
  try {
    const raw = window.localStorage.getItem(GUEST_CART_STORAGE_KEY);

    if (raw === null) return null;

    const parsed = JSON.parse(raw) as {
      state?: { items?: unknown; pendingMerge?: unknown };
    };
    const lines = (value: unknown): GuestLine[] =>
      Array.isArray(value)
        ? value.filter(
            (line): line is GuestLine =>
              typeof line === 'object' &&
              line !== null &&
              typeof (line as GuestLine).productId === 'string' &&
              Number.isInteger((line as GuestLine).quantity) &&
              (line as GuestLine).quantity > 0,
          )
        : [];

    if (parsed.state === undefined) return null;

    return { items: lines(parsed.state.items), pendingMerge: lines(parsed.state.pendingMerge) };
  } catch {
    return null;
  }
}

async function runMerge(): Promise<MergeOutcome> {
  const store = useGuestCartStore.getState();

  /*
   * A plan already on disk means a previous attempt was interrupted after it
   * was frozen. Re-applying those targets is the retry, and it is safe
   * precisely because they are the ORIGINAL numbers rather than a new sum.
   */
  const pending = store.pendingMerge;

  if (pending !== null && pending.length > 0) {
    return apply(pending);
  }

  /*
   * The same check against the PERSISTED value, for the instance whose
   * in-memory store predates another instance's freeze (see
   * `readPersistedBasket`). Adopting the plan into this store before
   * applying it keeps the two in step.
   */
  const persistedAtStart = readPersistedBasket();

  if (persistedAtStart !== null && persistedAtStart.pendingMerge.length > 0) {
    useGuestCartStore.getState().beginMerge(persistedAtStart.pendingMerge);

    return apply(persistedAtStart.pendingMerge);
  }

  if (store.items.length === 0) return NOTHING_TO_DO;

  const plan = await planGuestCartMerge(store.items).catch(() => null);

  if (plan === null || !plan.ok) {
    // Nothing was written, so there is nothing to unwind. The basket survives.
    return { merged: false, message: null };
  }

  if (plan.targets.length === 0) {
    useGuestCartStore.getState().clear();
    return { merged: true, message: null };
  }

  /*
   * A plan frozen while this invocation was planning — by another tab, or
   * by a second evaluation of this module in the same page — wins over the
   * plan just computed. This invocation's targets were summed against a
   * cart that may already hold the frozen plan's writes; freezing them
   * would replace the original numbers with doubled ones. Re-applying
   * the frozen targets is the retry, and it is safe for the usual reason:
   * they are absolute.
   *
   * The check reads the PERSISTED value, not this instance's store, and
   * the ordering is what makes it sufficient: a competing merge freezes
   * BEFORE it applies, so any plan whose cart read could have observed a
   * competing write is necessarily computed after that freeze — and a
   * freeze that already happened is exactly what this read sees.
   */
  const frozenMeanwhile =
    useGuestCartStore.getState().pendingMerge ?? readPersistedBasket()?.pendingMerge ?? null;

  if (frozenMeanwhile !== null && frozenMeanwhile.length > 0) {
    useGuestCartStore.getState().beginMerge(frozenMeanwhile);

    return apply(frozenMeanwhile);
  }

  /*
   * The mirror image: the persisted basket is EMPTY although this
   * invocation started with lines to merge. A competing merge already
   * consumed it — planned, applied and cleared — while this one was
   * planning against the pre-merge cart. There is nothing left to merge,
   * and freezing this plan anyway would resurrect the basket as a second
   * helping. This instance's stale in-memory basket is left for the next
   * hydration to correct; writing anything here could clobber the other
   * merge's bookkeeping.
   */
  const persistedNow = readPersistedBasket();

  if (persistedNow !== null && persistedNow.items.length === 0 && store.items.length > 0) {
    return NOTHING_TO_DO;
  }

  // FREEZE. Every write below is now repeatable.
  useGuestCartStore.getState().beginMerge(plan.targets);

  return apply(plan.targets);
}

async function apply(targets: GuestLine[]): Promise<MergeOutcome> {
  const applied = await applyGuestCartMerge(targets).catch(() => null);

  if (applied === null || !applied.ok) {
    /*
     * The plan stays on disk. The basket stays on disk. The next sign-in
     * re-applies the same targets, which is why an interrupted merge cannot
     * double anything.
     */
    return { merged: false, message: null };
  }

  /*
   * The basket is cleared as ONE unit, not line by line.
   *
   * If three lines merge and the fourth fails, all four stay in the basket and
   * the retry re-applies all four. That is safe because the targets are
   * absolute — re-applying a line that already landed sets it to the number it
   * already holds — so the only cost is a stale badge for the customer: the
   * basket still shows items that are already in their account, until the next
   * authenticated page load re-applies and clears.
   *
   * Clearing per line would close that window, and it was considered and
   * rejected. It means mutating the frozen plan as the writes land, and the
   * plan is the one thing in this flow that must not change: it is what makes a
   * retry produce the same answer however far the first attempt got. A
   * mutating plan has to be written back after every line, which is another
   * partial-failure surface in the exact place partial failure is being
   * defended against. One frozen plan beats a mutating one, and the window it
   * costs is a single page load.
   */
  useGuestCartStore.getState().completeMerge();

  return { merged: true, message: describeMergeNotices(applied.notices) };
}
