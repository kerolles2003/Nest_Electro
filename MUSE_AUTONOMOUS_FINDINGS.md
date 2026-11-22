# Autonomous Mission — Findings

Branch: `muse/autonomous-hardening` (from `d9454e4`, the reviewed PR branch, which stays frozen)
Date: 2026-11-22. All findings were reproduced before being fixed; severities reflect
user/operator impact, not code aesthetics.

## F9-01 — Jest teardown guard failed every full run on exactly 4 audit rows (P2, FIXED)

- **Root cause:** `test/catalog/product-images.spec.ts` cleans its audit rows by
  `entity.id ∈ createdProductIds`, but media deletions are audited against the
  ASSET (`entity.type = MEDIA`, `entity.id` = asset id, `entity.label` = publicId).
  Every run left 2 × (MEDIA_DELETE_REQUESTED + MEDIA_DELETED) = 4 rows, and the
  global teardown guard (`assert-scratch-database-is-clean`) failed the process
  despite 0 test failures — training everyone to ignore a red `pnpm test`.
- **Verified from the retained scratch DB** of a live run: the 4 rows are the
  product-images suite's own deletions (actor "Image operator"). The asset
  documents are gone by teardown (a completed destroy removes them), so the fix
  keys on the audit row's own `entity.label` prefix (`nest/products/<productId>/`)
  scoped to the suite's created products.
- **Fix:** test-only, in the suite's `afterAll`. The guard itself was NOT touched,
  no collection was excluded, no baseline was adjusted.
- **Proof:** the suite now exits 0 standalone with the guard active, and the final
  full run exits 0 (see MUSE_AUTONOMOUS_TEST_EVIDENCE.md).

## F9-02 — Missing nested `name` on create endpoints returned 500 (P2, FIXED)

- **Endpoints:** POST /admin/catalog/products, /admin/catalog/categories,
  /admin/catalog/brands — a body that omits `name` entirely answered
  `500 INTERNAL_ERROR`; every other malformed body on the same endpoints answers
  the standard `400 VALIDATION_ERROR` with field details.
- **Root cause:** the three create DTOs mark `name` with `@ValidateNested()` only.
  class-validator skips nested validation for an ABSENT property, so the body
  passed the pipe and the service dereferenced `undefined` in `toLocalized()`
  (TypeError, captured in the server log). Scalar fields never had the hole
  (`@IsString` fails on undefined); array fields are covered by `@IsArray`.
  A codebase-wide scan for required nested DTO properties found exactly these
  three unprotected fields.
- **Fix:** `@IsDefined({ message: 'name is required' })` on the three fields —
  the API now answers 400 with `details: [{field: 'name', code: 'ISDEFINED', …}]`,
  matching the established error contract. No service code changed; validation
  stays at the boundary where this codebase puts it.
- **Tests:** regression cases added to admin-taxonomy.spec.ts (category + brand)
  and admin-product-create.spec.ts (product), all asserting 400 + VALIDATION_ERROR
  + a `name` detail. Live-verified against the running API before and after.

## F9-03 — Storefront `pnpm lint` crashed before linting anything (P3, FIXED)

- **Symptom:** exit 2, "could not find plugin react-hooks" — reported in session 8
  as a pre-existing flat-config error (F8-11) and left unfixed.
- **Root cause:** eslint-config-next registers the react-hooks plugin only for
  js/jsx/mjs/ts/tsx/mts/cts files. The storefront's unscoped rule-override block
  names react-hooks rules, and `scripts/*.cjs` (CommonJS CSP test harnesses) fall
  outside the plugin's file set, so config validation crashed on them. Admin has
  no .cjs files, which is why only the storefront broke. (The .cjs files are also
  unlintable by the preset in substance: the rules that do reach them forbid
  `require()`, the only import mechanism the format has.)
- **Fix:** `scripts/**` added to `globalIgnores` in apps/storefront/eslint.config.mjs,
  with the reasoning recorded in the config, alongside the existing build-output
  ignores. Everything else is linted exactly as before.
