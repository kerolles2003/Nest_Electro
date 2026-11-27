# Nest Electro — Findings Verification

**Repository:** `kerolles2003/Nest_Electro`, branch `phase-1-2-overnight`
**HEAD audited:** `bb7c331df1ff61a181407f5d1ede863ef34a4af8` ("docs: add GIT_HANDOFF_REPORT.md for Muse")
**Method:** full local clone (repo made public by owner), source inspection, `pnpm install --frozen-lockfile`, TypeScript checks on all three apps, secret scan, and an actual API bootstrap attempt against a dummy MongoDB URI. No application code was modified.
**Note on scope:** `main` (19c3030) says the project later moved to `Nest_Electronics_Project`. This audit covers exactly the branch the owner linked. If work continued in the other repo, these verdicts must be re-checked there.

---

## A01 — API bootstrap dependency resolution

**Classification: CONFIRMED — and wider than previously reported. Runtime-reproduced.**

Previous reports framed A01 as "`TransactionService` is not provided/exported by `DatabaseModule`". That framing is wrong: `apps/api/src/database/database.module.ts` (lines 146–147) correctly declares `providers: [TransactionService, IndexHealthService]` and exports both.

The real defect is on the consumer side. Three modules provide a service whose constructor injects `TransactionService` but never import `DatabaseModule`:

| Module | Service injecting `TransactionService` | Imports `DatabaseModule`? |
|---|---|---|
| `apps/api/src/modules/users/users.module.ts` | `CustomersAdminService` (`customers-admin.service.ts:97`) | **No** |
| `apps/api/src/modules/fulfilment/fulfilment.module.ts` | `ShippingRatesAdminService` (`shipping-rates-admin.service.ts:45`) | **No** |
| `apps/api/src/modules/media/media.module.ts` | `MediaService` (`media.service.ts:69`) | **No** |

Modules that do it correctly: Auth, Catalog, Inventory, Orders.

**Runtime evidence (this audit, 2026-11-21):** after `nest build` (exit 0) and `tsc --noEmit` (exit 0 — DI is a runtime graph, so this bug is invisible to the compiler), launching `node dist/main.js` with a valid generated JWT secret and a dummy MongoDB URI failed during `NestFactory.create` with:

```
UnknownDependenciesException: Nest can't resolve dependencies of the
CustomersAdminService (UserModel, OrderModel, AuditService, ?).
Please make sure that the argument TransactionService at index [3]
is available in the UsersModule module.
```

The API therefore **cannot start at all** in its current state — this is not a degraded mode. Fixing only `UsersModule` would surface the identical failure next in Fulfilment, then Media.

**Business impact:** total. No API → no storefront commerce, no admin, no checkout.
**Recommended fix:** add `DatabaseModule` to the `imports` of `UsersModule`, `FulfilmentModule`, and `MediaModule`; add a regression test that compiles the full `AppModule` graph (see Roadmap task B1).

---

## F01 — Storefront SSR session renewal

**Classification: CONFIRMED, with the mechanism corrected. The version in `MUSE_HANDOFF.md` ("SSR cookie crash on first visit") is NOT REPRODUCIBLE.**

What does *not* exist: a first-visit crash. `apps/storefront/src/proxy.ts` only calls `request.cookies.has('nest_rt')` (presence check, safe), and `readSession()` in `apps/storefront/src/lib/api/session.ts` returns `null` cleanly when no refresh cookie exists.

What *does* exist is worse. `apiFetch` in `apps/storefront/src/lib/api/client.ts` (lines ~175–201) performs silent refresh inline: on a 401 `TOKEN_EXPIRED`/`TOKEN_INVALID` it calls `refreshSession()`, then `writeSession()`, which calls `cookies().set()` from `next/headers`. `apiFetch` is used during Server Component rendering — e.g. the root layout calls `readViewer()` → `tryApi(() => api.currentUser())` on every page.

In Next.js, cookies may only be modified in a Server Action or a Route Handler. During a page render, `cookies().set()` throws. The sequence is therefore:

1. Access token expires (15-minute TTL — this happens constantly).
2. Server-side refresh succeeds; the API **rotates and burns the old refresh token**.
3. Persisting the new pair throws because the render context cannot write cookies.
4. The new refresh token is lost; the old one is already invalid. A later use of the old token is treated by the API as `REFRESH_TOKEN_REUSED` — suspected theft — which can revoke the whole token family.

Net effect: signed-in customers are silently signed out (viewer resolves to `null` via `tryApi`), and the session is destroyed rather than renewed.

