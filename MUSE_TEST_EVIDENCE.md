# Muse — Test Evidence (Session 8, Final Adversarial Audit)

**Date:** 2026-11-22 · **Branch:** `muse/full-admin-redesign-product-catalog`
**Audited state:** `560564c` · **Final state:** fix commits `3a1c6ce`, `9f9d47b`, `a6e4939`, `1d60811`, `4d229ff` + docs commit
*(Supersedes the Session 3 test evidence that previously occupied this file; that evidence remains in git history.)*
Every result below is the actual output of the command named, run in this session against this branch. Environment: local MongoDB 8.x replica set `nest-test-rs0` (port 27018), production builds of all three apps, demo database `nest_browser_check`.

---

## 1. Automated test suite (API, Jest)

**Full run** (after the N-1 fix and its tests; demo DB dropped first — the suite's scratch-DB guard refuses to run while a demo database exists):

```
Test Suites: 1 skipped, 76 passed, 76 of 77 total
Tests:       15 skipped, 1505 passed, 1520 total
```

- Delta vs Session 7 (1503/1518): **exactly +2 tests** — the two N-1 regression tests. Zero failures.
- The skipped suite is `cloudinary-integration.spec.ts`, skipped by design (no Cloudinary account exists, D-4). The 15 skipped tests are that suite's plus provider-conditional cases.
- Teardown residue after the run: exactly **4 audit rows** — the established baseline, unchanged.
- **Exit-code precision (added on a post-report verification pass):** `pnpm test` exits **1** even with zero test failures, because the suite's global-teardown cleanliness assertion (`test/setup/assert-scratch-database-is-clean.ts`) deliberately fails the process when residue exists — and the 4 audit rows above are that residue. The rows are append-only audit records the suites write by design; the watchdog retains them "for inspection; never automatically reset or adopted". This is the long-standing baseline behaviour (Sessions 6 and 7 recorded the same 4 rows), not a Session 8 regression — but anyone running the suite should know the exit code means "residue present", not "tests failed". Test results themselves: 0 failures, as stated.
- **Final-HEAD re-run:** after all five fix commits landed, the full suite was run once more end-to-end at the final state: **Test Suites: 1 skipped, 76 passed, 76 of 77 total — Tests: 15 skipped, 1506 passed, 1521 total, 0 failures** (the +1 vs the run above is the B-3 regression test, which landed after it), with the same 4-row teardown residue and the same exit-code behaviour.
- Coverage includes the adversarial suites from earlier sessions (payment races, SoD, PAY-3 fail-closed gate, CSP, import) — all green, so Sessions 4–6 guarantees are re-verified, not assumed.

**Targeted re-runs after the later fixes:**

| Suites | Result |
|---|---|
| `test/import/catalogue-import.spec.ts` + `test/p1/import-image-version.spec.ts` (after the B-3 fix) | **70 passed, 70 total** — includes the new snapshot-Arabic copy-through test |
| `test/media/media-delivery.spec.ts` (after the honest-404 fix) | **6 passed, 6 total** — includes the new assertions that every refusal path returns 404 with `Cross-Origin-Resource-Policy: cross-origin` and `Cache-Control: no-store` |

**New/changed tests this session:** +2 in `payment-adversarial.spec.ts` (payment-less order: owner → audited 403 with `metadata.method 'UNKNOWN'`; other admin → 400), +1 in `catalogue-import.spec.ts` (snapshot copy-through), 4 delivery-spec tests rewritten from exception assertions to response assertions.

## 2. Type-checks, builds, lint, contract gates

| Check | Command | Result |
|---|---|---|
| API type-check | `tsc --noEmit` (apps/api) | ✅ exit 0 |
| Admin type-check | `tsc --noEmit` (apps/admin) | ✅ exit 0 |
| Storefront type-check | via `next build` type phase | ✅ exit 0 |
| API build | `pnpm build` (apps/api) | ✅ exit 0 |
| Admin build | `pnpm build` (apps/admin) | ✅ exit 0 |
| Storefront build | `pnpm build` (apps/storefront) | ✅ exit 0 |
| API lint | `pnpm lint` | ✅ exit 0 |
| Admin lint | `pnpm lint` | ✅ exit 0 — 32 warnings, all pre-existing (legacy `no-explicit-any` in the Phase-8 coupon/review code and similar), none in files this session touched |
| Storefront lint | `pnpm lint` | ⚠️ exit 2 — **pre-existing ESLint flat-config error** ("react-hooks plugin is not defined in your configuration file") thrown before any file is linted; independent of any Session 7/8 change (audit finding F8-11) |
| OpenAPI drift gate | `pnpm openapi:check` | ✅ "drift gate: OK, the API matches docs/api/openapi.v1.json" |
| OpenAPI page gate | `pnpm openapi:page:check` | ✅ OK — 74 paths, sha256 `c57739bc1b4f…`, 2 vendored assets verified |

**Environment-classified failure (not an app defect):** `next build` for both frontends fails at the `/_global-error` prerender ("Cannot read properties of null (reading 'useContext')") when `NODE_ENV=development` leaks into the build shell from the demo env script. With `NODE_ENV=production` set explicitly, both builds exit 0. Recorded so the next session does not re-diagnose it: **always build the frontends with `NODE_ENV=production` in the command itself.** Similarly, `openapi:check` fails without the API env (it boots the app to generate the spec); with the env sourced it passes, as recorded above.

## 3. Database and catalog evidence

Final audit of the populated demo catalog (direct MongoDB inspection, correct schema):

```
products=60  issues=0  []
products: 60 — ok=60 noImage=0 broken=0 multiImage=0 uniquePublicIds=60   (delivery verification)
```

- 60/60 products: bilingual name/short/description (Arabic ≥ 40 chars), SEO present, ≥ 3 specs, no negative stock, no invalid sale price, category/brand snapshots carry Arabic.
- Taxonomy: 15 categories, 9 brands — all bilingual after the fix (13 categories + 7 brands patched via the admin API, 0 failures).
- Images on disk: 60 source PNGs, **60 unique MD5 hashes, 0 duplicates**, valid PNG signatures, uniform square dimensions.
- Demo orders present for UI verification: wallet order `NE-20261122-0001` in `PENDING_VERIFICATION`, COD order `NE-20261122-0002` placed; shipping rates seeded (27 rows).
- The same rebuild performed *before* the B-3 import fix produced exactly 7 snapshot-Arabic gaps; *after* the fix it produces **0 with no repair step** — the mechanism fix proven end-to-end.

## 4. Media security evidence (live probes)

| Probe | Result |
|---|---|
| Traversal shapes (`..%2f`, `%2e%2e`, dotted ids, no-slash ids, unknown ids) | all **404** |
| Orphan file on disk, no ledger row | **404** (ledger gate holds) |
| Boot with `NODE_ENV=production` + `MEDIA_PROVIDER=local` | **refused** by config validation with the intended message (same for `memory`) |
| Delivery of a known asset | 200, `Cross-Origin-Resource-Policy: cross-origin`, `Cache-Control: public, max-age=31536000, immutable` |
| Delivery refusal (after F8-06 fix) | 404, `Cross-Origin-Resource-Policy: cross-origin`, `Cache-Control: no-store` — verified live with curl |
| Cold probe (cleared optimizer cache, fresh API + browser) | 17/17 delivery responses 200 with correct CORP |
| Orphan census | 84 files / 104.3 MB with no ledger row — not servable; hygiene finding F8-07 |

## 5. Browser evidence (production builds)

- **Route sweep** (all admin routes + storefront, viewports 1440/768/390): every route 200, **zero console errors** — including /coupons and /reviews after the F8-01 fix (pre-fix: server RSC error, digest `1375520748`).
- **End-to-end smoke** (final build, three consecutive runs): home 29/29 images, products grid 16/16, search `?q=esp32` 16/16, category (displays) 6 cards, price-ascending sort 32 cards, product detail 5/5 images with specs, mobile grid 16/16, admin products 20/20, admin edit page image loads — **zero console/network errors**.
- **Accessibility (axe, full ruleset):**

| Page | Before Session 8 | After |
|---|---|---|
| Admin dashboard | serious color-contrast violations | **0 violations** |
| Admin products | serious color-contrast (54 nodes) | **0 violations** |
| Admin orders | serious color-contrast | **0 violations** |
| Storefront home | minor image-redundant-alt ×8 | **0 violations** |
| Storefront products | 0 | 0 |
| Storefront detail | 0 | 0 |

Contrast ratios quoted in the audit were computed with the WCAG relative-luminance formula, not eyeballed (e.g. success `#16a34a` on its tint = 2.95:1 → `#166534` = 6.40:1).

- **Screenshots** captured during the session (audit workspace `browser-check/shots-audit/`): the fixed coupons page, the route sweep set at three viewports, contrast before/after states.

## 6. What was not run, and why

- **Cloudinary integration suite** — skipped by design; the account is an owner deliverable (D-4) and no credentials exist in the sandbox.
- **`pnpm audit`** — the sandbox proxy blocks the registry audit endpoint; carried as a known gap since Session 3.
- **Playwright in CI** — no CI exists in the sandbox; browser verification above was run locally against production builds.
- **DB-backed verification against any production/shared database** — none exists in scope; all evidence is from the local demo database, rebuilt from scratch three times during the session.
