# Adversarial Audit — Quality, Security, Performance, Accessibility, Reliability

Third session (2026-11-21), acting as an independent QA / AppSec /
performance / release team against the work of the first two sessions.
Starting HEAD `1a9d76f` (17 commits). Stance: the previous sessions'
own claims were treated as unproven until re-tested. Three new
adversarial Jest suites (29 tests) were written for this audit and run
against real persistence; two production-mode Playwright probes were
built and run; accessibility was measured with axe-core; performance
was measured against the built artifacts and a seeded API.

Companion documents: `MUSE_PAYMENT_SECURITY_AUDIT.md` (payment
detail), `MUSE_TEST_EVIDENCE.md` (commands, counts, environments),
`MUSE_RELEASE_READINESS_REPORT.md` (release view),
`MUSE_FINAL_RECOMMENDATIONS.md` (action plan).

## Headline results

- **Two real payment defects found and fixed** (self-approval;
  resubmission on cancelled orders) — `a911c20`. Details in the
  payment audit.
- **One production-impacting defect confirmed**: the admin console's
  CSP blocks a lazily-loaded chunk **in the production build too**,
  and the user menu is dead there (ADV-1). Previously mis-classified
  as a dev-only annoyance; it is not.
- **The backend held** against the injection / IDOR / mass-assignment
  / forgery battery: 14/14 security probes pass, 4/4 integrity races
  pass.
- **Accessibility is the weakest measured area**: pervasive
  color-contrast failures on every storefront page tested; one
  critical labelling defect found and fixed (ADV-4).

## Findings register

### ADV-1 — HIGH — Admin console: CSP blocks chunks in PRODUCTION; parts of the UI never hydrate

- **Component**: `apps/admin` under the shared CSP
  (`script-src 'self' 'nonce-…' 'strict-dynamic'` from
  `packages/config`).
- **Reproduction**: production build served with `next start`;
  sign in as the seeded admin; open `/admin/orders`.
- **Observed (this session)**: 1 CSP violation — chunk
  `09s5_6c4yp62j.js` blocked because `strict-dynamic` disables
  host-based allowlisting and the chunk carries no nonce — and the
  user menu does not open; "Sign out" never appears. In dev mode the
  same mechanism produced 168 violations and 20/33 failing e2e tests
  (session 2).
- **Expected**: every script the app itself loads is trusted via the
  per-request nonce, in both modes.
- **Impact**: whichever screens depend on the blocked chunks are
  broken for real operators in production, not just in e2e. The
  console cannot be considered releasable until this is fixed and
  the admin e2e passes against a production build.
- **Recommended fix**: thread the request nonce into webpack's chunk
  loading (`__webpack_nonce__`) or adopt Next.js's documented nonce
  propagation for dynamic imports; then gate admin e2e on the
  production build in CI. **Do not weaken the CSP** — it is doing
  its job; the app is failing to use it.
- **Status**: OPEN (framework-level change; not attempted in this
  session because a wrong fix here either breaks the build or
  silently weakens the policy).

### ADV-2 — HIGH (business risk) — Fulfilment does not wait for payment verification

Recorded as PAY-3 in the payment audit. A rejected-payment Wallet
order was confirmed, shipped and delivered end-to-end in a test.
Owner decision required (gate SHIPPED on PAID for prepaid methods?).

### ADV-3 — MEDIUM — Storefront `/blog` returns 500 whenever the legacy backend is unconfigured

- The site chrome links to `/blog` on every page; the blog reads
  legacy Supabase services (owner-deferred, D11) and hard-fails with
  a 500 when they are unconfigured.
- A linked page returning 500 (rather than degrading or 404ing) is a
  genuine product robustness defect in any environment that lacks
  the legacy backend — including a future production deploy that
  drops those credentials.
- Not fixed: the brief forbids modifying the excluded Supabase scope
  to make this pass. The minimal owner-approved options are in the
  recommendations (hide the link until the blog is migrated, or make
  the page fail soft).

### ADV-4 — Accessibility: one critical defect fixed; contrast is pervasive and open

Measured with axe-core 4.11.3 against the **production** storefront
build (6 pages; see Test Evidence for method and variance notes).

- **FIXED (`d00b69f`)**: `label` (critical) — the catalogue price
  filter's two range inputs had no label at all. Both now carry
  `aria-label` + `aria-valuetext`. Verified gone on re-run.
- **OPEN — `color-contrast` (serious) on every page tested**: home
  51 nodes, /products 55, product page 25, login 9, register 8,
  cart 7. Measured example: white bold 12px text on `#e14a5c`
  (category badges) at **3.93:1** vs the 4.5:1 requirement. This is
  a design-token problem (a handful of shared components repeated),
  so the node counts overstate the number of distinct fixes — but
  it is real, user-facing, and needs a design decision, not a
  sweep of inline styles.
- **OPEN — `heading-order` (moderate)** on login/register/cart and
  **`image-redundant-alt` (minor)** on home.
