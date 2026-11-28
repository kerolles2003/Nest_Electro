# Decisions — Nest Electro Flutter app

Every ambiguous decision taken autonomously during the mission, with its reasoning.
The owner reviews these with the final PR; nothing here changes the backend.

## D-01 — Base branch: cut from origin/phase-1-2-overnight at 5a1fd5c

`git fetch origin` worked in the sandbox (contrary to the mission brief's expectation
that fetch would fail), so `flutter-app` was cut from the real
`origin/phase-1-2-overnight` tip `5a1fd5c` (both PRs merged). No fallback to the local
`ae0e27f` tree was needed.

## D-02 — Image URLs: derive from the API base URL (local-provider shape)

The API stores no image URLs; the storefront derives them (`lib/images.ts`).
The app does the same: `{API_BASE_URL}/media-delivery/v{version}/{publicId}`
(version-less for cart lines). An optional `--dart-define=CLOUDINARY_CLOUD_NAME`
switches to the Cloudinary shape when the owner delivers the account. Until then
the local shape is the default. Missing images render a placeholder, never a crash.

## D-03 — Fonts: google_fonts (Albert Sans body, Urbanist headings)

The storefront uses Albert Sans (body) + Urbanist (headings) via `next/font/google`.
The app uses the `google_fonts` package for the same families, with a system-font
fallback if the fonts cannot be downloaded (offline first run).

## D-04 — Blog + wishlist: clearly marked mock repositories

Neither has an API endpoint (Supabase on the web side). The screens exist against
`MockBlogRepository` / `MockWishlistRepository` (local-only data, `// MOCK:` header),
recorded in `API_GAPS.md` (G1, G2). Reviews/coupons are Phase 8 — rating display
only, no submission UI, no coupon input.

## D-05 — Stack: Riverpod + go_router + dio + freezed/json_serializable

Per the mission brief. Dio client with base URL from `--dart-define=API_BASE_URL`,
error mapping to the API's `{ error: { code, message, details } }` envelope,
tokens in `flutter_secure_storage`, silent refresh on 401 (tokens rotate).

## D-06 — i18n: Arabic default, English secondary (gen_l10n)

Arabic (RTL) is the default locale, English is the second locale. All user-facing
strings go through `gen_l10n` (`AppLocalizations`).

## D-07 — iOS folder included, but iOS cannot be built on Linux

`flutter create` includes iOS. Builds/verification on this machine cover Android
(emulator `10.0.2.2`) and the shared Dart code; iOS builds need a Mac — recorded
in `REPORT.md`.

## D-08 — Plan change (owner decision, 2026-11-27 evening): per-phase GitHub sync OFF; local merges + one final sync

The owner is going to sleep and cannot press Allow on approval cards overnight.
Per-phase GitHub PRs/merges are OFF. Each phase keeps its own local branch
(`flutter/phase-N-<name>` cut from `flutter-app`), passes the same gate
(`flutter analyze` clean, `flutter test` green), then merges LOCALLY into
`flutter-app` with a real merge commit — full history preserved, same as a PR
merge minus GitHub. No GitHub write calls (`create_branch`, `push_files`,
`create_pull_request`, `merge_pull_request`) until the final sync after Phase 9
(`REPORT.md` done): ONE sync — create `flutter-app` on GitHub if missing, upload
all files, open the final PR `flutter-app` → `phase-1-2-overnight`, DO NOT merge.
If GitHub sync ultimately cannot complete, a git bundle of `flutter-app` + the
phase branches is the transfer vehicle (path recorded in `REPORT.md`).
This change arrived minutes AFTER a "hold lifted" instruction, under which PR #3
(phase 0) had already been merged on GitHub (merge commit `81d1037`). That merge
stands and is consistent with the new plan — `flutter-app` already exists on
GitHub with phase 0 in it; the final sync reuses it rather than re-creating it.
No approval cards are pending as of this change.

## D-09 — Remote vs local `flutter-app` SHAs differ (same phase-0 content)

- Remote: `flutter-app` @ `81d1037` (merge of PR #3; phase-0 snapshot commit
  `a996535` on `flutter/phase-0-recon`).
