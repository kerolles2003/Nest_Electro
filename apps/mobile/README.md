# Nest Electro — Flutter customer storefront app

The Nest Electro customer storefront as a Flutter app (Android, iOS, web).
It talks **only** to `apps/api` (NestJS + MongoDB) — no Supabase, no other
backend. The web storefront in `apps/storefront` is the UX reference; the
screen map lives in [SCREENS.md](SCREENS.md) and the API gaps in
[API_GAPS.md](API_GAPS.md). Decisions taken during the build are in
[DECISIONS.md](DECISIONS.md); the mission report is [REPORT.md](REPORT.md).

## Prerequisites

- Flutter **3.35.7** (Dart 3.9.2) — the version the app was built and
  verified against; CI pins the same version (`.github/workflows/mobile.yml`).
- The API running locally (see the repo root README / `docker compose` dev
  setup), seeded with the catalogue. The app needs nothing else: no
  Android SDK is required to run `flutter analyze` or `flutter test`
  (they run on the Dart VM), but an Android SDK is required to build/run
  an APK or an emulator, and a Mac with Xcode is required to build iOS.

## Run

```bash
cd apps/mobile
flutter pub get
```

### Against the local API

| Target | Command |
|---|---|
| Android emulator | `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3002/api/v1` |
| iOS simulator / web / desktop | `flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3002/api/v1` |
| Web (Chrome) | `flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:3002/api/v1` |

Without `--dart-define=API_BASE_URL` the app uses the Android-emulator
default `http://10.0.2.2:3002/api/v1`. There are no `.env` files and no
secrets in the app — the base URL is a build-time define only.

### Dart-defines

| Define | Default | Purpose |
|---|---|---|
| `API_BASE_URL` | `http://10.0.2.2:3002/api/v1` | The `apps/api` base URL. |
| `CLOUDINARY_CLOUD_NAME` | _(unset — local media shape)_ | If set, image URLs use the Cloudinary shape instead of `{API_BASE_URL}/media-delivery/...`. Only needed once the owner delivers the Cloudinary account. |

## Checks

```bash
flutter analyze   # must be clean
flutter test      # 148 tests, must be green
flutter build web # extra compile check (used during development)
```

CI (`.github/workflows/mobile.yml`) runs `flutter analyze` + `flutter test`
on every push/PR touching `apps/mobile/**`.

## Architecture

Feature-first, one folder per feature under `lib/src/features/`:

```
lib/
  main.dart                     # entry: ProviderScope + NestElectroApp
  src/
    app.dart                    # MaterialApp.router, theme + locale wiring
    core/
      api/                      # ApiClient (dio), ApiException, ApiConfig,
                                # TokenStorage (flutter_secure_storage)
      config/                   # dart-define reads (API base URL, Cloudinary)
      l10n/                     # gen_l10n: app_en.arb / app_ar.arb (Arabic default)
      models/                   # freezed DTOs generated from the OpenAPI schemas
      routing/                  # go_router table + auth guards
      theme/                    # AppColors / AppTheme (storefront palette)
    features/
      auth/                     # login / register / forgot / reset / verify
      catalogue/                # home, categories, product list/detail, search
      cart/                     # server cart (authed) + guest basket (local)
      checkout/                 # addresses, per-address quote, manual payments,
                                # order placement (Idempotency-Key)
      account/                  # profile, orders, addresses, wishlist
      home/                     # home screen sections (hero, rails, brands)
      common/                   # shared widgets (error/empty/loading states)
```

### State

- **Riverpod 2** (`Notifier` / `FamilyNotifier`). Repositories take
  `ApiClient` via `apiClientProvider`; controllers are plain classes with
  `copyWith` state (not freezed state). A controller's `build()` loads
  its first page in a microtask; anything it needs from a watched
  provider is captured in `build()` and passed in — never read inside
  the async load (Riverpod stale-dependency guard; see D-30).
- **Routing:** `go_router` with a `refreshListenable` on the auth
  controller. `/cart` and `/wishlist` are guest-accessible; `/checkout`,
  `/checkout/confirmation` and `/account*` redirect guests to
  `/login?redirect=...`; logged-in users on `/login` / `/register` go
  to `/`.
- **HTTP:** dio with an `Accept-Language` header following the app locale
  (the API localizes names/descriptions from the header), a Bearer token
  interceptor, and a 401 refresh-once with a shared in-flight refresh.
  Every failure maps to `ApiException` from the API's
  `{ error: { code, message, details } }` envelope.
- **Money:** integer piastres (EGP). Display the API's `formatted`
  strings when present.
- **Images:** the API stores no URLs; the client derives them
  (`ApiConfig.imageUrl`), mirroring `apps/storefront/src/lib/images.ts`.
  Images are cached (`cached_network_image`) with placeholder + error
  widget; a missing image never crashes a screen.

### i18n

Arabic is the default locale, English is second (`gen_l10n`,
`lib/src/core/l10n/app_en.arb` / `app_ar.arb`, generated output committed
under `lib/src/core/l10n/gen/`). After editing an `.arb` file, run
`flutter pub get` to regenerate. RTL is checked on every screen (see
`test/rtl_and_a11y_test.dart`).

## What is mocked

Some storefront screens have no API endpoint. They are built against
clearly marked mock repositories (`// MOCK:` header) and recorded in
[API_GAPS.md](API_GAPS.md) — wishlist (device-only, SharedPreferences),
blog (static placeholder posts), product reviews (rating display only,
no submission), coupons (no input). Payments are manual-only
(COD / wallet / InstaPay instructions from the API; no gateway SDK),
push notifications do not exist, and guest checkout is not possible
(`POST /orders` requires auth) — all matching the API and the
storefront. When the API gains an endpoint, the mock is swapped for the
real repository; the UI and state layers do not change.

## Tests

`test/` mirrors `lib/` plus `test/integration/happy_path_test.dart`
(browse → cart → checkout → confirmation against mocked repositories,
Arabic locale) and `test/rtl_and_a11y_test.dart` (RTL + WCAG AA contrast
checks). Test conventions learned the hard way and worth keeping:

- Fixtures are literal JSON maps — freezed `toJson()` does not
  deep-serialize nested DTOs.
- `SharedPreferences.setMockInitialValues({})` in `setUpAll` for any test
  that touches guest storage (cart / wishlist).
- `GoogleFonts.config.allowRuntimeFetching = false` in `setUpAll` before
  anything constructs `AppTheme`.
- Manual pumps, not `pumpAndSettle` — the home hero's 8-second
  auto-advance timer never settles.
- `FilledButton.icon`'s runtime type is the private `_FilledButtonWithIcon`,
  so `find.widgetWithText(FilledButton, …)` never matches it — tap the
  label text instead.
- Sections below the fold need `ensureVisible` (single-scroll views) or
  a manual drag loop (lazy `ListView`s); dialog fields need
  `find.descendant(of: find.byType(AlertDialog))`.
