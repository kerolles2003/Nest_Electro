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

**Phase 4 — Catalogue (starting)**

- Branch: `flutter/phase-4-catalogue` (to be cut from `flutter-app` at
  `328aacf`).
- CatalogueRepository + Riverpod providers, home (hero, categories,
  featured, brands), categories, product list (search/filter/sort/
  pagination), product detail with image gallery.

## Last completed step

- **Phase 3 — DONE.** Auth committed (`1d239a3`, 23 files) and merged
  LOCALLY into `flutter-app` (merge commit `328aacf`). Gate passed:
  `flutter analyze` clean, `flutter test` green (36/36). Includes:
  AuthRepository, AuthController (session restore, errors as ApiException),
  5 screens, router guards, validation mirroring the API policy
  (password 10/72, Egyptian mobile). Fixes during the phase: freezed
  union cases are library-private — state is read via an `AuthStateX`
  extension (custom getters in the class body do not survive freezed
  union codegen); login widget test tapped the AppBar title instead of
  the button (same "Log in" text) — fixed with
  `find.widgetWithText(ElevatedButton, …)`.
- **Demo restored (2026-11-27 ~19:40 EET).** The sandbox service restart
  had killed mongod + all three servers. Restarted from the intact data
  dir (no re-seed): mongod 27018, API 3002 (health ok), storefront 3000
  (200), admin 3001 (200); catalogue still 60 products. Live login probe:
  wrong credentials → 401 `INVALID_CREDENTIALS` envelope, exactly the
  shape `ApiException` maps.
- **Phase 2 — DONE.** Core committed (`2856a00`, 45 files) and merged
  LOCALLY into `flutter-app` (`d6305fd`). Gate: analyze clean, test 19/19.
- **Phase 1 — DONE.** Scaffold committed (`bfd98d5`) and merged locally
  (`ed0653d`). Gate: analyze clean, test 1/1.
- **Phase 0 — DONE.** Docs (`f91cade`); PR #3 merged on GitHub
  (`81d1037`); local `flutter-app` fast-forwarded to `f91cade` (D-09).
- Plan change recorded in `DECISIONS.md` (D-08…D-13).

## Next step

1. Cut `flutter/phase-4-catalogue` from `flutter-app`; mirror the
   storefront's home sections and product-list filters
   (`apps/storefront/src/app/page.tsx`, `products/`).
2. Write CatalogueRepository + providers (list w/ pagination, detail,
   related, suggestions, categories, brands), home/categories/list/
   detail/search screens with gallery, ARB strings.
3. Tests: repository + list-controller unit tests, list/detail widget
   tests (mocked repo).
4. Gate (`flutter analyze` clean, `flutter test` green) → commit on
   `flutter/phase-4-catalogue` → merge LOCALLY into `flutter-app` →
   Phase 5.

## Blockers

- None yet.
- Note: sandbox memory is tight (8 GB total, ~450 MB available with the demo
  running). If a Flutter build OOMs, stop the demo servers and retry — the demo
  can be rebuilt later; the app work takes priority.
- Note: `muse.edit` on this file twice failed to match visually-identical
  text (2026-11-27, similarity 0.99) — likely invisible whitespace; rewrite
  the whole file with `muse.write` instead of editing it in place, and never
  run two edits on the same file in parallel.

## Phase checklist

- [x] 0. Recon — SCREENS.md + API_GAPS.md (merged: GitHub PR #3 `81d1037`)
- [x] 1. Scaffold (merged locally: `ed0653d`; analyze clean, test 1/1)
- [x] 2. Core (dio client, models) (merged locally: `d6305fd`; analyze clean, test 19/19)
- [x] 3. Auth (merged locally: `328aacf`; analyze clean, test 36/36)
- [ ] 4. Catalogue
- [ ] 5. Cart & checkout
- [ ] 6. Account
- [ ] 7. Polish
- [ ] 8. Quality (tests + CI workflow)
- [ ] 9. Wrap-up (README.md, REPORT.md, final PR — DO NOT merge)
