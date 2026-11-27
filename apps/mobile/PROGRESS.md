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

**Phase 5 — Cart & checkout (starting)**

- Branch: `flutter/phase-5-cart-checkout` (to be cut from `flutter-app` at
  `3066b42`).
- CartRepository + cart state (local persistence, synced if the API
  supports it), cart screen, address selection, checkout quote,
  payment-methods, order placement with `Idempotency-Key`, order
  confirmation. Payments: use whatever the API exposes (COD / WALLET /
  INSTAPAY instructions); NO real payment gateway SDK — stub + log in
  API_GAPS.md if the flow needs one.

## Last completed step

- **Phase 4 — DONE.** Catalogue committed (`072a140`, 38 files, +5012)
  and merged LOCALLY into `flutter-app` (merge commit `3066b42`). Gate
  passed: `flutter analyze` clean, `flutter test` green (54/54). Includes:
  CatalogueRepository + ProductQuery + ProductListController, home (hero,
  trust bar, category grid, featured/new-arrival rails, brands strip),
  product list (search/filter/sort/infinite scroll), product detail
  (gallery, price block, specs, related), categories tree, category/brand
  screens, search with debounced suggestions, 66 new ARB strings
  (en + ar). `flutter build web` also passes. Live-verified: featured
  query returns 10 items with facets + priceRange; brand logo is null on
  live records (initial fallback). Fixes during the phase: ProductCard
  image uses `Expanded` (a square AspectRatio overflowed on wide cells)
  + Flexible price/rating rows; smoke test uses manual pumps (hero timer
  never settles under pumpAndSettle). Decisions D-14…D-19 recorded.
- **Phase 3 — DONE.** Auth committed (`1d239a3`, 23 files) and merged
  LOCALLY into `flutter-app` (merge commit `328aacf`). Gate passed:
  `flutter analyze` clean, `flutter test` green (36/36).
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
- Plan change recorded in `DECISIONS.md` (D-08…D-19).

## Next step

1. Cut `flutter/phase-5-cart-checkout` from `flutter-app`; read the
   storefront cart/checkout flow + the cart/order models from Phase 2
   (`GET /cart`, `POST /cart/items`, `PATCH/DELETE /cart/items/{id}`,
   `POST /cart/preview`, `POST /checkout/quote`, `GET
   /checkout/payment-methods`, `POST /orders` with `Idempotency-Key`).
2. Write CartRepository + cart state (Riverpod), cart screen (quantity
   steppers, line statuses, preview for guests), checkout screen
   (address → quote → payment method → place order), confirmation
   screen, "Add to cart" on the product detail screen, ARB strings.
3. Tests: cart repository + controller unit tests, cart/checkout widget
   tests (mocked repo).
4. Gate (`flutter analyze` clean, `flutter test` green) → commit on
   `flutter/phase-5-cart-checkout` → merge LOCALLY into `flutter-app` →
   Phase 6.

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
- [x] 4. Catalogue (merged locally: `3066b42`; analyze clean, test 54/54)
- [ ] 5. Cart & checkout
- [ ] 6. Account
- [ ] 7. Polish
- [ ] 8. Quality (tests + CI workflow)
- [ ] 9. Wrap-up (README.md, REPORT.md, final PR — DO NOT merge)