**Proof this is a known-shaped problem:** the Admin app already solved it correctly — `apps/admin/src/lib/api/renewal.ts` documents exactly this constraint and implements renewal as a redirect to a Route Handler (`/admin/session/renew`, `apps/admin/src/app/session/renew/`) precisely because "renewing means writing two cookies, and there are exactly two places in a Next application allowed to do that: a Server Action and a Route Handler. A page render is neither — it throws — which is the bug this replaces." The storefront never received the same treatment.

**Business impact:** high. Any customer whose access token expires mid-browsing loses their session; checkout/account flows degrade unpredictably.
**Recommended fix:** port the admin pattern to the storefront — a `/session/renew` Route Handler + redirect, single-flight by construction; remove cookie writes from the render path in `client.ts`.

---

## A03 — Admin image upload size limit

**Classification: NOT REPRODUCIBLE as reported (the "1 MB" claim is a FALSE POSITIVE at this HEAD).**

At HEAD the limit is a consistent **5 MB** in all three places:

- API: `apps/api/src/modules/media/presentation/media.controller.ts:56` — `MAX_UPLOAD_BYTES = 5 * 1024 * 1024`, enforced by Multer `FileInterceptor` `limits.fileSize` and re-checked in the service.
- Config: `apps/api/src/config/media.config.ts:55` — `maxBytes: 5 * 1024 * 1024` (a module spec asserts the two stay equal).
- Admin UI: `apps/admin/src/components/products/ProductImageManager.tsx:57` — `MAX_MB = 5`, printed in the drop-zone copy.

The handoff blueprint's suggestion to raise it to 10 MB is a product decision, not a defect: nothing at this HEAD rejects a 2–5 MB product photo. If the owner wants 10 MB, it is a one-constant change in three synced places — but it should not be tracked as a bug.

---

## A05 — Product concurrent-update race

**Classification: CONFIRMED.**

`ProductAdminService.update()` in `apps/api/src/modules/catalog/application/product-admin.service.ts` (lines ~368–501):

- Reads `current` with `findById`, computes the `$set` from it, then writes with `findOneAndUpdate({ _id: id }, { $set: set }, { new: true })`.
- The filter contains **no version predicate** (no `__v`, no `updatedAt`, no status guard beyond a pre-read `deletedAt` check).
- It does **not** run inside `TransactionService.run`.

Two admins editing the same product concurrently both read the same `current`; the second write silently overwrites the first (lost update), including pricing, which is rebuilt as a whole object from the stale read (`nextBase`/`nextSale` derived from `current.pricing`).

Contrast inside the same file: `delete`/`restore` paths *do* run in a transaction and throw `AppException.concurrentModification()` when their guarded update matches nothing. The pattern exists in the codebase; `update()` doesn't use it.

**Business impact:** silent price/content overwrites on a shared catalogue — a financial-integrity issue, not a cosmetic one.
**Recommended fix:** wrap `update()` in `transactions.run`, add a version/`updatedAt` predicate to the update filter, and surface `409 CONCURRENT_MODIFICATION` on a miss (the exception already exists).

---

## A06 — Product update partial-failure behavior

**Classification: CONFIRMED.**

`update()` performs a sequence of independent, non-atomic steps:

1. `audit.recordIntent(...)` — before the write.
2. Product `findOneAndUpdate` — commits immediately (no transaction, see A05).
3. `redirects.record(...)` — if the slug changed.
4. `recount(current, updated)` — category/brand product counts.
5. `audit.recordChange(...)`.

If step 3, 4, or 5 fails, the product change is already durable: the catalogue can end up renamed without its slug redirect (old URL 404s — the exact legacy defect the code comments say this ordering was meant to prevent), with stale category/brand counts, or with a price change missing its audit row. There is no rollback and no compensation.

A second defect in the same method: the write result falls back to the pre-update snapshot — `(await ...findOneAndUpdate(...)) ?? current` — so a write that matched nothing is reported to the caller (and to the recount/audit steps) as if it succeeded with the old values.

**Business impact:** inconsistent catalogue state that no single screen reveals; audit trail gaps on price changes.
**Recommended fix:** same transaction wrap as A05 (product + redirect + recount + audit in one `transactions.run`, session threaded through each write), and remove the `?? current` fallback in favour of an explicit not-found/conflict error.

---

## A07 — Slug availability endpoint

**Classification: CONFIRMED (client side). The API endpoint and the admin Route Handler are, separately, well built.**