- Local: `flutter-app` @ `f91cade` (fast-forward merge of local phase-0 commit
  `f91cade`).
Same file content, different commit SHAs (snapshot push vs local git). Expected
under the snapshot-sync model. The final sync snapshot-pushes the finished
`flutter-app` content onto the existing remote `flutter-app` branch — it must
NOT re-create the branch or re-push phase 0 separately. Reconciliation used only
the merge call's own response (`merged: true`, sha `81d1037`); no further
`list_branches` call was made because that tool is write-classified and would
have raised a new approval card overnight.

## D-10 — No Android SDK in the sandbox (`flutter doctor`, 2026-11-27)

Flutter 3.35.7 ✓, network ✓. Android toolchain ✗ (no Android SDK), Chrome ✗,
Linux toolchain ✗. The gates (`flutter analyze`, `flutter test`) need none of
these — `flutter test` runs on the Dart VM. APK builds are NOT verified in this
sandbox; `flutter build web` may be used as an extra compile check where useful.

## D-11 — Generated l10n output is committed

`gen_l10n` runs with `synthetic-package: false` into `lib/src/core/l10n/gen/`.
The generated Dart files are committed (small, text, regenerable) so the tree
analyzes without a prior `flutter pub get`.

## D-12 — Content localization is header-driven (verified live, 2026-11-27)

The API localizes product/category names and descriptions from the
`Accept-Language` request header — the same product returns Arabic with
`ar` and English with `en`; DTOs carry plain strings, never both languages.
The dio client therefore sends `Accept-Language` matching the app locale
(Arabic by default, English when the user switches). No per-field bilingual
model is needed.

## D-13 — Model nullability follows live data, not just the OpenAPI

The OpenAPI marks several fields required that the live API returns as
`null` (verified: `CategoryDto.parentId` is `null` for root categories,
`brand`/`salePrice`/`logo` are `null` on real records, `ProductSpecDto.unit`
is `null`). Freezed models therefore make those fields nullable even where
the spec says required, and every "event happened at" timestamp
(`collectedAt`, `decidedAt`, `deliveredAt`, `lastLoginAt`, …) is nullable.
Money `amount` is `int` (integer piastres per the API contract, verified
live: `38000`); `average`/`weight` are `double` (json_serializable coerces
`num` → `double`).

## D-14 — Category/hero artwork copied from the storefront (2026-11-27)

The live API returns `image: null` for every category, so the category
tiles and hero have no server artwork. The storefront's local files are
the only artwork: 3 hero webps + the 8 root-category PNGs were copied
from `apps/storefront/public/images/` into `apps/mobile/assets/images/`
(6.5 MB total, same repo, same project). Brand logos are different —
`BrandDto.logo` is a real `ProductImageDto` (null on live records), so
brand tiles fetch the logo via `ApiConfig.imageUrl` and fall back to the
brand's initial letter.

## D-15 — Featured is a filter, not a sort (2026-11-27)

The API has no `featured` sort value (its sort enum is frozen:
relevance/newest/price_asc/price_desc/rating/name_asc). The featured rail
is `GET /products?featured=true&sort=newest` — the same mapping the
storefront's listing page uses for its legacy "Featured" sort.

## D-16 — Category tree built client-side from the flat list (2026-11-27)

`GET /categories/tree` returns nested `children`, but our `CategoryDto`
does not model them (json_serializable drops unknown fields). The flat
`GET /categories` (15 items) carries `parentId`/`depth`, so roots and
children are grouped client-side instead.

## D-17 — Product list: immutable query, navigation as the filter action (2026-11-27)

`ProductQuery` (freezed) is the single source of truth for a listing.
The `ProductListController` is a `FamilyNotifier` keyed by that query:
first page loads on build (microtask), `loadMore()` appends, `refresh()`
re-fetches page 1. Changing a filter or sort navigates to a new
`/products?...` URL (prices in EGP in the URL, ×100 to piastres at the
router — mirroring the web listing), which rebuilds the screen with a new
query and a fresh provider instance.

## D-18 — Demo died in a sandbox service restart; restarted, not rebuilt (2026-11-27)

