# Autonomous Mission — Test Evidence

Branch: `muse/autonomous-hardening`. All runs 2026-11-22 against the final code
unless marked baseline. Raw logs were kept during the session under /tmp
(jest-mission9, jest-pi2, jest-wsb, jest-final).

## Jest (API, DB-backed suites against a local MongoDB replica set)

| Run | Suites | Tests | Failures | Exit |
|---|---|---|---|---|
| Baseline (mission start, code = d9454e4) | 75 passed, 1 failed, 1 skipped (76 of 77) | 1505 passed, 1 failed, 15 skipped (1521) | 1 (addresses, transport ECONNRESET — flake, F9-05) + teardown guard failed the run on 4 residue rows | 1 |
| product-images + media-reconciliation (targeted, after F9-01 fix) | 2 passed | 41 passed | 0 | **0** |
| admin-taxonomy + admin-product-create (targeted, after F9-02 fix) | 2 passed | 72 passed | 0 | **0** |
| **Final full run (final HEAD)** | **77 passed, 1 skipped (77 of 78)** | **1517 passed, 15 skipped (1532)** | **0** | **0 — teardown guard silent, zero residue** |

Notes:
- The skipped suite is the Cloudinary suite, skipped by design (no account, D-01).
- The 15 skipped tests are pre-existing skips, unchanged.
- Test count delta vs baseline: +11 = 8 media-reconciliation unit tests + 3
  missing-name regression tests (F9-02). Suite delta: +1 (media-reconciliation).
- The baseline's single failure is classified as a load flake with evidence
  (F9-05): transport error under full parallel load on a 1.5-CPU sandbox;
  isolated re-run 104/104, exit 0; the final full run passed the same test.
- Exit-code semantics, stated plainly: before this mission `pnpm test` exited 1
  on every run because of the teardown residue (F9-01), despite 0 assertion
  failures. The guard was not weakened; the leaking suite was fixed. The final
  run's exit 0 is the first clean full-run exit in the project's recorded history.

## Type-checks

- apps/api `tsc --noEmit`: **exit 0**
- apps/storefront `tsc --noEmit`: **exit 0**
- apps/admin `tsc --noEmit`: **exit 0**
- packages/ui standalone `tsc --noEmit`: exit 2 on PRE-EXISTING errors in
  `src/dropdown-menu.tsx` and `src/toast.tsx` (exactOptionalPropertyTypes) —
  files untouched by this branch (last changed at the base commit) and not
  covered by any gate: the package has no typecheck script and both consuming
  apps type-check its source under their own configs and pass. Recorded as an
  observation, not a regression.

## Builds (production)

- apps/api `nest build`: **pass** (repeatedly, incl. inside openapi:check)
- apps/storefront `next build` (NODE_ENV=production): **pass**
- apps/admin `next build` (NODE_ENV=production): **pass** (rebuilt after the
  final OrderDetail fix)

## Lint

- apps/api `eslint src test`: **exit 0, 0 errors, 0 warnings**
- apps/admin: **exit 0, 0 errors, 32 warnings** (pre-existing downgraded debt)
- apps/storefront: **exit 0, 0 errors, 16 warnings** — before this mission it
  exited 2 on a config crash before linting anything (F9-03)

## OpenAPI gates

- `openapi:check` (drift vs docs/api/openapi.v1.json): **OK** — "the API matches
  docs/api/openapi.v1.json" (the F9-02 change is validation behaviour; `name`
  was already documented as required, so no schema drift)
- `openapi:page:check`: **pass**

## Live verification (demo environment, final builds)

- Demo rebuilt from scratch: 60 products, catalog audit **0 issues**, 15
  categories, 9 brands, 60 media assets, 27 shipping rates, 6 orders (COD +
  Wallet PENDING_VERIFICATION mix), health `{"status":"ok"}` after indexes:sync.
- F9-02 probes: product/category/brand create without `name` → **400
  VALIDATION_ERROR** with `details[0] = {field: "name", code: "ISDEFINED"}`
  (before the fix: 500 INTERNAL_ERROR on all three, server log TypeError in
  `toLocalized`).
- API consistency sampling (19 endpoints): pagination meta identical on all
  paginated endpoints; `{data}` shape on non-paginated collections; uniform
  error envelope `{error:{code,message,requestId,timestamp}}`; unknown fields
  refused with 400 UNKNOWN_FIELD.
- `media:reconcile` against the demo: 444 files on disk, 60 matched, **384
  orphans / 501,279,722 bytes**, 0 live rows missing a file, exit 0.
- Accessibility: axe-core full rule set, **26 page/state combinations, 0
  violations** on the final sweep (14 admin routes + inventory Low-stock and
  Out-of-stock states; storefront home/products/detail/cart/category/search on
  desktop and mobile 390×844).
- CSP: no policy files touched this mission; the local-media configuration
  remains unset in the production shape, so the session-6/7 fingerprint work is
  unaffected.
