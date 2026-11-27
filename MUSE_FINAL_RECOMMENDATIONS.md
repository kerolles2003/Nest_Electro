# Final Recommendations — Prioritized Action Plan for the Owner

From the adversarial audit (2026-11-21). Ordered by what unblocks
or protects the most, not by what is easiest. Effort estimates are
engineering judgement, not commitments.

## Do first (release-blocking or money-risk)

1. **Fix the admin console's CSP chunk loading** (ADV-1).
   Thread the per-request nonce into dynamic chunk loads
   (`__webpack_nonce__` / Next.js nonce propagation), then run the
   admin Playwright suite against a **production** build and make
   it pass. Do not relax the CSP. (~1–3 days including the e2e
   wiring; framework-level care needed.)
2. **Decide the fulfilment gate** (PAY-3). If Wallet/InstaPay
   orders must be PAID before they ship — the natural reading of a
   prepaid method — say so, and the precondition plus test changes
   are a few hours. If shipping on trust is intended for known
   customers, record that as an owner decision so the exposure is
   chosen, not accidental.
3. **Supply the outstanding owner inputs**: real
   `MANUAL_PAYMENT_*` details, WhatsApp number, shipping rate
   table (D04/D05), policy texts, contact channel (D16), and the
   list of authorized payment verifiers. Nothing downstream of
   these can be finished without them.
4. **Run `pnpm audit`** on a machine where the registry allows it
   (or add an audit job to CI) and triage whatever it reports
   before release. This audit could not run it (ADV-7).

## Do next (risk reduction with high leverage)

5. **Add a Playwright job to CI** (ADV-5): the storefront suite
   against production builds at minimum; the admin suite as soon
   as item 1 lands. Both browser-level defects found so far were
   invisible to the current CI.
6. **Write the Wallet/InstaPay browser e2e** using the recipe in
   `MUSE_REMAINING_WORK.md` (shared scratch world across the two
   apps, `MANUAL_PAYMENT_*` test values in the e2e API env).
7. **Resolve `/blog`** (ADV-3): hide the chrome link until the blog
   is migrated, or make the page fail soft. A 500 on a main-nav
   link should not survive to production in either case.
8. **Fix the contrast tokens** (ADV-4): the measured failures trace
   to a few shared components (category badges at 3.93:1, muted
   text). One token pass fixes most of the ~140 flagged nodes;
   follow with the heading-order and redundant-alt cleanups.

## Do when convenient (hardening and hygiene)

9. **Add the admin queue filter for PENDING_VERIFICATION orders**
   (carried over from session 1) — the daily verification workflow
   is the business's money path; make it one click deep.
10. **Collect coverage in CI** (even report-only) so test health is
    a trend, not a count.
11. **Set a per-route JS budget** for the storefront and alert on
    regressions; current totals (~956 kB uncompressed across all
    chunks) are a baseline, not a problem.
12. **Confirm the Sharp WASM fallback installs on a real CI
    runner** (one run of the media suite there closes the session-2
    open question).

## Decisions this audit made that the owner should ratify or revert

- **Segregation of duties for payment decisions** (PAY-1,
  `a911c20`): an administrator can no longer approve/reject the
  payment on an order they placed themselves. Chosen because the
  alternative was a one-person path from screenshot to PAID. If
  the shop truly has a single admin who must also test-buy, the
  guard is a single check in `PaymentVerificationService.decide()`
  and can be softened to a warning — but that should be a recorded
  owner decision, not a silent default.
- **Terminal orders take no new payment evidence** (PAY-2,
  `a911c20`): resubmission on cancelled/returned orders is refused.
  This aligns resubmission with the decision rule the owner
  already had; no workflow change for live orders.

## What not to spend on

- Rewriting the payment workflow: it survived a dedicated attack
  suite; its remaining risks are process risks (evidence in
  WhatsApp), not code risks.
- A performance programme: measured API latencies at seed scale
  are single-digit milliseconds and no user-facing slowness was
  observed. Revisit with production data volumes.
- Chasing the dev-mode-only findings (hydration nonce, image
  opacity): production probes are clean; one confirmation pass on
  the team's own hardware suffices.