Mongod + API + storefront + admin were all down after the restart that
also interrupted a `build_runner` run. The Mongo data dir was intact, so
the demo was restarted from it (mongod `--fork`, API `node dist/main.js`
with `browser-check/env.sh` + local-media vars, frontends `pnpm start`
with explicit ports) — no re-seed, catalogue still 60 products, live
login probe 401 `INVALID_CREDENTIALS` as expected.

## D-19 — Smoke test uses manual pumps, not pumpAndSettle (2026-11-27)

The hero carousel's 8-second `Timer.periodic` auto-advance never
settles, so `pumpAndSettle` times out once the home screen is real.
`test/widget_test.dart` now pumps two 1-second frames instead. The timer
itself is correct app behaviour (the web hero auto-advances too).

## D-20 — Guest basket moves into the account only on an explicit tap (2026-11-27)

The API has no cart-merge endpoint, so the guest basket is NOT moved
automatically on login: silent mutation of the server cart would
surprise the user (and could silently overwrite quantities). The cart
screen shows a banner ("You have items in your guest cart") with a
"Move to my account" button when signed in with guest lines; the tap
adds each line sequentially via `POST /cart/items` and clears the local
lines only after all adds succeed. Live-verified: `POST /cart/preview`
prices a guest basket (2 × 380.00 EGP = 760.00 EGP, status `OK`).

## D-21 — `/cart` is guest-accessible; `/checkout` stays auth-only (2026-11-27)

The API was designed for guests to price a basket via
`POST /cart/preview`, so `/cart` was removed from the router's
auth-only paths and renders the local basket (SharedPreferences,
`nest_guest_cart_v1`) with the preview's priced `CartDto`. `/checkout`
stays auth-only because `POST /orders` requires a session; guests
tapping checkout are sent to `/login?redirect=/checkout`. The router's
auth-only matcher now also covers the `/checkout/` prefix so
`/checkout/confirmation` is guarded too.

## D-22 — Address list/create are duplicated between checkout and account (2026-11-27)

`AccountRepository` owns the full address set (list/create/update/
delete/set-default) while `CheckoutRepository` keeps its own
list/create from phase 5. The duplication (~15 lines) is deliberate:
checkout must not depend on the account feature, and refactoring the
tested phase-5 checkout controller to share the repository was not
worth the churn. If a third caller appears, extract a shared
address repository then.

## D-23 — Wishlist is local-only and guest-accessible (2026-11-27)

The API has no wishlist endpoint (G1) and the storefront keeps its
wishlist in Supabase, so the app's wishlist is a SharedPreferences
mock (`nest_wishlist_v1`) holding an id/slug/name/image/price snapshot
per item, with a banner on the screen saying it is device-only. `/wishlist`
is NOT auth-guarded (guests can save items like they can keep a guest
basket); tapping an item opens the live product detail. The heart toggle
lives in the product detail AppBar.

## D-24 — Order status filter is an array param; wire values are explicit (2026-11-27)

`GET /orders?status=` takes an ARRAY (`?status=PLACED&status=…`), and
`deliveryFailed.name.toUpperCase()` would give `DELIVERYFAILED` while
the API expects `DELIVERY_FAILED`, so the repository maps each
`OrderStatus` to its wire value explicitly. Cancel is offered for
PLACED/CONFIRMED only and resubmit only for `VERIFICATION_REJECTED`
payments (both mirror the storefront; the API is the final judge, 409
when the status moved on).

## D-25 — Demo observation: documented sandbox login fails; test accounts created (2026-11-27)

The documented sandbox customer (`sandbox@nest-electronics.test` /
`SandboxPass123`, from `sandbox.seed-data.ts`) returns
`INVALID_CREDENTIALS` against the current demo DB — the sandbox seed
was apparently not run against this data dir (or its password differs).
Not an app defect: phase 6 was live-verified with two fresh customer
accounts registered through the API (`phase6-test@` /
`phase6-test2@nest-electronics.test`, verified via the dev-mailer link
in `api.log`): `GET /auth/me`, `GET /orders` (empty `{data, meta}`
envelope), `GET /users/me/addresses` (empty `{data: []}`) and
`PATCH /users/me` (name updated) all match the app's models. Cancel /
resubmit were verified against the OpenAPI spec + repo tests only —
the test accounts have no orders.

