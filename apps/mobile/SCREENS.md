# Nest Electro — Storefront → Flutter screen map

Recon date: 2026-11-27. Source: `apps/storefront/src/app` (Next.js, 20 routes) and the
live OpenAPI spec `GET /api/v1/docs-json` (74 paths, OpenAPI 3.0.0, "Nest Electronics API" v1).
The Flutter app talks ONLY to `apps/api`. Base URL comes from
`--dart-define=API_BASE_URL` (default `http://10.0.2.2:3002/api/v1`).

## Cross-cutting API facts

- **Envelope:** every response is `{ "data": ... }`; errors are
  `{ "error": { "code", "message", "details"?, "requestId", "timestamp" } }`.
  Field errors are `details` entries of `{ field, message, code }`.
- **Auth:** Bearer JWT (`Authorization: Bearer <accessToken>`). Access tokens live
  **15 minutes**; `POST /auth/refresh` with `{ refreshToken }` returns a new pair and
  **rotates** the refresh token (old one is burned).
- **Money:** integer minor units (piastres, EGP). `MoneyDto` carries
  `{ amount, currency, formatted }` — display `formatted` when present.
- **Pagination:** `page` (1-based) + `limit` (1–100); list responses carry
  `meta: { page, limit, total, totalPages, hasNext, hasPrev }`.
- **Product list sorting:** `relevance | newest | price_asc | price_desc | rating | name_asc`
  (default `relevance` with `q`, else `newest`; anything else → 400 `UNSUPPORTED_SORT`).
- **Images:** the API stores no URLs. The client derives them (mirrors
  `apps/storefront/src/lib/images.ts`):
  local provider → `{API_BASE_URL}/media-delivery/v{version}/{publicId}`
  (cart lines are version-less: `{API_BASE_URL}/media-delivery/{publicId}`);
  Cloudinary (if a cloud name is ever configured) →
  `https://res.cloudinary.com/{cloud}/image/upload/{preset}/v{version}/{publicId}`.
  No image → render the placeholder; never crash.
- **Order placement:** `POST /orders` requires an `Idempotency-Key: <uuid>` header.
- **Guest vs auth:** catalogue, search, brands, categories and `POST /cart/preview`
  are public. Cart, checkout, orders and profile all require Bearer auth, so a guest
  must register/login before placing an order.

## Screen map

| # | Storefront route | Flutter screen | API endpoints | Notes |
|---|---|---|---|---|
| 1 | `/` (home) | Home | `GET /products?featured=true&sort=newest&limit=10`, `GET /categories/tree`, `GET /brands` | Hero banner, category grid, featured products, brand strip. Trust badges are static copy. |
| 2 | `/products` (listing) | Product list | `GET /products` (`page, limit, q, category, brand[], minPrice, maxPrice, inStock, featured, spec[], sort`); response `data + meta + facets` | Facets (categories/brands/priceRange/specs) drive the filter UI. Infinite scroll / pagination via `meta.hasNext`. |
| 3 | `/products/[slug]` | Product detail | `GET /products/{slug}`, `GET /products/{slug}/related` | Image gallery (versioned URLs), specs, stock availability (`IN_STOCK / LOW_STOCK / OUT_OF_STOCK`), rating average/count. Reviews tab is Phase 8 — display only, no submission (see API_GAPS.md). |
| 4 | `/categories` | Categories | `GET /categories/tree` | Tree with children; tap a node → category products. |
| 5 | `/categories/[slug]` | Category products | `GET /categories/{slug}`, `GET /products?category={slug}` | `category` matches the entire subtree. |
| 6 | `/brands/[slug]` | Brand products | `GET /brands/{slug}`, `GET /products?brand={slug}` | |
| 7 | `/search` | Search | `GET /products?q=…`, `GET /products/suggest?q=…` (prefix match on name/SKU) | Debounced suggestions + full results. |
| 8 | `/cart` | Cart | `GET /cart`, `POST /cart/items`, `PATCH /cart/items/{productId}`, `DELETE /cart/items/{productId}`, `DELETE /cart`, `POST /cart/preview` (guest pricing) | Line statuses: `OK, PRICE_CHANGED, REDUCED_STOCK, OUT_OF_STOCK, UNAVAILABLE` — surface them, do not silently drop lines. |
| 9 | `/checkout` | Checkout | `GET /users/me/addresses`, `POST /checkout/quote {addressId}`, `GET /checkout/payment-methods`, `POST /orders` (+ `Idempotency-Key`) | Flow: pick address → quote is per-address (shipping fee varies by governorate) → pick payment method → place order. Methods: `COD, WALLET, INSTAPAY`. Wallet/InstaPay orders stay `PENDING_VERIFICATION` until an admin verifies; COD may ship before cash collection. |
| 10 | `/login` | Login | `POST /auth/login {email, password}` → `{ accessToken, refreshToken, user }` | 401 = wrong credentials, 403 = e.g. unverified/disabled, 429 = rate limited. |
| 11 | `/register` | Register | `POST /auth/register {email, password, fullName, phone?}` → 201 `{ message, emailVerificationRequired }` | **Rate limit 3/hour** → 429 must be handled gracefully (explain + cooldown, do not retry in a loop). 409 = email already registered. |
| 12 | `/forgot-password` | Forgot password | `POST /auth/forgot-password {email}` | Always show the generic "check your inbox" state. |
| 13 | `/forgot-password/reset` | Reset password | `POST /auth/reset-password {token, newPassword}` | Token arrives by email link. |
| 14 | `/verify-email` | Verify email | `POST /auth/verify-email {token}`, `POST /auth/resend-verification {email}` | Deep link is `verify-email?token=…`. |
| 15 | `/account` | Account home | `GET /auth/me`, `GET /users/me` | |
| 16 | `/account/profile` | Profile | `PATCH /users/me {fullName, phone}` | |
| 17 | `/account/orders` | Order history | `GET /orders` (`page, limit, status[]`) | Statuses: `PLACED, CONFIRMED, SHIPPED, DELIVERED, DELIVERY_FAILED, CANCELLED, RETURNED`. |
| 18 | `/account/orders/[id]` | Order detail | `GET /orders/{id}`; `POST /orders/{id}/cancel {reason}`; `POST /orders/{id}/payment/resubmit {transferSender}` | Payment statuses: `PENDING, PENDING_VERIFICATION, VERIFICATION_REJECTED, PAID, REFUNDED`. Resubmit is for rejected wallet/InstaPay verification. |
| 19 | `/account/addresses` | Addresses | `GET/POST /users/me/addresses`, `GET/PATCH/DELETE /users/me/addresses/{id}`, `POST /users/me/addresses/{id}/default` | Address: `{ label, fullName, phone, street, city, governorate, postalCode, isDefault }`. Limit errors exist (`ADDRESS_LIMIT_REACHED`). |
| 20 | `/wishlist` | Wishlist | **No API endpoint** — storefront uses Supabase server actions | Mock repository, clearly marked (see API_GAPS.md). |
| 21 | `/blog`, `/blog/[slug]` | Blog | **No API endpoint** — storefront uses Supabase | Mock repository, clearly marked (see API_GAPS.md). |
| 22 | `/contact` | Contact | **No API endpoint** — static content | Static screen (address/phone from app config, no backend call). |

## Screens the Flutter app adds (no storefront equivalent)

- **Splash / auth gate**: decides initial route from stored tokens (`GET /auth/me` to validate).
- **Onboarding**: none in the storefront; keep first-run simple (home directly).
