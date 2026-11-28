# API gaps — screens that cannot be backed by `apps/api` today

Recon date: 2026-11-27. Rule: the Flutter app talks ONLY to `apps/api` and the
backend is NOT changed by this mission. Where the API has no endpoint, the screen
is built against a **clearly marked mock repository** (in `lib/features/<name>/data/mock_*_repository.dart`,
with a `// MOCK:` header comment) and the gap is recorded here. When the API gains
the endpoint, the mock is swapped for the real repository — the UI and state layers
do not change.

## G1 — Wishlist (no endpoint)

- Storefront: `/wishlist`, backed by Supabase server actions
  (`apps/storefront/src/actions/wishlist.actions.ts`).
- API: no `/wishlist` route in the OpenAPI spec.
- Flutter: `MockWishlistRepository` — wishlist persisted locally on-device only
  (product ids), with add/remove/toggle. Clearly marked mock. Needs a future
  `GET/POST/DELETE /users/me/wishlist` API to sync.

## G2 — Blog (no endpoint)

- Storefront: `/blog`, `/blog/[slug]`, backed by Supabase (`lib/services.ts`).
  Note: the blog was removed from the storefront in an earlier phase and is a
  Phase 8 rebuild item on the web side too.
- API: no blog route in the OpenAPI spec.
- Flutter: `MockBlogRepository` — a small static list of placeholder posts bundled
  in the app, clearly marked mock. Needs a future `GET /blog` + `GET /blog/{slug}` API.

## G3 — Product reviews (Phase 8, no endpoint)

- Storefront: product detail has a Reviews tab, but reviews are explicitly a
  Phase 8 domain; the tab shows no live data.
- API: no reviews route in the OpenAPI spec. `ProductDetailDto` exposes only
  `rating: { average, count }`.
- Flutter: show the rating average/count on the product detail screen. No review
  list, no review submission UI. Needs a future reviews API.

## G4 — Coupons (Phase 8, no endpoint)

- API: no coupons route; `PlaceOrderDto` has no coupon field; the checkout quote
  has no discount input beyond `discountTotal` (server-computed).
- Flutter: no coupon input in checkout. If the API later supports coupons, add the
  field to the place-order request and the quote display.

## G5 — Contact page (static, no endpoint)

- Storefront: `/contact` is static content.
- Flutter: static Contact screen (store address/phone from app config). Not a gap
  in the API — recorded here so it is not mistaken for one.

## G6 — Payments: no gateway SDK, manual methods only

- API: `GET /checkout/payment-methods` returns manual instructions
  (`{ availableMethods, walletNumber, instapayAddress, whatsappNumber }`).
  Methods are `COD`, `WALLET`, `INSTAPAY`. There is no online payment gateway
  and no gateway SDK is integrated (per mission rules).
- Flutter: checkout shows the manual instructions returned by the API for the
  chosen method (wallet number / InstaPay address / WhatsApp number) and collects
  `transferSender` for wallet/InstaPay orders. Wallet/InstaPay orders remain
  `PENDING_VERIFICATION` until an admin verifies them; the order detail screen
  offers payment resubmission (`POST /orders/{id}/payment/resubmit`) when
  verification was rejected. No payment credentials are ever stored in the app.

## G7 — Image CDN not configured (owner deliverable)

- Cloudinary is the confirmed production media provider, but the account has not
  arrived (owner decision D-01 in the API repo). The demo/local API serves images
  from its local provider at `{API_BASE_URL}/media-delivery`.
- Flutter: image URLs are derived as `{API_BASE_URL}/media-delivery/v{version}/{publicId}`
  (version-less for cart lines), mirroring the storefront's `lib/images.ts`.
  If a Cloudinary cloud name is later supplied via
  `--dart-define=CLOUDINARY_CLOUD_NAME`, URLs switch to the Cloudinary shape;
  until then the local shape is the default. Missing images render a placeholder.

## G8 — Push notifications (no endpoint, not in storefront either)

- No push/notification endpoint exists in the API and the storefront has none.
- Flutter: no push integration. Order status changes are visible by re-opening
  order history (pull-to-refresh).

## G9 — Guest checkout is not possible

- `POST /cart/preview` prices an anonymous basket, but `POST /orders` requires
  Bearer auth. A guest must register or log in before placing an order.
- Flutter: the cart works for guests (local cart + preview); checkout prompts
  login/register. This matches the storefront.
