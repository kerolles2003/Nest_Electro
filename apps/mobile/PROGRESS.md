# PROGRESS — Nest Electro Flutter app

Heartbeat protocol: on every wake-up, read this file + `git status` / `git log`,
continue from "Next step". Do not restart finished work. A step that fails 3 times
goes under Blockers with a workaround/skip.

## Plan (owner decision, 2026-11-27 evening — see DECISIONS.md D-08)

Per-phase GitHub PRs/merges are OFF (owner asleep, cannot approve cards).
Each phase: own local branch `flutter/phase-N-<name>` from `flutter-app` →
gate (`flutter analyze` clean, `flutter test` green) → merge LOCALLY into
`flutter-app` with a real merge commit. NO GitHub writes until the final sync
after Phase 9: one sync (create `flutter-app` if missing, upload files, open
final PR `flutter-app` → `phase-1-2-overnight`, DO NOT merge). Fallback: git
bundle of `flutter-app` + phase branches, path in `REPORT.md`.

## Current phase

**Phase 1 — Scaffold (in progress)**

- Branch: `flutter/phase-1-scaffold` (cut from `flutter-app` at `f91cade`).
- Flutter SDK 3.35.7 installed at `~/workspace/flutter-sdk` (Dart 3.9.2);
  `flutter doctor` done — no Android SDK / Chrome / Linux toolchain (D-10).
- `flutter create` done (org `com.nestelectro`, android + ios + web, 81 files).
  Scaffold files still untracked; config files (pubspec, theme, router, l10n)
  not yet written.

## Last completed step

- **Phase 0 — DONE.** Docs committed locally (`f91cade`); PR #3 merged on
  GitHub (merge commit `81d1037`, remote `flutter-app` tip); local
  `flutter-app` fast-forwarded to `f91cade`. Remote/local SHA difference
  recorded (D-09) — same phase-0 content.
- Plan change recorded in `DECISIONS.md` (D-08…D-11); this file brought in
  line with reality.
- Storefront theme tokens verified, including the `.dark` block
  (dark primary `#00d4ff`, background `#0c1322`).

## Next step

1. Write Phase 1 config: `pubspec.yaml` (Riverpod, go_router, dio,
   freezed/json_serializable, flutter_secure_storage, google_fonts,
   cached_network_image, intl, uuid), `analysis_options.yaml`
   (flutter_lints + strict extras), `l10n.yaml` + `app_en.arb`/`app_ar.arb`,
   `lib/src/core/theme/app_theme.dart` (light + dark from storefront tokens),
   `lib/src/core/config/api_config.dart` (dart-define base URL + image-URL
   helper), `lib/src/core/routing/app_router.dart` (all routes; placeholders
   until their phases), `lib/src/app.dart`, `lib/main.dart`, placeholder
   home screen, smoke widget test.
2. `flutter pub get` → `flutter analyze` → `flutter test` (gate).
3. Commit Phase 1 on `flutter/phase-1-scaffold` (explicit `git add` of the
   phase files only — never `git add -A`; never touch
   `MUSE_FINAL_GITHUB_HANDOFF_REVIEW.md`).
4. Merge `flutter/phase-1-scaffold` LOCALLY into `flutter-app` (merge commit),
   verify `git log`, then start Phase 2.

## Blockers

- None yet.
- Note: sandbox memory is tight (8 GB total, ~450 MB available with the demo
  running). If a Flutter build OOMs, stop the demo servers and retry — the demo
  can be rebuilt later; the app work takes priority.

## Phase checklist

- [x] 0. Recon — SCREENS.md + API_GAPS.md (merged: GitHub PR #3 `81d1037`)
- [ ] 1. Scaffold
- [ ] 2. Core (dio client, models)
- [ ] 3. Auth
- [ ] 4. Catalogue
- [ ] 5. Cart & checkout
- [ ] 6. Account
- [ ] 7. Polish
- [ ] 8. Quality (tests + CI workflow)
- [ ] 9. Wrap-up (README.md, REPORT.md, final PR — DO NOT merge)
