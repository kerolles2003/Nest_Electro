# Release Readiness Report — Adversarial Audit (2026-11-21)

Scope note: this report assesses the **code and its verification** on
`muse/autonomous-engineering` at the end of the third session.
Production infrastructure, a production database, deployment, and
real payment channels are out of scope by owner decision and are
listed as blockers only where a release would need them.

## Verified capabilities (evidence-backed)

- **Commerce core**: catalogue, cart, checkout (COD + Wallet/
  InstaPay), order lifecycle, inventory ledger — covered by the
  Jest suite against real MongoDB transactions, including
  adversarial race suites added this session (29 new tests).
  Post-session regression: 71/73 suites, 1461/1477 tests; the one
  failure was a formatting-gate allowance for this session's own
  accessibility fix, registered and re-verified green (see
  `MUSE_TEST_EVIDENCE.md`).
- **Manual payment workflow**: amount-matched, authorized from the
  database profile, concurrency-safe, audited in the same
  transaction, segregation of duties enforced (PAY-1 fix).
- **API security posture**: injection, IDOR, mass assignment,
  checkout body injection, token forgery and error-leakage probes
  all refused (14/14); strict helmet headers; fail-closed CORS;
  fail-fast environment validation.
- **Builds and contracts**: all three production builds pass;
  type-checks pass; OpenAPI drift and page gates pass; secret scan
  clean.
- **CI**: lint, type-check, build, full-Jest transaction gate and
  contract gates are real and runnable (repaired in session 2 and
  re-read this session).

## Critical blockers (release cannot proceed)

1. **Owner inputs are still missing** (unchanged since session 1):
   real `MANUAL_PAYMENT_*` receiving details and WhatsApp number;
   the shipping rate table (D04/D05); policy texts; the contact
   channel decision (D16); the authorized-verifier list. Without
   these the store cannot take a real order end-to-end.
2. **No production database or deployment exists** — by owner
   decision, and still a hard prerequisite for any release.
3. **Admin console chunk loading is broken under its own CSP in
   the production build** (ADV-1). An operator console that cannot
   open its own menus is not releasable; the fix (nonce propagation
   to dynamic chunks) must land and the admin e2e must pass against
   a production build before release.

## High-risk issues

4. **Fulfilment does not wait for payment verification** (PAY-3 /
   ADV-2): goods can be delivered against a rejected Wallet payment.
   Needs an explicit owner decision; if the answer is "gate it",
   the change is small and the test to flip already exists.
5. **Dependency vulnerabilities unknown**: `pnpm audit` could not
   run in this environment (ADV-7). A release decision made without
   a dependency scan is a blind spot, not a clean bill.

## Medium-risk issues

6. **`/blog` returns 500** whenever the legacy backend is
   unconfigured, and the chrome links to it everywhere (ADV-3).
7. **No browser e2e in CI** (ADV-5): the two browser-level defects
   found across these sessions were both invisible to CI.
8. **Color contrast fails across the storefront** (ADV-4): serious
   axe impact on every page measured; a design-token decision.
9. **Wallet/InstaPay browser e2e still unwritten**: the highest-value
   user journey has API-level proof only.

## Low-risk issues

10. Heading-order violations on auth/cart pages; redundant alt text
    on the home page (ADV-4).
11. No per-route bundle budget; total client JS is ~1 MB
    uncompressed per app — unremarkable, unmonitored.
12. Coverage percentages are not collected anywhere; test counts
    are the only test-health signal.

## Environment-specific failures (not product defects)

- JSON-LD nonce hydration errors — dev mode only; production probe
  clean (ADV-6).
- Catalogue images at opacity 0 — dev mode only; production probe
  clean (ADV-6).
- Sharp WASM fallback packaging (session 2) — sandbox/pnpm
  behaviour; expected to install normally on a fresh CI runner,
  still worth one confirmation run there.
- Sandbox proxy blocks the npm audit endpoint (ADV-7) and some
  external image requests during probes.

## Owner decisions required

1. Gate fulfilment on PAID for Wallet/InstaPay? (PAY-3)
2. Provide the session-1 owner inputs (blocker 1) — payment
   receiving details, shipping rate table, policy texts, contact
   channel, verifier list.
3. Blog: hide the link, fail soft, or migrate off the legacy
   backend? (ADV-3)
4. Admin CSP fix approach: nonce propagation work is a project
   task — schedule it before any release that includes the
   console. (ADV-1)
5. Accept or adjust the new segregation-of-duties rule (PAY-1):
   an admin can no longer verify a payment on their own order.
   Reversible in one place if the owner prefers a warning instead.

## Bottom line

The backend and the payment workflow are in genuinely good shape —
this audit attacked them and mostly lost. The release is blocked
less by code quality than by three concrete things: the missing
owner inputs, the absent production environment, and an admin
console that does not fully work in its production build. Fix
ADV-1, decide PAY-3, supply the inputs, and run the dependency
audit — in that order — and the remaining gap to a defensible
release is mostly operational, not engineering.