## D-26 — Dark theme `onError` is near-black, not white (2026-11-27)

The WCAG contrast test written in phase 7 caught a real defect: white
text on the dark error red (#EF4444, the storefront's dark danger token)
is only 3.76:1 — below WCAG AA 4.5:1. The error token itself is
unchanged (it is also used as foreground text on the dark surface, where
#EF4444 on #0C1322 is 4.84:1 and passes; darkening the token would break
that use). Instead the dark scheme's `onError` is the dark background
#0C1322, which on #EF4444 is 4.97:1. Light `onError` stays white on
#DC2626 (4.84:1).

## D-27 — `onSurfaceVariant` is the Material default, not the storefront muted token (2026-11-27)

The theme does not wire `AppColors.lightMutedForeground` (#5F6873) /
`darkMutedForeground` (#64748B) into the scheme; screens that read
`colorScheme.onSurfaceVariant` get the Material 3 defaults. The phase 7
contrast test pins the actual scheme values and they pass AA in both
themes, so this is recorded as a known deviation, not fixed: wiring the
storefront tokens would need a re-check of every secondary-text surface.
If the owner wants exact token fidelity, set `onSurfaceVariant` in
`AppTheme` and re-run the contrast test.

## D-28 — App icon is a placeholder; icon PNGs are binary (2026-11-27)

The app icon is a generated placeholder: navy #1a1a2e background with a
crimson #cf3549 rounded square and a white "N" (`assets/icon/icon.png`,
drawn with PIL from the storefront palette), applied to Android, iOS and
web with `flutter_launcher_icons` (devDependency). The owner should
replace `assets/icon/icon.png` with the real brand mark and re-run
`dart run flutter_launcher_icons`. The generated icon PNGs are binary
files committed in git; they MUST be excluded from any connector
`push_files` manifest at the final sync (snapshot push is text-only) —
the final bundle will carry them.

## D-29 — `AppTheme` cannot be constructed in widget tests (2026-11-27)

`AppTheme` is built with `google_fonts`, which schedules a runtime font
fetch on construction; in the test zone that fetch fails (and with
`allowRuntimeFetching = false` it still throws because the fonts are not
bundled). So the phase 7 contrast test builds the light/dark
`ColorScheme`s from the same `AppColors` tokens instead of reading
`AppTheme.light/dark.colorScheme`, and the RTL widget tests pump screens
with the default Material theme. If `AppTheme`'s scheme arguments ever
change, the test file's copies must be updated too (noted in the test).
Bundling the fonts (Albert Sans + Urbanist TTFs in `assets/fonts`) would
remove this limitation and let the app work fully offline — left for the
owner to decide; see REPORT.md in phase 9.

## D-30 — CartController: never read providers inside the microtasked load (2026-11-27)

`CartController.build()` watches the auth state, so it rebuilds on
login/logout. Its `_load` ran in a microtask and read the watched auth
provider (then `_repo`/`_storage`) via `ref.read` — Riverpod throws
"Cannot use ref functions after the dependency of a provider changed but
before the provider rebuilt" when the dependency changed between the
microtask being scheduled and running (caught by the phase 8 integration
test, which restores a session during the first pumps). Fix: `build()`
captures the watched value, the repository and the storage and passes
them as arguments to `_load({authed, repo, storage})`; `_load` falls back
to the `ref.read` getters only when called from UI event handlers
(`refresh()`), where the provider is fresh. Only `CartController` had
this pattern — other controllers' microtasked loads read stable
repository providers.

## D-31 — D-29 refined: `AppTheme` CAN be constructed in widget tests (2026-11-27)

The phase 7 failure was timing, not a hard limitation: `AppTheme.light`
was evaluated at `main()` time, before `setUpAll` ran. If a test file
sets `GoogleFonts.config.allowRuntimeFetching = false` in `setUpAll`
BEFORE anything constructs the theme, the full app (with `AppTheme`)
boots in tests — the smoke test and the phase 8 integration test both do
this. The phase 7 contrast test's token-pinned copies remain valid (they
pin the wiring, not the construction), but future tests need not avoid
`AppTheme`. Bundling the fonts (assets/fonts) would remove the
`setUpAll` ordering requirement entirely — still the owner's call; see
REPORT.md in phase 9.

## D-32 — Integration-test lessons + a real cart robustness fix (2026-11-27)

The happy-path integration test (browse → cart → checkout →
confirmation, mocked repos, Arabic locale) caught four things:

1. `FilledButton.icon`'s runtime type is the private
   `_FilledButtonWithIcon`, so `find.widgetWithText(FilledButton, …)`
   never matches it — tap the label text instead. (Plain-constructor
   `FilledButton`/`ElevatedButton` match normally.)
2. Cart mocks must be stateful: `getCart()` returning an empty cart
   forever lets a controller rebuild (auth change) overwrite an added
   line with the empty cart. The mock now keeps a `lineAdded` flag; the
   real server behaves the same way.
3. Any test that touches guest storage must call
   `SharedPreferences.setMockInitialValues({})` in `setUpAll` — without
   it `store.load()` throws a platform error.
4. Real app bug, fixed: `CartController._load` caught only
   `ApiException`, so a non-API failure (e.g. the unmocked
   SharedPreferences above) left `isLoading: true` forever and the cart
   screen spun indefinitely with the line already in state. `_load`
   now has a generic `catch` that surfaces `ApiException(code:
   'LOAD_FAILED', …)` — the screen shows its error state with retry.
   Other controllers still catch only `ApiException` in their loads
   (same hang class) — follow-up, not fixed in phase 8; recorded for
   REPORT.md.

## D-33 — GitHub Actions workflow for apps/mobile only (2026-11-27)

`.github/workflows/mobile.yml` runs `flutter analyze` + `flutter test`
on pushes/PRs touching `apps/mobile/**` (or the workflow itself),
Flutter pinned to 3.35.7 via `subosito/flutter-action` (same pin as the
sandbox; bump deliberately). Conventions follow the repo's `ci.yml`:
`permissions: contents: read`, a `concurrency` group, no secrets, no
deploy. It has NOT run in CI yet — no GitHub sync happens until the
final sync after phase 9 (D-08); the first run will be on the final PR.

## D-34 — Stuck-spinner fix extended to account/orders/addresses/checkout (2026-11-27)

Phase 8 (D-32) fixed the hang class in `CartController._load` only. Phase 10
applies the same generic `catch` to the seven remaining load paths
(`AccountController._load`, `OrdersController._loadFirstPage` + `loadMore`,
`OrderDetailController._load`, `AddressesController._load`,
`CheckoutController._load` + `_fetchQuote`): a non-`ApiException` failure now
surfaces `ApiException(code: 'LOAD_FAILED', …)` with a per-controller message
and clears the loading flag, so the screen shows its error state with retry
instead of spinning forever. Six regression tests (one per controller, three
for orders) prove it. Deliberately NOT fixed: `ProductListController`
(`catalogue_providers.dart`) has the same `ApiException`-only catch — it was
outside the phase-10 task's explicit controller list, so it stays as the one
remaining follow-up (see REPORT.md).

## D-35 — Fonts bundled as static TTFs; google_fonts removed (2026-11-27)

Albert Sans + Urbanist (400/500/600/700, 8 files, ~352 KB) are now in
`assets/fonts/` and declared in `pubspec.yaml`; `AppTheme` uses
`fontFamily: 'AlbertSans'` / Urbanist directly. The `google_fonts`
dependency is gone, so the app renders its real typography fully offline
and the `allowRuntimeFetching = false` test workaround (D-29/D-31) is
deleted from the widget/integration tests. Files were fetched from
fonts.gstatic.com via the css2 API (Mozilla/4.0 UA returns TTF) and verified
as TrueType data before committing. This closes known issue #5.

## D-36 — Dark muted foreground #64748B → #94A3B8 (2026-11-27)

Measured, not guessed: the old dark muted token #64748B scored **3.90:1**
on the dark surface #0C1322 (3.45:1 on darkSecondary, 3.18:1 on darkMuted) —
all below WCAG AA 4.5:1; the light token #5F6873 passes (5.65/5.32:1).
Changed to **#94A3B8** (slate-400): 7.24 / 6.41 / 5.89:1 on the three dark
surfaces. Deliberate deviation from the storefront token, like D-26/D-27.
The muted tokens are defined but no screen uses them yet — screens use
`colorScheme.onSurfaceVariant` (Material default, D-27), which the existing
contrast test already pins as passing in both themes — so the token was
fixed for correctness and pinned by test, and `onSurfaceVariant` was NOT
rewired (out of scope per D-27). The contrast test now uses the real
`AppTheme.light/dark.colorScheme` (possible now fonts are bundled), removing
a drift risk. This closes known issue #2.

## D-37 — Load test: what was measured and what it does NOT prove (2026-11-27)

Load was driven against the live local demo API (Mongo rs0 + API on this
1.5-CPU sandbox cell) with a dependency-free Dart driver
(`~/workspace/loadtest-p10/load_test.dart`, results in `results.json` next
to it — kept outside the repo, not committed). Steps 20 → 50 → 100
concurrent users, each doing home list + categories + search + product
detail + cart preview; plus 3 full checkouts with fresh accounts (register
is throttled 3/hour per IP, so 3 is the ceiling) and a parallel
idempotency double-send. Results: 0 5xx, 0 transport errors across ~3,400
requests; p95 at 100 users 1,393 ms on the products list, 120–273 ms
elsewhere. This proves the API + app flow hold up under 100 concurrent
users **on sandbox hardware** — it is NOT production-scale proof: the
driver, API, and Mongo share one 1.5-CPU cell, so latency is dominated by
the cell, not the code. What must be re-checked on real hosting: the same
steps against the production-shaped deployment (separate DB/API hosts,
real network), plus sustained (not burst) load and a real-device checkout.
The one endpoint to watch is `GET /products` (list) — its p95 degrades
fastest with concurrency (295 → 658 → 1,393 ms), likely the
aggregation/sort; a candidate for server-side caching or an index review
on real hosting.

## D-38 — Search query param is `q`, not `search` (2026-11-27)

The first load-test run sent `/products?search=esp32` and got 400 on every
search call. That is the API's strict unknown-field validation, not an API
bug: the app's `ProductQuery.toQueryParameters()` sends `q`. The driver was
fixed and re-run clean (100% 2xx). Lesson recorded, not a product change.

## D-39 — Parallel idempotency test needed a second script (2026-11-27)

The first run's parallel double-send "failed" only because the first order
had already consumed the cart — the second attempt placed an order from an
empty cart, which is a test-setup error, not an idempotency failure.
Re-testing needed a fresh cart on an existing account: the register limit
(3/hour/IP) was exhausted, so a separate driver
(`~/workspace/loadtest-p10/parallel_idempotency.dart`) re-logged-in as the
first run's account, refilled the cart, and fired two concurrent
`POST /orders` with one fresh key: statuses `[201, 200]`, one order
(`NE-20261127-0004`), order count delta exactly +1. The API's idempotency
handling is correct under a concurrent race.

## D-40 — `flutter build web` CupertinoIcons font warning is benign (2026-11-27)

The build prints "Expected to find fonts for (MaterialIcons,
packages/cupertino_icons/CupertinoIcons), but found (MaterialIcons)". No
code in `lib/` references `CupertinoIcons` — it is a transitive
dependency's font the tool looks for. Nothing renders from it; no action
taken.

## D-41 — Load-test accounts and orders live in the demo DB only (2026-11-27)

The load test created 3 throwaway accounts
(`loadtest-p10-<n>-<ts>@example.test`) and 4 COD orders
(`NE-20261127-0001`…`0004`) in the demo database. They are demo data, not
committed anywhere, and the demo DB is rebuilt from seed on the next demo
rebuild. No cleanup was performed (the demo DB is scratch by design).