- API: `GET /admin/catalog/slug-availability` exists (`admin-catalog.controller.ts:36`, `slug.service.ts`) and is covered by `apps/api/test/catalog/slug.spec.ts`.
- Admin Route Handler: `apps/admin/src/app/api/check-slug/route.ts` is deliberately fail-closed — API failure returns `available: null` with a 502, never a guessed "free".
- The bug is the caller: `apps/admin/src/components/products/ProductForm.tsx:176` fetches the relative URL `` `/api/check-slug?...` `` from the browser. The admin app is mounted with `basePath: '/admin'` (`apps/admin/src/lib/api/renewal.ts:47`, `BASE_PATH = '/admin'`, used by `next.config.ts`). The browser therefore requests `<origin>/api/check-slug`, but the route only exists at `<origin>/admin/api/check-slug` → **404 on every check**.

The failure is silent by construction: the fetch chain calls `response.json()` without checking `response.ok`; a 404 HTML page fails to parse, the `.catch` sets `available: null`, and the form renders "unknown" forever. The operator gets no error and no availability signal — the fail-closed design of the route handler is defeated by a caller that treats a transport 404 the same as an API "unknown".

**Business impact:** slug collisions are only discovered at save time, on the unique index, after the operator has filled the whole form — the exact UX the endpoint exists to prevent.
**Recommended fix:** fetch `${BASE_PATH}/api/check-slug` (import `BASE_PATH` from `@/lib/api/renewal`, as other admin code does), and check `response.ok` before parsing so transport failures are distinguishable.

---

## F16 — Shipping rate management

**Classification: PARTIALLY CONFIRMED. The management capability exists and is well formed; it is (a) broken at runtime by A01 and (b) missing its owner-approved data, not its code.**

What exists at HEAD:

- API: `ShippingRatesAdminService` (`list`, `findByGovernorate`, transactional `updateFee` with role check + audit row, `delete()` that deliberately refuses), `AdminShippingRatesController`, `FulfilmentService.quote()` which raises on a missing governorate row with the message `Run: pnpm --filter api shipping:seed`.
- Seed: `shipping:seed` script exists; the design is 27 governorate rows, no fallback row, fee 0 = free shipping.
- Admin UI: `apps/admin/src/components/settings/ShippingRatesTable.tsx`, `apps/admin/src/actions/shipping-rates.actions.ts`, endpoints in `apps/admin/src/lib/api/endpoints.ts:630+`.

Why it still fails in practice:

1. `ShippingRatesAdminService` injects `TransactionService`, and `FulfilmentModule` does not import `DatabaseModule` (see A01) — the whole API fails to boot, so shipping management is unreachable.
2. Owner decisions D04/D05 (2026-10-07) leave the actual zone/rate table and the free-shipping threshold as **OPEN — OWNER INPUT REQUIRED**. Seed values are development data, not an approved rate table. Checkout for an unseeded governorate raises rather than guessing — correct behaviour, but it means "shipping returns empty/fails" in any environment where the seed was not run.

**Recommended fix:** A01 fix first; then treat the rate table as a configuration/owner-input task, not a code task. Do not invent rates.

---

## F17 — Fake contact form

**Classification: CONFIRMED.**

`apps/storefront/src/app/contact/page.tsx` is a client component whose `handleSubmit` does:

```ts
await new Promise((resolve) => setTimeout(resolve, 1000));
setSubmitting(false);
setSubmitted(true);
```

No API call, no Server Action, no email, no persistence — and then renders "Thank you! Your message has been sent successfully." Every message a customer sends through this form is silently discarded while the UI claims delivery. The page also publishes placeholder contact data (`support@nest-electronics.com`, `+20 100 000 0000`); per owner decision D16 the real support channel is WhatsApp, with the actual number still an open owner input.

**Business impact:** direct customer harm and a truthfulness problem — the worst kind of "small" bug.
**Recommended fix:** either wire it to a real delivery path (email via the existing Notifications provider port, or replace the form with the approved WhatsApp support link once the owner supplies the number) or remove the success claim. Do not leave a simulated submission in production.

---

## F18 — Missing pagination

**Classification: PARTIALLY CONFIRMED. The main listing is fixed; category and brand pages still truncate.**

