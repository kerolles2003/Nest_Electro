# Nest Electro — Flutter mobile app: PROGRESS

Mission: build a Flutter customer-storefront app at `apps/mobile`, phases 0–9,
on local branch `flutter-app` cut from `origin/phase-1-2-overnight` (5a1fd5c).
Per-phase branches `flutter/phase-N-<name>` pass the gate
(`flutter analyze` clean, `flutter test` green) and are merged LOCALLY into
`flutter-app` with a real merge commit — no GitHub writes until the final sync
(owner decision D-08: he sleeps and cannot approve cards overnight).
Final PR `flutter-app` → `phase-1-2-overnight` is opened at the end and NOT
merged. Never touch main or phase-1-2-overnight; no force-push; no deploy.

Flutter SDK: `~/workspace/flutter-sdk` (3.35.7, Dart 3.9.2) — add `bin/` to PATH.
Demo API: http://127.0.0.1:3002/api/v1 (health ok, 60 products). Do NOT run a
full Jest run (1.5-CPU cell). Never stage/commit/discard the untracked
`MUSE_FINAL_GITHUB_HANDOFF_REVIEW.md` in the repo root.

## Current phase: 9 — Wrap-up (NOT started)

## Last completed step

- Phase 8 (Quality) DONE and merged locally.
  - Phase branch `flutter/phase-8-quality`, commit `89c9efa`
    ("test(mobile): phase 8 quality", 13 files, +2142/−60).
  - Merged into `flutter-app` with merge commit `49172ab`.
  - Gate re-verified on the merged tree: analyze clean, test 148/148.
  - Unit tests (21 new, all passing):
    `test/core/api/api_client_test.dart` (6 — interceptor headers,
    401 → refresh once + retry, failed refresh clears tokens and throws
    the ORIGINAL 401 envelope, no double-refresh on the retried request,
    concurrent 401s share one in-flight refresh, non-401 maps the
    envelope without refreshing; fake HttpClientAdapter + in-memory fake
    TokenStorage, injected dio/refreshDio),
    `test/features/auth/auth_repository_test.dart` (6 — login saves
    tokens, register saves none, logout clears in `finally` but still
    propagates the server error, logoutAll, me, forgot/reset/verify/
    resend),
    `test/features/checkout/checkout_repository_test.dart` (5 — quote,
    payment methods, placeOrder posts `Idempotency-Key` and strips nulls,
    list/create address),
    `test/features/account/wishlist_controller_test.dart` (4 — load,
    toggle add with snapshot, toggle remove, remove by id).
  - Widget tests (10 new, all passing):
    `test/features/catalogue/categories_screen_test.dart` (2 — roots with
    children grouped under ExpansionTiles; error + retry),
    `test/features/account/order_detail_screen_test.dart` (4 — PLACED
    shows items/totals/cancel, rejected verification shows resubmit,
    DELIVERED has no cancel, error + retry),
    `test/features/auth/register_screen_test.dart` (2 — validation
    errors; register navigates to `/verify-email`),
    `test/features/checkout/order_confirmation_screen_test.dart` (2 —
    COD shows number/total/cash note; wallet shows copyable transfer
    instructions).
  - Integration test (1 new, passing):
    `test/integration/happy_path_test.dart` — real `NestElectroApp`
    with mocked repos, Arabic locale: home → tap featured product →
    detail → add to cart → snackbar → view cart → checkout (default
    address + COD) → confirm → confirmation shows NE-1001 + 300.00 EGP.
  - GitHub Actions workflow added: `.github/workflows/mobile.yml`
    (analyze + test on apps/mobile only, Flutter pinned 3.35.7,
    `contents: read`, follows `ci.yml` conventions). Not run in CI yet —
    first run will be on the final PR (D-33).
  - Real bugs found and fixed by the integration test (D-30, D-32):
    CartController read providers inside its microtasked `_load` —
    Riverpod stale-dependency throw on auth change; `build()` now
    captures the watched value + repo + storage and passes them in.
    `_load` caught only `ApiException`, so a non-API failure (unmocked
    SharedPreferences in the test) left `isLoading: true` forever —
    generic catch now surfaces `LOAD_FAILED` with retry.
  - Decisions D-30 (stale-dependency fix), D-31 (D-29 refined:
    `AppTheme` CAN be constructed in tests if
    `allowRuntimeFetching = false` is set in `setUpAll` BEFORE the theme
    is constructed), D-32 (integration-test lessons + cart fix), D-33
    (mobile.yml workflow).
  - Test lessons: `FilledButton.icon` is a private `_FilledButtonWithIcon`
    subclass — `widgetWithText(FilledButton, …)` never matches it, tap
    the label text; cart mocks must be stateful (`getCart` returning
    empty forever lets a rebuild overwrite an added line); tests touching
    guest storage need `SharedPreferences.setMockInitialValues({})`.
  - Follow-up noted, not fixed: other controllers still catch only
    `ApiException` in their loads (same stuck-spinner class) — for
    REPORT.md.

## Next step

- Phase 9 (Wrap-up): README.md in apps/mobile (how to run against the
  local API, dart-defines, architecture) + REPORT.md (what's done,
  what's mocked, API gaps, known issues, what the owner needs to do
  next). Then the ONE GitHub sync (create `flutter-app` if missing —
  it already exists at `81d1037`, reuse it; upload all files; open the
  final PR `flutter-app` → `phase-1-2-overnight`, DO NOT merge) when the
  owner is awake to approve its cards. If sync cannot complete, prepare
  a git bundle of `flutter-app` + phase branches and record its path in
  REPORT.md.

## Phases done

- Phase 0 Recon — DONE (commit `f91cade`; PR #3 merged on GitHub `81d1037`
  before the plan change; remote `flutter-app` tip `81d1037` vs local
  `f91cade` — same content, different SHAs, D-09).
- Phase 1 Scaffold — DONE (commit `bfd98d5` + `da2ca51`, merge `ed0653d`).
  Gate: analyze clean, test 1/1.
- Phase 2 Core — DONE (commit `2856a00`, merge `d6305fd`).
  Gate: analyze clean, test 19/19.
- Phase 3 Auth — DONE (commit `1d239a3`, merge `328aacf`).
  Gate: analyze clean, test 36/36. Live-verified 401 INVALID_CREDENTIALS.
- Phase 4 Catalogue — DONE (commit `072a140`, merge `3066b42`).
  Gate: analyze clean, test 54/54, `flutter build web` passes.
- Phase 5 Cart & checkout — DONE (commit `690eac4`, merge `8c5452b`).
  Gate: analyze clean, test 79/79, `flutter build web` passes.
- Phase 6 Account — DONE (commit `5d5d594`, merge `9a55103`).
  Gate: analyze clean, test 112/112, `flutter build web` passes.
- Phase 7 Polish — DONE (commit `a0da7cc`, merge
  `44e8ad2`). Gate: analyze clean, test 116/116,
  `flutter build web` passes.
- Phase 8 Quality — DONE (commit `89c9efa` on `flutter/phase-8-quality`,
  merge `49172ab` into `flutter-app`). Gate: analyze clean, test 148/148.

## Phases remaining

- 9 Wrap-up (README.md + REPORT.md + final PR
  `flutter-app` → `phase-1-2-overnight`, NOT merged; one GitHub sync
  when the owner is awake; if sync cannot complete, prepare a git bundle
  of `flutter-app` + phase branches and record its path in REPORT.md).

## Blockers

- (none)
