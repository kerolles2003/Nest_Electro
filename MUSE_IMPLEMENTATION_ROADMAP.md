# Nest Electro — Implementation Roadmap

**HEAD:** `bb7c331` on `phase-1-2-overnight` · Assessment only — nothing here has been implemented.
Complexity is given as relative size (S/M/L/XL) with assumptions, not day counts. Owner-excluded scope (Supabase remediation, Flutter, online gateway, production DB provisioning/migration, historical credential rotation) is **not** in this roadmap, per `OWNER_DECISIONS_2026-10-07.md` and the G-ENTRY scope override.

---

## Group 1 — Critical blockers

### B1. Fix API bootstrap (A01)
- **Priority:** P0 — first task. Everything else is unverifiable while the API cannot start.
- **Files/modules:** `apps/api/src/modules/users/users.module.ts`, `apps/api/src/modules/fulfilment/fulfilment.module.ts`, `apps/api/src/modules/media/media.module.ts` (add `DatabaseModule` to `imports` in each). No changes to `database.module.ts` — it is already correct.
- **Root cause:** three services (`CustomersAdminService`, `ShippingRatesAdminService`, `MediaService`) grew a `TransactionService` constructor dependency after their modules were written; the modules were never updated to import the exporting module. TypeScript cannot see this; only a runtime graph compile can.
- **Dependencies:** none. **Blocks:** every other task in this roadmap.
- **Implementation:** three one-line imports, matching the existing pattern in Auth/Catalog/Inventory/Orders modules.
- **Required tests:** new full-graph smoke test (Gap G1) — compile `AppModule` against the scratch replica set and hit `/health`. Must fail before the fix (on `UsersModule`), pass after all three.
- **Acceptance criteria:** `node dist/main.js` reaches "database connection starting" and listens; smoke test green in CI; no other module changes needed.
- **Complexity:** S. Assumption: no further missing providers hide behind the first failure — verify by booting after each import is added (Users → Fulfilment → Media order is the expected failure sequence).

