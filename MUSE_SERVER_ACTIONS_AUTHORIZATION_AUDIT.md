# Admin Server Actions — Authorization Audit

Date: 2026-11-22 · Branch: `muse/autonomous-engineering` ·
HEAD: `bb217fa54a683eeac318db20b1d3739e59b8356c` (audit performed
against the working tree incl. the uncommitted PAY-3/CSP changes;
no admin code was modified by this audit).

## Why this audit exists

The admin navigation proxy (`apps/admin/src/proxy.ts`)
intentionally passes any request carrying the `next-action`
header straight through — a Server Action POST must never be
answered with a redirect, or the React runtime crashes on an HTML
response. **The proxy is therefore not, and must never be treated
as, the authorization boundary for Server Actions.** This audit
verifies that every admin Server Action enforces authorization
server-side, independently of the proxy.

## The authorization architecture (as found)

Two independent layers, neither trusting the client:

1. **In the admin app (server-side):** every action calls
   `requireAdminActor()` (`apps/admin/src/lib/api/identity.ts`)
   before doing anything. It resolves the caller via
   `readIdentity()`, which asks the API (`GET /auth/me`) with the
   caller's own httpOnly session cookie and checks
   `isStaff(user.role)` against the **API's fresh answer** — never
   a decoded token claim, never a client-supplied value. Outcomes:
   `ok` → proceed; `unavailable` (API unreachable) → **throws**
   ("an action with an unknown actor does nothing at all");
   `expired` → renewal redirect; `rejected`/`unauthenticated` →
   redirect to `/login`. It returns the verified identity, but
   actions do not send any actor id to the API.
2. **In the API (authoritative):** `apiFetch` attaches the access
   token read server-side from the httpOnly cookies, so every
   action's API call carries the operator's own credential, and
   the API's `RolesGuard` independently refuses non-staff tokens
   on every `admin/*` route. A weakness in layer 1 alone cannot
   authorize anything.

No action was found that trusts a client-provided role, user id,
header, or hidden UI control. No action uses a service-role or
otherwise elevated credential.

## Inventory and classification

### `src/actions/admin-order.actions.ts` — PASS (8 actions)

`confirmOrderAction`, `shipOrderAction`, `deliverOrderAction`,
`failDeliveryAction`, `retryShipmentAction`, `returnOrderAction`,
`verifyPaymentAction`, `rejectPaymentAction` — all funnel through
the file-local `run()`, whose first statement is
`await requireAdminActor()`. Input validations in `ship`/`fail`/
`return`/`reject` run before `run()` but perform no writes and
read no protected data. No actor is ever sent to the API (the API
resolves it from the token — F-MED-5 fix, preserved).

### `src/actions/category-brand.actions.ts` — PASS (8 actions)

`createCategoryAction`, `updateCategoryAction`,
`deleteCategoryAction`, `restoreCategoryAction`,
`createBrandAction`, `updateBrandAction`, `deleteBrandAction`,
`restoreBrandAction` — each calls `await requireAdminActor()` as
its first statement.

### `src/actions/product.actions.ts` — PASS (7 actions)

`createProductAction`, `updateProductAction`,
`publishProductAction`, `unpublishProductAction`,
`softDeleteProductAction`, `restoreProductAction`,
`hardDeleteProductAction` — each begins with
`await requireAdminActor()`.

### `src/actions/coupon.actions.ts` — PASS (4 actions)

`createCouponAction`, `updateCouponAction`,
`toggleCouponActiveAction`, `deleteCouponAction` — each begins
with `const admin = await requireAdminActor()`.

### `src/actions/product-image.actions.ts` — PASS (3 actions)

`uploadProductImageAction`, `detachProductImageAction`,
`arrangeProductImagesAction` — each begins with
`await requireAdminActor()`. Uploads go through `apiUpload` with
the caller's own session token.

### `src/actions/inventory.actions.ts` — PASS (2 actions)

`adjustStockAction` (mutation) and `getStockHistoryAction`
(protected read) — both begin with `await requireAdminActor()`.

### `src/actions/review.actions.ts` — PASS (2 actions)

`updateReviewStatusAction`, `deleteReviewAction` — both begin
with `const admin = await requireAdminActor()`.

### `src/actions/shipping-rates.actions.ts` — PASS (1 action)

`updateShippingRateAction` — begins with
`await requireAdminActor()`.

### `src/actions/admin-auth.actions.ts` — PASS (2 actions, by design)

- `loginAction` — public by necessity (it *is* the sign-in). It
  posts the submitted credentials to the API, then checks the
  role **from the API's login response** (`isStaff(user.role)`);
  a non-staff session is revoked server-side (`api.logout`) and
  never written to a cookie. It cannot mint privilege: the API
  issues the tokens and remains the authority on every subsequent
  call.
- `logoutAction` — operates only on the caller's own session:
  reads the caller's own refresh cookie, revokes it at the API,
  clears the cookies. No protected data, no cross-account effect.

### Route handlers (not Server Actions, audited for completeness)

- `src/app/api/check-slug/route.ts` — **PASS.** Calls
  `await requireAdminActor()` before answering, explicitly so the
  route cannot be used as an unauthenticated catalogue
  enumeration probe. (This is also the route the A07 fix in an
  earlier session pointed the product form at.)
- `src/app/session/renew/route.ts` — **PASS.** The console's one
  cookie-writing route. It reads the refresh token **only** from
  the httpOnly session cookie (`readSession()`) — never from the
  query string or a body — and asks the API to rotate it; the API
  validates the token. The `next` parameter is sanitized by
  `safeNextPath` (local paths only; no open redirect).

## Findings

- **Confirmed authorization bypasses: none.**
- **FAIL — fixed: none. FAIL — unresolved: none.
  NOT VERIFIED: none.** Every exported action in
  `apps/admin/src/actions/` (37) and both route handlers were
  read and traced to their API calls.
- No code changes were made for this workstream; there was
  nothing to fix. Regression protection already exists on both
  layers: the API's `test/auth/roles-guard.spec.ts` (in the Jest
  suite, green) and the admin Playwright identity suites.
- Residual note (not a finding): authorization *correctness*
  ultimately rests on the API's `RolesGuard` + `/auth/me`, by
  design. The admin-side `requireAdminActor()` is defence in
  depth and an operator-experience control (fail here with a
  message, not as a bare 401), exactly as its own documentation
  states.
