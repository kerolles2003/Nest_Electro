# PROGRESS — Nest Electro Flutter app

Heartbeat protocol: on every wake-up, read this file + `git status` / `git log`,
continue from "Next step". Do not restart finished work. A step that fails 3 times
goes under Blockers with a workaround/skip.

## Current phase

**Phase 0 — Recon (in progress)**

- Branch: `flutter/phase-0-recon` (cut from `flutter-app` at `5a1fd5c`).
- `flutter-app` branch cut from `origin/phase-1-2-overnight` at `5a1fd5c`
  (`git fetch origin` worked; see DECISIONS.md D-01).
- Flutter SDK 3.35.7 downloading to `~/workspace/flutter-3.35.7.tar.xz`
  (extract to `~/workspace/flutter-sdk`, add `bin/` to PATH).

## Last completed step

- Recon of storefront routes (20 routes) and live OpenAPI spec (74 paths, 177 schemas).
- Wrote `SCREENS.md` (screen map + API facts) and `API_GAPS.md` (G1–G9).
- Wrote `DECISIONS.md` (D-01…D-07) and this file.

## Next step

1. Verify Flutter SDK download (sha256), extract, `flutter doctor`, `flutter --version`.
2. Commit Phase 0 docs on `flutter/phase-0-recon` (explicit `git add` of the 4 files).
3. Phase 0 gate: no Dart code yet — gate is the docs themselves. Create the
   `flutter/phase-0-recon` branch on GitHub from `flutter-app`, upload the docs
   via the connector, open PR into `flutter-app`, merge.
4. Phase 1 — Scaffold (`flutter create`, structure, lints, Riverpod, go_router,
   dio, freezed, theme, i18n).

## Blockers

- None yet.
- Note: sandbox memory is tight (8 GB total, ~450 MB available with the demo
  running). If a Flutter build OOMs, stop the demo servers and retry — the demo
  can be rebuilt later; the app work takes priority.

## Phase checklist

- [x] 0. Recon — SCREENS.md + API_GAPS.md
- [ ] 1. Scaffold
- [ ] 2. Core (dio client, models)
- [ ] 3. Auth
- [ ] 4. Catalogue
- [ ] 5. Cart & checkout
- [ ] 6. Account
- [ ] 7. Polish
- [ ] 8. Quality (tests + CI workflow)
- [ ] 9. Wrap-up (README.md, REPORT.md, final PR — DO NOT merge)
