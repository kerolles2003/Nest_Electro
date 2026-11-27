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

**Phase 3 — Auth (starting)**

- Branch: `flutter/phase-3-auth` (to be cut from `flutter-app` at `d6305fd`).
- AuthRepository + AuthController (Riverpod), login/register/forgot/reset/
  verify screens, router guards (auth-required routes → /login, authed
  users away from /login|/register), 429 register rate-limit UX.

## Last completed step

- **Phase 2 — DONE.** Core committed (`2856a00`, 45 files, +20841) and
  merged LOCALLY into `flutter-app` (merge commit `d6305fd`). Gate passed:
  `flutter analyze` clean (no issues), `flutter test` green (19/19).
  Includes: ApiClient (dio + Accept-Language + Bearer + 401 refresh-once
  with shared in-flight refresh), TokenStorage, ApiException, freezed
  models for the full customer surface (verified against the live spec and
  live responses), D-12 (header-driven localization) + D-13 (nullability
  follows live data). One fix during the phase: `analysis_options.yaml`
  now ignores `invalid_annotation_target` — `@JsonKey` on freezed factory
  parameters is the documented pattern and IS consumed by the generator
  (verified `unknownValue:` in `*.g.dart`). One tooling hiccup: the first
  `build_runner` run was cut by a service restart with zero outputs; the
  retry completed (33 outputs, exit 0).
- **Phase 1 — DONE.** Scaffold committed (`bfd98d5`, 85 files) and merged
  LOCALLY into `flutter-app` (merge commit `ed0653d`). Gate passed:
  `flutter analyze` clean, `flutter test` green (1/1 smoke).
- **Phase 0 — DONE.** Docs committed locally (`f91cade`); PR #3 merged on
  GitHub (merge commit `81d1037`, remote `flutter-app` tip); local
  `flutter-app` fast-forwarded to `f91cade`. Remote/local SHA difference
  recorded (D-09) — same phase-0 content.
- Plan change recorded in `DECISIONS.md` (D-08…D-13).

## Next step

1. Cut `flutter/phase-3-auth` from `flutter-app`; mirror the storefront's
   auth form validation (check `apps/storefront` auth pages).
2. Write AuthRepository, AuthController (session restore on start via
   `GET /auth/me`), login/register/forgot/reset/verify screens, router
   guards via `refreshListenable`, ARB strings, 429 UX.
3. Tests: controller unit tests (mock ApiClient/TokenStorage), login
   widget test.
4. Gate (`flutter analyze` clean, `flutter test` green) → commit on
   `flutter/phase-3-auth` → merge LOCALLY into `flutter-app` → Phase 4.

## Blockers

- None yet.
- Note: sandbox memory is tight (8 GB total, ~450 MB available with the demo
  running). If a Flutter build OOMs, stop the demo servers and retry — the demo
  can be rebuilt later; the app work takes priority.

## Phase checklist

- [x] 0. Recon — SCREENS.md + API_GAPS.md (merged: GitHub PR #3 `81d1037`)
- [x] 1. Scaffold (merged locally: `ed0653d`; analyze clean, test 1/1)
- [x] 2. Core (dio client, models) (merged locally: `d6305fd`; analyze clean, test 19/19)
- [ ] 3. Auth
- [ ] 4. Catalogue
- [ ] 5. Cart & checkout
- [ ] 6. Account
- [ ] 7. Polish
- [ ] 8. Quality (tests + CI workflow)
- [ ] 9. Wrap-up (README.md, REPORT.md, final PR — DO NOT merge)