- **Fixed:** the main product listing (`apps/storefront/src/app/products/(listing)/page.tsx`) paginates properly — server-computed total, `limit: 16`, prev/next and numbered page links. Search (`apps/storefront/src/app/search/page.tsx`) also paginates. The earlier "incorrect limit/skip in aggregation" description does not match the current listing implementation.
- **Still broken:** category and brand pages fetch exactly one page and render no pagination at all:
  - `apps/storefront/src/app/categories/[slug]/page.tsx:93` — `api.listProducts({ category: params.slug, page: 1, limit: 24 })`
  - `apps/storefront/src/app/brands/[slug]/page.tsx:83` — `api.listProducts({ brand: [params.slug], page: 1, limit: 24 })`

  Any product beyond the first 24 in a category or brand is unreachable from that page.
- Blog pagination exists but runs on the legacy Supabase path (`apps/storefront/src/app/blog/page.tsx`, via `getServices()`); blog is deferred per owner decision D11, so this is a residual-surface note, not launch scope.

**Recommended fix:** reuse the listing page's pagination pattern (search-params `page`, server total, page links) on category and brand pages.

---

## F38 — Synthetic / unverified reviews

**Classification: CONFIRMED in presentation. Reviews are deferred (D09/D23), yet the storefront presents rating data as verified fact.**

- The product page renders `"{reviewCount} verified reviews"` (`apps/storefront/src/app/products/[slug]/page.tsx:358`) and emits the same numbers as `aggregateRating` JSON-LD (`apps/storefront/src/lib/json-ld.ts`) — i.e. it also makes this claim to search engines.
- There is no review system behind the claim: reviews are explicitly deferred, there is no provenance model that could make any review "verified", and owner decision D23 prohibits presenting synthetic reviews as real.
- The numbers themselves come from `product.rating` (average/count stored on the product document). In the only dataset that ships with the repo — `apps/api/src/database/seed/catalog.seed-data.ts` — those values are invented per product (e.g. `ratingAverage: 456, ratingCount: 38`), which is legitimate as isolated test/seed data but proves the field has no provenance requirement anywhere in the write path.

The defect is the word "verified" and the JSON-LD claim, not the existence of a rating field. If a real catalogue is loaded with counts that did not come from real, attributable reviews, the storefront will present them as verified — exactly what D23 forbids.

**Recommended fix (safety branch only, per D09/D23 — do not build a review system):** drop "verified" from the copy; suppress `aggregateRating` JSON-LD unless/until a provenance-backed review source exists; decide with the owner whether seed ratings may ever be copied into a production catalogue (D22/D24 say no fabricated content).

---

## Missing Wallet / InstaPay manual verification workflow

**Classification: CONFIRMED — entirely missing. This is the largest functional gap in the project.**

Evidence at HEAD:

- `PaymentMethod` in `apps/api/src/modules/orders/domain/order-status.ts:63` contains exactly one value: `COD = 'COD'`. The order-response DTO states it plainly: "Cash on Delivery is the only method. No payment provider is integrated."
- `CheckoutService.buildOrder` hardcodes `method: PaymentMethod.COD` (`checkout.service.ts:625`).
- `PaymentStatus` is only `PENDING | PAID | REFUNDED`. There is no `PENDING_VERIFICATION` state, no transfer-reference field, no evidence field, and no verification audit action anywhere in `apps/api`, `apps/storefront`, or `apps/admin` (a case-insensitive search for `wallet`, `instapay`, `vodafone`, `PENDING_VERIFICATION`, and `verif*payment` across all three apps returns no implementation — only an Egyptian phone-number DTO comment).
- No WhatsApp handoff: no transfer-instructions screen, no pre-filled WhatsApp link, no admin "confirm payment receipt" action for transfers.
- Admin types mirror the API: `apps/admin/src/lib/api/types.ts:80` — `method: 'COD'`.

The COD half of the approved model is, by contrast, implemented correctly: payment stays `PENDING` at placement, and the DELIVERED transition sets `payment.status = PAID` + `collectedAt` in the same atomic write (`order-lifecycle.service.ts:409–416`), consistent with ADR-ORDER-002.

**Risk analysis for the future implementation** (per the assignment): the design must ensure only an authorized admin transition can set PAID; approval must be idempotent and race-safe (two admins approving concurrently; double-click); amount must be checked against `pricing.grandTotal`; rejection must never mark PAID and must support resubmission (D03); evidence (sender number, screenshot reference, order number) must be retained with an audit row for every verification action; a WhatsApp redirect or a screenshot must never itself change payment state.

**Business impact:** the owner-approved second payment method (D01) simply does not exist — every customer who cannot pay cash on delivery cannot pay.
