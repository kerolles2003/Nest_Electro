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