- No WCAG compliance claim is made: axe covers only part of the
  standard, the admin console was not axe-tested (blocked by
  ADV-1), and keyboard/screen-reader passes were not performed.

### ADV-5 — MEDIUM — Browser e2e runs nowhere in CI (false-green gap)

CI runs lint, type-check, builds, the full Jest suite (via the
transaction gate) and the OpenAPI contract gates — genuinely
meaningful protection. But no Playwright job exists, so "CI green"
says nothing about the apps working in a browser. Both browser-level
defects found across these sessions (guest-cart doubling; ADV-1)
were invisible to CI. Recommendation in the release report.

### ADV-6 — LOW — Dev-only defects confirmed as dev-only (with production evidence)

- **JSON-LD nonce hydration error** (4 storefront dev-e2e failures):
  production-mode probe shows **zero** hydration errors and the
  JSON-LD scripts render with content. Dev-only.
- **Catalogue images at opacity 0** (1 dev-e2e failure): production
  probe — every loaded image visible, including before scrolling.
  Not reproduced in production mode. The dev-mode mechanism was not
  isolated; classification: development-environment artifact, with
  the caveat that the team's own hardware should confirm once.
- **`/blog` 500** is NOT in this category — see ADV-3.

### ADV-7 — LOW — Dependency vulnerability scan could not be performed in this environment

`pnpm audit` is blocked by the sandbox's registry proxy (403
policy denial on the audit endpoint). **Not verified** — it must be
run in CI or on the owner's machine; the lockfile is frozen in CI,
which limits drift but says nothing about known CVEs.

## Backend security assessment (summary; evidence in Test Evidence)

New suite `test/security/security-adversarial.spec.ts` — 14/14 pass:

- NoSQL operator injection via JSON bodies (login, cart) refused
  with 400; query-string operators on the catalogue are not honoured
  (a `brand[$ne]=…` probe returns zero items, not the catalogue).
- Checkout body injection (`payment.status`, `status`, `pricing`,
  `grandTotal` fields) refused as UNKNOWN_FIELD; no order created.
- Checkout with another customer's address refused; no order.
- IDOR: a foreign order is indistinguishable from a nonexistent one
  (same 404 and error code); foreign cancel refused; customers get
  403 on admin order views.
- Mass assignment on profile update (role, email, verification
  state) refused; the account row is unchanged afterwards.
- Audit logs expose no mutation route even to an admin (DELETE and
  PATCH are 404); customers cannot read the trail (403).
- `alg=none` JWT claiming SUPER_ADMIN rejected (401) on both a
  profile route and an admin route.
- Error envelopes leak nothing: no driver errors, no stack traces,
  no file paths across malformed-id, missing-resource and
  malformed-JSON probes.
- Pagination `limit` is capped at the documented maximum (100).

Pre-existing coverage this audit relied on rather than duplicated:
auth flows, refresh-token rotation with family revocation on replay,
rate limits at production numbers, roles guard incl. token-version
invalidation, and media upload validation (MIME spoofing, SVG,
oversize, EXIF) — all in `apps/api/test/auth` and `test/media`, all
green in the regression run.

Transport-level checks against the real built server (not the test
harness): helmet headers are strict (CSP `default-src 'none'`, HSTS
one year, `nosniff`, frame denial); CORS fails closed —
`CORS_ORIGINS` defaults to empty because the topology is
server-to-server, and a preflight from an unconfigured origin
receives no `Access-Control-Allow-Origin`.

## Database integrity (summary)

New suite `test/database/integrity-adversarial.spec.ts` — 4/4 pass,
all assertions on persisted state: concurrent double-cancel restores
stock exactly once (one CANCELLATION ledger event); concurrent
duplicate-SKU creation yields one product and one clean 4xx (never a
500, never two rows); checkout against a product deleted after
carting is refused with no stock movement; a double-submitted
checkout with two *different* idempotency keys creates exactly one
order. Together with the pre-existing checkout race (limited stock)
and same-key idempotency race, the money/stock invariants held under
every race this audit could construct.

## Performance (measured; method in Test Evidence)

- API, seeded catalogue, warm, localhost: medians **1–9 ms** across
  list/detail/search/category/health endpoints. Healthy at seed
  scale; explicitly not evidence about production data volumes.
- Client JS on disk (all chunks, uncompressed): storefront **956 kB
  / 36 files**, admin **1076 kB / 31 files**; largest single chunk
  227 kB in both (shared framework code). No per-route budget exists
  in the project; setting one is a recommendation, not a finding of
  excess.
- No Lighthouse run (not available in this environment) and no
  optimisation was implemented: there is no measured problem to fix.

## What this audit did NOT verify

- Dependency CVEs (ADV-7). Test-coverage percentages (not measured).
- Admin functionality beyond the login + orders + menu probe
  (blocked by ADV-1 for browser-level work; API-level admin coverage
  is in the Jest suite).
- Wallet/InstaPay browser e2e (still unwritten; API coverage 11/11 +
  adversarial 11/11).
- Production infrastructure, real data volumes, real email/WhatsApp
  delivery — all out of scope by owner decision.
