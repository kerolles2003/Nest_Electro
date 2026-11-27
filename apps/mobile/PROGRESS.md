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

**Phase 2 — Core (starting)**

- Branch: `flutter/phase-2-core` (to be cut from `flutter-app` at `ed0653d`).
- Dio client + error mapping + token storage + refresh; models from the
  OpenAPI schemas (`/tmp/openapi.json`, 74 paths, 177 schemas).

## Last completed step

- **Phase 1 — DONE.** Scaffold committed (`bfd98d5`, 85 files) and merged
  LOCALLY into `flutter-app` (merge commit `ed0653d`). Gate passed:
  `flutter analyze` clean (no issues), `flutter test` green (1/1 smoke).
  Includes: `flutter create` output, Riverpod/go_router/dio/freezed/
  flutter_secure_storage/google_fonts/cached_network_image/intl/uuid,
  light+dark theme from storefront tokens, go_router table for all 20 routes
  (placeholders), gen_l10n ar (default) + en, `ApiConfig` dart-define base
  URL + image-URL helper. One fix during the phase: removed the deprecated
  `synthetic-package` key from `l10n.yaml` (Flutter 3.35 ignores it and
  `pub get` exited 2 while it was present).
- **Phase 0 — DONE.** Docs committed locally (`f91cade`); PR #3 merged on
  GitHub (merge commit `81d1037`, remote `flutter-app` tip); local
  `flutter-app` fast-forwarded to `f91cade`. Remote/local SHA difference
  recorded (D-09) — same phase-0 content.
- Plan change recorded in `DECISIONS.md` (D-08…D-11); this file brought in
  line with reality.
- Storefront theme tokens verified, including the `.dark` block
  (dark primary `#00d4ff`, background `#0c1322`).

## Next step

1. Cut `flutter/phase-2-core` from `flutter-app`; verify API health
   (`http://127.0.0.1:3002/api/v1/health`) and re-read `/tmp/openapi.json`.
2. Write the core API layer: `ApiClient` (dio + interceptors), `ApiException`
   (error-envelope mapping), `TokenStorage` (flutter_secure_storage),
   refresh-on-401 with single retry; freezed models from the OpenAPI
   schemas (auth, category, brand, product, address, cart, order, money,
   pagination envelope).
3. Unit tests: error-envelope mapping, image-URL derivation, token storage.
4. Gate (`flutter analyze` clean, `flutter test` green) → commit on
   `flutter/phase-2-core` → merge LOCALLY into `flutter-app` → Phase 3.

## Blockers

- None yet.
- Note: sandbox memory is tight (8 GB total, ~450 MB available with the demo
  running). If a Flutter build OOMs, stop the demo servers and retry — the demo
  can be rebuilt later; the app work takes priority.

## Phase checklist

- [x] 0. Recon — SCREENS.md + API_GAPS.md (merged: GitHub PR #3 `81d1037`)
- [x] 1. Scaffold (merged locally: `ed0653d`; analyze clean, test 1/1)
- [ ] 2. Core (dio client, models)
- [ ] 3. Auth
- [ ] 4. Catalogue
- [ ] 5. Cart & checkout
- [ ] 6. Account
- [ ] 7. Polish
- [ ] 8. Quality (tests + CI workflow)
- [ ] 9. Wrap-up (README.md, REPORT.md, final PR — DO NOT merge)