- **Result:** lint exits 0 — 0 errors, 16 warnings (the deliberately downgraded
  debt stays visible, per the config's own policy).

## F9-04 — Accessibility violations on routes the earlier sweeps never covered (P2/P3, FIXED)

Session 8's axe sweep covered the dashboard, products, orders and three storefront
pages at desktop size. Extending the sweep to **every** admin route, the inventory
filter states, storefront category/brand/search pages and mobile viewports found:

1. **Admin /inventory — serious color-contrast.** The "Active" stat chip
   interpolated `text-primary` on `bg-primary/10` at 10px. Fixed with explicit
   chip classes (primary → `text-primary-ink`, the session-8 AA ink token; status
   hues → their deepened AA tokens), matching AuditLogTable's existing pattern.
2. **Storefront mobile — serious link-name.** The header login link's text is
   `hidden sm:block`; on mobile the icon-only link had no accessible name.
   Fixed with `aria-label="Login to your account"`.
3. **Storefront search — critical button-name.** The search submit button is
   icon-only and had no label (its sibling clear button already had one).
   Fixed with `aria-label="Search"`.
4. **Storefront — moderate heading-order ×2 shapes.** (a) Footer column titles
   were `h3`; on pages with no content `h2` (cart) the outline skipped h1 → h3.
   Now `h2`. (b) Product-card titles were always `h3`; on listing pages they sit
   directly under the page `h1` and on mobile there is no intervening `h2` at
   all (the Filters `h2` is in the collapsed panel). `ProductCard` gained a
   `titleAs` prop (`h2` | `h3`, default `h3`); listing/category/brand/search
   pages pass `h2`; sectioned contexts (home rails, related products) keep `h3`.
5. **Storefront mobile — serious color-contrast.** Mobile bottom-nav labels use
   `--color-foreground-muted` #6b7280, which is 4.83:1 on white but **4.39:1 on
   the #f4f4f5 surface tint** (measured by axe over the cart page). The light
   theme's muted tokens (`--color-foreground-muted`, `--color-muted-foreground`,
   and the woodmart variant) are deepened to #5f6873 — the value the admin theme
   adopted for the same role in session 8 (~4.8:1 on the tint, ~5.9:1 on white).

6. **Admin order detail (COD) — serious color-contrast.** The COD banner's
   explanatory text used `text-warning/80` over a warning tint — under the AA
   floor. It only renders on COD orders, so it surfaced only when the sweep's
   order-detail target happened to be a COD order (the final regression sweep,
   after a demo rebuild, opened one; the earlier sweep's first order was a
   wallet order). Fixed by letting the span inherit the banner's full-strength
   warning token. A codebase grep confirms no other opacity-diluted status
   text exists in either app or the UI package.

- **Verification:** full axe rule set over 26 page/state combinations (14 admin
  routes + 3 inventory states, storefront desktop + mobile incl. category and
  search): **0 violations**, confirmed on the final regression sweep against
  the final builds.

## F9-05 — Addresses concurrency test failed under full-run load (INFO, not a product defect)

- In the mission's baseline full run, `test/users/addresses.spec.ts` failed one
  test (`never produces two defaults under concurrent default changes`) with
  `read ECONNRESET` — a transport error, not an assertion failure, while ~77
  suites shared the sandbox's 1.5 CPUs. Run in isolation the suite passes
  104/104 with a clean teardown. Classified as a load flake and recorded as
  such; if it recurs in the final full run it will be reported as recurring,
  still not as a product bug. No test was weakened.

## F9-06 — Observations (not fixed, by design)

- **Dark theme muted token:** the storefront `.dark` theme's
  `--color-foreground-muted` (#64748b on #0c1322, ≈3.9:1 by calculation) was not
  measured live — dark mode was outside every sweep's scope and is not the
  default theme. Recorded here rather than changed unmeasured.
- **`toLocalized()` assumes its input:** the services dereference the localized
  input directly. After F9-02 the HTTP boundary guarantees presence; the import
  runner validates its own input. Left as-is — hardening internal call sites
  against their own validated callers is churn, not safety.
- **Orphan media grew:** 84 files / 104.3 MB (session 8) → 384 files / 478 MB,
  purely from repeated local demo rebuilds (each uploads fresh copies). The new
  report-only `media:reconcile` tool prints the exact list; deletion remains the
  owner's decision (register D-09).
- **Demo rebuild sequence** (for whoever rebuilds the local demo next): seed
  catalogue → seed dev admin → seed shipping → seed sandbox → catalogue import →
  taxonomy/enrich/attach scripts → `indexes:sync` (without it, health reports
  degraded and no unique index exists in the demo DB) → place orders.
