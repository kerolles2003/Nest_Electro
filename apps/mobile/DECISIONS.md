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