### B2. Fix storefront session renewal (F01)
- **Priority:** P0 — customers lose sessions deterministically every ~15 minutes of browsing.
- **Files/modules:** `apps/storefront/src/lib/api/client.ts`, `apps/storefront/src/lib/api/session.ts`, new `apps/storefront/src/app/session/renew/route.ts`; pattern copied from `apps/admin/src/lib/api/renewal.ts` + `apps/admin/src/app/session/renew/`.
- **Root cause:** renewal (a cookie write) is attempted inside Server Component rendering, where Next.js forbids cookie mutation; the API has already rotated/burned the refresh token by then, so the session is destroyed, not just unrenewed.
- **Dependencies:** B1 (needs a running API to verify end-to-end).
- **Implementation:** on a renewable 401 during render, redirect to the renewal Route Handler; the handler performs the refresh exactly once, writes both cookies, and redirects back to a validated local `next` path (reuse admin's `safeNextPath` discipline). Remove `writeSession`/`clearSession` calls from the render path.
- **Required tests:** e2e — expire the access cookie, load a page, assert the user stays signed in and lands back on the same page; concurrent-prefetch case asserting no `REFRESH_TOKEN_REUSED` revocation.
- **Acceptance criteria:** a signed-in session survives access-token expiry on every route, including the root layout's viewer resolution; no cookie writes occur during render (assert by test/log).
- **Complexity:** M. Assumption: admin's implementation transfers with only basePath differences (storefront has none).

---

## Group 2 — Security & financial integrity

### S1. Make product update atomic and race-safe (A05 + A06)
- **Priority:** P1.
- **Files/modules:** `apps/api/src/modules/catalog/application/product-admin.service.ts` (`update()`), reusing `TransactionService`, `SlugRedirect` recording, `recount`, and `AuditService` session parameters as the delete/restore paths in the same file already do.
- **Root cause:** `update()` predates / bypasses the transactional pattern used by its sibling methods: no transaction, no version predicate, sequential post-commit side effects, and a `?? current` fallback that masks a missed write.
- **Dependencies:** B1.
- **Implementation:** wrap the whole update (product write + slug redirect + recount + audit change) in `transactions.run`, thread the session through every write, add a version/`updatedAt` predicate to the update filter, throw `AppException.concurrentModification()` on a zero-match, delete the `?? current` fallback.
- **Required tests:** two concurrent updates — exactly one wins, the loser gets 409; failure injected at redirect/recount/audit step — product write rolls back; price-change audit row exists iff the price change committed.
- **Acceptance criteria:** no interleaving or injected failure can produce a renamed product without its redirect, stale counts, or a missing price-change audit row.
- **Complexity:** M. Assumption: `redirects.record` and `recount` can accept a session parameter without signature redesign (their neighbours already do).

### S2. Remove unverified-review claims (F38 safety branch)
- **Priority:** P1 (small, high trust impact). This is the D09/D23 *safety* branch only — **not** building a review system.
- **Files/modules:** `apps/storefront/src/app/products/[slug]/page.tsx` ("verified reviews" copy), `apps/storefront/src/lib/json-ld.ts` (`aggregateRating` emission), `apps/storefront/src/lib/api/view-model.ts` (rating presentation rules).
- **Root cause:** rating average/count are stored product fields with no provenance, rendered with the word "verified" and emitted as structured data.
- **Dependencies:** none in code; the keep/remove decision for displaying bare averages is an owner call (D23/D24).
- **Implementation:** drop "verified"; suppress `aggregateRating` JSON-LD until a provenance-backed source exists; keep the existing "render nothing when count = 0" behaviour.
- **Required tests:** snapshot/assertion test that product JSON-LD contains no `aggregateRating` and the page contains no "verified" claim.
- **Acceptance criteria:** no surface claims verification that the system cannot support.
- **Complexity:** S.

### S3. Fix the admin slug check (A07)
- **Priority:** P1 (tiny fix, daily-use admin path).
- **Files/modules:** `apps/admin/src/components/products/ProductForm.tsx` (fetch URL + `response.ok` check). Import `BASE_PATH` from `@/lib/api/renewal`.
- **Root cause:** browser fetch ignores the `/admin` basePath; transport 404 is then swallowed into the same "unknown" state as an API-declared unknown.
- **Dependencies:** B1 for end-to-end verification.
- **Implementation:** fetch `${BASE_PATH}/api/check-slug`; branch on `response.ok` before `response.json()`; keep the fail-closed `available: null` semantics for genuine API failures.
- **Required tests:** admin e2e — type a taken slug and a free slug in the product form, assert both states render; unit test for the built URL.
- **Acceptance criteria:** slug status in the form reflects the API answer under the deployed basePath.
- **Complexity:** S.

---

## Group 3 — Backend architecture

### A1. Full-graph test gate + CI on feature branches
- **Priority:** P1. **Files:** new `apps/api/test/infrastructure/bootstrap.spec.ts`; `.github/workflows/ci.yml` (extend triggers beyond `main`).
- **Root cause:** partial-graph suites + main-only CI let A01 survive. **Dependencies:** B1. **Implementation/tests/acceptance:** the smoke test from B1 runs in CI on every push; a deliberately broken module import fails the build. **Complexity:** S–M. **Blocks:** nothing, but it is the guard that keeps Groups 1–2 fixed.

### A2. Decide the notifications trade-off explicitly (outbox)
- **Priority:** P2 — decision task, not a build task. **Files:** `apps/api/src/modules/notifications/application/notifications.service.ts` (documented no-retry/no-outbox design).
- **Root cause:** a deliberate design decision whose operational cost (lost order confirmations on provider failure, no trace) grows with real order volume.
- **Dependencies:** owner decision (D14/D30 inputs: provider, templates matrix). **Implementation:** if accepted as-is, pin current failure behaviour with a test (Gap G10); if reversed, design a transactional outbox written inside the checkout transaction with a retry worker. **Complexity:** S for the decision+test; L if the outbox is built. Present both; do not silently build.

---

## Group 4 — Storefront

### F1. Category & brand pagination (F18 remainder)
- **Priority:** P2. **Files:** `apps/storefront/src/app/categories/[slug]/page.tsx`, `apps/storefront/src/app/brands/[slug]/page.tsx`; reuse the listing page's search-params + pagination component pattern.
- **Root cause:** both pages were migrated with a fixed `page: 1, limit: 24` fetch and never received the listing's pagination treatment.
- **Dependencies:** B1/B2 for realistic verification. **Tests:** e2e with a category of >24 products asserting product #25 is reachable. **Acceptance:** every catalogue surface (listing, search, category, brand) paginates consistently. **Complexity:** S–M.

### F2. Make the contact form honest (F17)
- **Priority:** P1 — it is actively discarding customer messages today.
- **Files:** `apps/storefront/src/app/contact/page.tsx`; delivery via the existing email provider port (API endpoint + Notifications) **or** replacement with the WhatsApp support channel.
- **Root cause:** a placeholder UI was shipped as if finished (`setTimeout` simulation + success copy).
- **Dependencies:** owner input — real WhatsApp number / support inbox (D16, still open). Until that input exists, the interim fix is to remove the fake submission and success claim and show the support channel honestly.
- **Tests:** submission produces a delivery attempt (or the form no longer exists); no success message without a delivery result.
- **Acceptance:** no customer can be told a message was sent when it was not. **Complexity:** S (interim honesty fix) / M (full wired form).

---

## Group 5 — Admin operations

### AD1. Shipping rates: configuration, not code (F16 remainder)
- **Priority:** P2. **Files:** none initially; `shipping:seed` data + admin Settings → Shipping Rates table.
- **Root cause:** the code is complete; the *data* is development seed, and D04/D05 rate table + free-shipping threshold are open owner inputs.
- **Dependencies:** B1; owner rate table. **Implementation:** owner approves the 27-governorate table; load it as configuration in each environment; add a checkout test for an unseeded governorate returning a clean, customer-readable error instead of a 500 (Gap G6).
- **Acceptance:** every governorate quotes a fee (or an intentional free rate) in production config; no invented rates. **Complexity:** S once the owner table exists.

### AD2. A03 — no task
The reported 1 MB limit does not exist at this HEAD (5 MB, consistent in API/config/UI). Raising to 10 MB is an owner product decision; if approved it is a three-place constant change (controller, media config, admin UI) guarded by the existing equality spec. Not scheduled as a defect fix.

---

## Group 6 — Customer journey: Wallet / InstaPay manual verification (the big build)

### P1. Payment domain extension
- **Priority:** P1 after blockers — the largest missing approved feature (D01/D03).
- **Files/modules:** `apps/api/src/modules/orders/domain/order-status.ts` (add methods `WALLET`, `INSTAPAY` to `PaymentMethod`; add `PENDING_VERIFICATION` and a rejected/verification state mapping per D03 — reuse existing states where the owner record allows, do not duplicate states to match labels), `apps/api/src/modules/orders/infrastructure/schemas/order.schema.ts` (payment subdocument: method, status, transfer sender identifier, evidence reference, verifiedBy/verifiedAt, rejection reason), checkout DTOs.
- **Root cause:** the commerce core was built COD-only; the approved manual-transfer model was never implemented.
- **Dependencies:** B1. Owner inputs (blocking, D01/D16): receiving wallet numbers / InstaPay address, WhatsApp destination number, authorized verifier assignments. **Do not invent any of these.**
- **Implementation notes:** COD path must remain byte-for-byte behaviourally unchanged; manual-transfer orders are created in `PENDING_VERIFICATION` and must not enter fulfilment-as-paid flows; delivery must not auto-mark a manual-transfer order PAID (the COD rule "DELIVERED implies PAID" applies to COD only — gate it on `method`).
- **Tests:** state-machine tests for every legal/illegal transition per method. **Complexity:** M.

### P2. Checkout flow for Wallet/InstaPay
- **Files:** storefront checkout (`apps/storefront/src/app/checkout/`, `components/checkout/CheckoutForm.tsx`, actions), API checkout service (`checkout.service.ts` — accept `paymentMethod`, branch order creation).
- **Implementation:** method selector (COD / Wallet / InstaPay); on placement with a manual method, show configured transfer instructions + a WhatsApp deep link pre-filled with order number, total, and reference; the order confirmation and order-detail pages show "awaiting verification" state truthfully. The WhatsApp action changes **no** payment state.
- **Tests:** e2e placement for each method asserting resulting payment status; assertion that no client action can set PAID. **Complexity:** M. **Depends on:** P1 + owner inputs.

### P3. Admin verification queue & actions
- **Files:** API admin orders (`order-lifecycle.service.ts`, `admin-orders.controller.ts` — new verify/reject operations), admin UI (`apps/admin/src/components/orders/OrderDetail.tsx`, orders list filter for `PENDING_VERIFICATION`).
- **Implementation:** approve/reject as dedicated authorized operations (ADMIN/SUPER_ADMIN, role re-checked server-side); approval is a guarded atomic transition (`status: PENDING_VERIFICATION → PAID` with version/state predicate) making duplicate/concurrent approvals safe — the second approver gets a conflict, not a second PAID; amount shown beside the order total for mismatch checking; rejection records a reason, never marks PAID, and leaves the order resubmittable (D03); every action writes an audit row with actor, evidence reference, and outcome.
- **Tests:** unauthorized role cannot approve; double-approve and concurrent-approve races; approve-after-cancel refused; reject → resubmit → approve happy path; audit rows asserted for each.
- **Acceptance:** no path — UI, API, WhatsApp, delivery transition — can set a manual-transfer order to PAID except one authorized admin approval, exactly once.
- **Complexity:** M–L. **Depends on:** P1, P2.

---

## Group 7 — Testing & quality

- **T1 (P1):** bootstrap smoke gate (A1/G1). **T2 (P1):** storefront renewal e2e (G2) landing with B2. **T3 (P2):** shared pagination regression across the four catalogue surfaces (G8). **T4 (P2):** concurrency/failure-injection suites for product update (G4) landing with S1. **T5 (P2):** a11y checks (axe) in both e2e suites and a basic performance budget (G12) — measurement first, thresholds after one baseline run.

## Group 8 — Operational readiness (owner-input driven)

- **O1 (P2):** email provider account + sender/domain verification (D14/D21) — external dependency, not code.
- **O2 (P2):** durable media provider configuration + retention ownership (D15/D25).
- **O3 (P2):** WhatsApp number + staffing for support/evidence channel (D16) — also unblocks F2 and P2 configuration.
- **O4 (P3):** legal/policy texts (D17), returns windows/fees (D02), tax/invoice legal input (D13) — required before launch, not before development.
- **O5 (P3):** RPO/RTO + backup ownership (D19), hosting/domains/TLS (D20/D21), capacity/SLO targets (D29) — required for any production-readiness claim.

## Deferred production infrastructure (explicitly out of scope now)

Production database provisioning/migration/cutover, deployment/CD, online payment gateway, Flutter, Supabase remediation, historical credential rotation, coupons/reviews/blog/campaign feature builds (safety branches only, per D08–D11). These re-enter the roadmap only on a new owner authorization, per the decisions record.
