# Muse — Remaining Work After the Autonomous Session

Branch: `muse/autonomous-engineering`. Everything below was NOT done in
this session, with the reason stated. Nothing here is silently dropped.

## Critical blockers

1. **Repository authority — RESOLVED (2026-11-21).** The owner confirmed
   `Nest_Electro` is the intended repository; the continuation session's
   work stands on it. (The `main`-branch note about
   `Nest_Electronics_Project` remains unexplained, but it no longer
   blocks this branch.)
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

## Resolved in the continuation session (2026-11-21)

- The four previously failing Jest suites are fixed or explained:
  `admin-audit-log` (intent rows excluded from the operator trail by
  default — a real defect), `money-formatting` (written gate allowance
  for a unit-adornment aria-label), `index-health` (spec expectation
  corrected to the collection it creates), `sharp-backend`
  (environment: pnpm skips the `cpu: [wasm32]` fallback package;
  verified 5/5 once present — worth one confirmation run on a real CI
  runner).
- The deterministic A05/A06 concurrency suite exists and passes against
  real persistence (see MUSE_EXECUTION_LOG.md), and the version guard
  is now an explicit `expectedUpdatedAt` token the admin form sends.
- OpenAPI artefacts were regenerated for the new endpoints; both
  contract gates pass, and the CI gates themselves were repaired so
  they can run at all (test URI, replica-set name, per-run JWT_SECRET).

## Browser-e2e findings (updated by the adversarial audit, third session)

6. **Admin console is broken by its own CSP — IN PRODUCTION TOO.**
   `script-src 'self' 'nonce-…' 'strict-dynamic'` blocks Next.js chunk
   loads that carry no nonce: 168 violations in dev mode (13/33 e2e),
   and a production-build probe still showed a blocked chunk and a
   dead user menu (ADV-1 in MUSE_ADVERSARIAL_AUDIT.md). Fix by
   threading the nonce into dynamic chunk loading
   (`__webpack_nonce__` / Next nonce propagation) and gate admin e2e
   on a production build. Do NOT relax the CSP.
7. **Product-page JSON-LD hydration error — CLOSED as dev-only.**
   Production-build probe: zero hydration errors; the JSON-LD
   scripts render with content. No fix planned; if the health gate
   keeps tripping in dev, that is a dev-experience item, not a
   product defect.
8. **Catalogue images at opacity 0 — CLOSED as dev-only (with one
   caveat).** Production-build probe: every loaded image visible,
   before and after scrolling. The dev-mode mechanism was never
   isolated; one confirmation pass on the team's own hardware is
   the only remaining step.
9. **`/blog` returns 500** whenever Supabase is unconfigured (item 16);
   the site chrome links to it, so the link check fails in any
   environment without the legacy backend. Owner decision: hide the
   link, fail soft, or migrate the blog.
10. **Wallet/InstaPay browser e2e still not written.** API-level
    coverage is complete (Jest manual-payment 11/11 + adversarial
    11/11). Recipe: add `MANUAL_PAYMENT_*` test values to the
    storefront e2e API env, drive checkout in the storefront suite,
    and verify from the admin suite against the same scratch run —
    the two suites currently boot separate worlds, so a shared
    fixture has to come first. The admin unreachable-API Playwright
    config was also not run.

## Adversarial-audit additions (third session)

- **PAY-3 (owner decision): fulfilment does not wait for payment
  verification.** A VERIFICATION_REJECTED Wallet order was
  confirmed, shipped and delivered in a test. Decide whether
  manual-transfer orders require PAID before SHIPPED; the
  adversarial suite's EVIDENCE test is the one to flip if gated.
- **Color contrast (design decision).** axe-core against the
  production storefront: `color-contrast` (serious) on every page
  tested (7–55 nodes; white on `#e14a5c` measured at 3.93:1 vs
  4.5:1). Traces to a few shared tokens/components. The critical
  `label` finding on the price filter was fixed (`d00b69f`);
  heading-order and redundant-alt items remain.
- **`pnpm audit` has never been run successfully** — the sandbox
  proxy blocks the audit endpoint. Run it in CI or on a dev
  machine and triage before release.
- **No Playwright job exists in CI.** Both browser-level defects
  found across these sessions were invisible to CI; add at least
  the storefront suite against production builds.

## High priority

11. **Admin queue filter for PENDING_VERIFICATION orders.** Verification
    actions exist on the order detail; a dedicated queue filter would make
    the daily workflow faster.

## Medium priority

12. **Notifications for payment decisions.** Approval/rejection currently
    writes audit + order state only; customer notification depends on the
    notifications outbox decision the codebase deliberately deferred.
13. **Evidence retention policy.** Transfer screenshots live in WhatsApp
    (owner's channel, D16); if evidence must be stored on the order, that
    is an owner decision about retention and privacy first, code second.
14. **F16 remainder** — shipping management is code-complete and now
    reachable (A01 fixed), but blocked on the approved rate table (item 4).

## Low priority / deferred by owner decision

15. Reviews system (D09/D23 deferred) — the misleading presentation was
    removed (F38); building reviews remains out of scope.
16. Blog still reads legacy Supabase services (D11 deferral).
17. Accessibility & performance received a static review in the
    continuation session (labels, pagination ARIA, image usage, product
    indexes) but were still not tool-measured — no Lighthouse/axe run,
    no bundle analysis.

## Explicitly not done (safety boundaries)

- No merge into any shared branch; no force push; no PR opened.
- No production infrastructure, database, DNS, email, or WhatsApp sends.
- No credential rotation (outside the execution gate, per owner).
