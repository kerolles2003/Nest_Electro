# Muse — Remaining Work After the Autonomous Session

Branch: `muse/autonomous-engineering`. Everything below was NOT done in
this session, with the reason stated. Nothing here is silently dropped.

## Critical blockers

1. **Repository authority question (owner decision).** `main` says the
   project moved to `Nest_Electronics_Project`. That repo is not publicly
   accessible and not selected in the GitHub App, so this session worked on
   the owner-linked `phase-1-2-overnight` branch of `Nest_Electro`. If the
   other repo is the real continuation, this branch's work needs porting —
   the commits are small and self-contained to make that cheap.
2. **Production database & deployment** — explicitly out of scope (owner
   decisions). Nothing here was deployed or migrated anywhere.

## Owner inputs still required (cannot be invented)

3. **Manual payment receiving details** — set `MANUAL_PAYMENT_WALLET_NUMBER`,
   `MANUAL_PAYMENT_INSTAPAY_ADDRESS`, `MANUAL_PAYMENT_WHATSAPP_NUMBER` in
   each environment. Until then the corresponding method is simply not
   offered (by design).
4. **Shipping rate table approval (D04/D05)** — seed values are development
   data, not approved rates; free-shipping threshold still unset.
5. **Contact channel** — the contact form now honestly hands off to the
   visitor's email client. A real in-site channel needs the owner's
   WhatsApp number / inbox decision (D16).
6. **Policy texts** (returns, privacy) — still open owner inputs.

## Pre-existing test failures (found by the now-runnable full suite)

6. **Four suites fail for reasons predating this session** (verified:
   the flagged code is identical at the base commit or in files this
   session never touched). They were previously unobservable because the
   app could not boot:
   - `money-formatting`: flags an "in EGP" aria-label in
     `ShippingRatesTable.tsx` — either reword the label or register the
     gate's allowance, owner's team's call.
   - `index-health`: spec creates `scratch_things_${RUN_ID}` but expects
     the unsuffixed name in the report — reconcile spec vs service.
   - `admin-audit-log`: trail ordering vs the middleware's
     ADMIN_MUTATION_REQUESTED row — decide whether that row belongs in
     an entity trail.
   - `sharp-backend`: native sharp cannot load in this sandbox; verify
     on a normal CI runner before treating as a defect.

## High priority

7. **Deterministic concurrency test for product update (A05).** The
   version-predicate fix is in and the existing update suite passes, but a
   deterministic two-writer test needs a service-level seam (the HTTP
   surface serializes the race away). Design before writing it.
8. **Playwright e2e for the renewal redirect (F01) and manual payment
   flow.** Both are verified by build/type-check/API tests, not by a
   browser run in this session.
9. **Admin queue filter for PENDING_VERIFICATION orders.** Verification
   actions exist on the order detail; a dedicated queue filter would make
   the daily workflow faster.
10. **OpenAPI drift gate** — new endpoints change the API surface; run
    `pnpm --filter api openapi:check` in CI and commit any regenerated
    contract artefacts the project keeps.

## Medium priority

11. **Notifications for payment decisions.** Approval/rejection currently
    writes audit + order state only; customer notification depends on the
    notifications outbox decision the codebase deliberately deferred.
12. **Evidence retention policy.** Transfer screenshots live in WhatsApp
    (owner's channel, D16); if evidence must be stored on the order, that
    is an owner decision about retention and privacy first, code second.
13. **F16 remainder** — shipping management is code-complete and now
    reachable (A01 fixed), but blocked on the approved rate table (item 4).

## Low priority / deferred by owner decision

14. Reviews system (D09/D23 deferred) — the misleading presentation was
    removed (F38); building reviews remains out of scope.
15. Blog still reads legacy Supabase services (D11 deferral).
16. Accessibility & performance were not tool-measured in this session.

## Explicitly not done (safety boundaries)

- No merge into any shared branch; no force push; no PR opened.
- No production infrastructure, database, DNS, email, or WhatsApp sends.
- No credential rotation (outside the execution gate, per owner).
