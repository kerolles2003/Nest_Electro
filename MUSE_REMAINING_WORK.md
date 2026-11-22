# Muse — Remaining Work After the Autonomous Session

Branch: `muse/autonomous-engineering`. Everything below was NOT done in
this session, with the reason stated. Nothing here is silently dropped.

## Overnight session closures (2026-11-22, all in the working tree)

- **Segregation of duties is now an OWNER-APPROVED policy**
  (2026-11-22): an admin cannot approve OR reject payment evidence
  for an order they placed. The API already enforced both (403,
  before any mutation); this session added the missing pieces —
  the refused attempt is now AUDITED (an ORDER_PAYMENT_CHANGED row
  with outcome `refused`, reason `SEGREGATION_OF_DUTIES`, written
  outside the aborting transaction so it survives), tests cover
  rejection and the audit record, and the console explains the
  restriction in advance on the payment panel and disables the
  decision buttons for the order's owner. No longer a pending
  decision.
- **Order DTO null-safety (pre-commit review finding F-1) — FIXED.**
  `OrderDto.payment` and `OrderSummaryDto.payment` are now honestly
  nullable; a corrupt order without a payment subdocument serialises
  with `payment: null` instead of 500ing the admin queue/detail and
  the customer's order page. Both frontends render an explicit
  "payment data missing" state. (Correction to the review's F-1:
  there is ONE shared mapper — `AdminOrderDto` extends `OrderDto` —
  plus the summary mapper; the admin DTO file itself contains no
  payment code.)
- **Payment-review queue filter** (item 11) and **color contrast**
  — closed; see their entries below.
- A JSX whitespace defect in OrderDetail ("cancelled ispossible")
  was found by screenshot review and fixed.

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

6. **Admin CSP defect (ADV-1) — FIXED in the remediation session
   (working tree, uncommitted).** Root cause: the `RefreshButton`
   chunk — the console's only client leaf under a server module —
   was hoisted into page HTML without the request nonce and blocked
   by `strict-dynamic` on every cold sub-route load. Fixed by
   registering the module in the dashboard layout's client graph
   (one load-bearing import in `(dashboard)/layout.tsx`); verified
   on the production build: 0 violations on all 11 routes, Sign Out
   works, CSP untouched. See `MUSE_CSP_REMEDIATION_REPORT.md`.
   Remaining guard: gate admin e2e on a production build in CI so a
   future lone client leaf cannot reintroduce this silently.
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

- **PAY-3 — DECIDED, IMPLEMENTED, and made FAIL-CLOSED
  (working tree, uncommitted).** The independent review found the
  first gate fail-open on a missing payment subdocument; the
  2026-11-22 session replaced it with a validator
  (`assertPaymentGate`): missing/null/unrecognized payment data
  is refused with a structured 422 on CONFIRMED, SHIPPED and
  DELIVERED, unknown data is never read as COD, and the delivery
  effect reads the method fail-closed. Evidence:
  `MUSE_PAY3_FAIL_CLOSED_REMEDIATION_REPORT.md` and the 12-test
  `pay3-fail-closed.spec.ts`. The same session audited all 37
  Admin Server Actions + 2 route handlers for authorization
  independent of the navigation proxy — all PASS, no bypass, no
  code changed (`MUSE_SERVER_ACTIONS_AUTHORIZATION_AUDIT.md`). The owner ruled manual-transfer
  orders must be PAID before fulfilment; the gate lives in
  `OrderLifecycleService.apply()` (422
  `PAYMENT_REQUIRED_BEFORE_FULFILMENT` on CONFIRMED/SHIPPED for
  unpaid Wallet/InstaPay; COD untouched), with a 10-scenario suite
  (`test/orders/pay3-fulfilment-gate.spec.ts`). See
  `MUSE_PAY3_REMEDIATION_REPORT.md`. Follow-ups: annotate
  `ORDER-LIFECYCLE.md` with the decision; the admin
  PENDING_VERIFICATION queue filter (item 11) is now the natural
  companion so operators verify before they try to fulfil.
- **Color contrast — CLOSED in the overnight session (2026-11-22,
  working tree).** axe-core against the production storefront now
  reports ZERO `color-contrast` violations on the home page and
  /products (was: every page, 21–24 nodes measured this session).
  Fixes: `--color-primary` deepened `#e14a5c` → `#cf3549` (4.93:1,
  hue preserved; hover `#b82a40`); the shared ProductCard sale badge
  used a hardcoded `#E14A5C` and now uses `bg-primary`;
  `--color-foreground-subtle` darkened `#9ca3af` → `#64707e`;
  a rating-count label no longer compounds `opacity-80` onto muted
  text; the footer's eyebrow on dark chrome uses a new
  `--color-primary-bright` token (7.64:1). Remaining axe items are
  heading-order and redundant-alt (unchanged, low severity).
- **`pnpm audit` has never been run successfully** — the sandbox
  proxy blocks the audit endpoint. Run it in CI or on a dev
  machine and triage before release.
- **No Playwright job exists in CI.** Both browser-level defects
  found across these sessions were invisible to CI; add at least
  the storefront suite against production builds.

## High priority

11. **Admin queue filter for PENDING_VERIFICATION orders — DONE in
    the overnight session (2026-11-22, working tree).** The API queue
    gained a `paymentStatus` filter (enum-narrowed, repeatable; the
    repository applies it on `payment.status`), and the console gained
    a "Payment review" toggle in QueueFilters. Verified end-to-end in
    the browser against a seeded stack: the toggle narrowed 3 orders
    to exactly the 2 awaiting verification. API test in
    `admin-orders.spec.ts`.

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
