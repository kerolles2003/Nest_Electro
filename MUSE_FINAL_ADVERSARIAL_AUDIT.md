# Muse — Final Adversarial Audit (Session 8)

**Date:** 2026-11-22
**Branch:** `muse/full-admin-redesign-product-catalog`
**Starting HEAD:** `560564c2b43313bd6f7f385d999fb62bd56aa29a` (verified before any work: branch, HEAD and clean tree all matched the brief; the Session 7 diff `c34347e..560564c` is exactly 20 files, +1043/−128)
**Scope:** everything Session 7 shipped — the admin redesign, the completed 60-product catalog, the local media adapter — plus the three investigations the brief named (the /coupons and /reviews RSC errors, finding N-1, and the blog/ADV-3 question). Method: code review of the full diff, live adversarial probes against a running production-build environment, direct database inspection, and a full automated regression. Nothing was assumed from the Session 7 report; every claim in it that this audit relies on was re-verified independently.

**Headline:** Session 7's work is substantially sound. The audit found **no P0**. It confirmed **one P1** (the two Phase-8 admin routes crashed outright in the sanctioned configuration), **three P2s** (a null-safety crash in payment verification; the demo catalog's bilingual/SEO gaps; a console-wide WCAG AA contrast failure cluster), and a set of P3s. Every confirmed issue that is safely fixable inside the mission boundaries is fixed, regression-tested, committed, and re-verified in the running application. Five fix commits sit on top of `560564c`; see §9.

---

## 1. Findings register

| ID | Severity | Title | Status |
|---|---|---|---|
| F8-01 | **P1** | /coupons and /reviews crash with an RSC server error when the legacy service is unconfigured | FIXED (commit `1d60811`) |
| F8-02 | **P2** | N-1 confirmed: payment verification `decide()` dereferences `order.payment` unguarded — a payment-less order 500s instead of returning the audited refusal | FIXED (commit `3a1c6ce`) |
| F8-03 | **P2** | Demo catalog incomplete: all 34 seed products lacked Arabic name/descriptions and SEO; 13/15 categories and 7/9 brands lacked Arabic names | FIXED in the catalog data (via the admin API); see §4 for why the repo seed files are intentionally not the fix site |
| F8-04 | **P2** | Admin console fails WCAG AA contrast on every page (axe: serious) after the redesign | FIXED (commit `4d229ff`) — axe now reports **zero violations on every audited page** |
| F8-05 | P3 | B-3: catalogue import hardcodes `ar: null` in category/brand snapshots, silently stripping Arabic names from imported products | FIXED (commit `9f9d47b`) + regression test |
| F8-06 | P3 | Media delivery 404s carried helmet's `Cross-Origin-Resource-Policy: same-origin`, so a missing image presented in the browser as a CORP block against the delivery route | FIXED (commit `a6e4939`) + spec assertions |
| F8-07 | P3 | 84 orphan media files (104.3 MB) on local disk with no ledger row | NOT servable (ledger gate proven live); hygiene only — recommendation in §5, no code change |
| F8-08 | P3 | `global-error.tsx` still used the legacy Concept 03 cream background | FIXED (in commit `4d229ff`) |
| F8-09 | P3 | Table headers still wore the legacy cream `#f3f3ed` — the one surface the redesign missed | FIXED (in commit `4d229ff`) |
| F8-10 | INFO | First cold browser run against a freshly seeded environment intermittently shows delivery-image failures that never reproduce warm; root-caused to error responses surfacing as CORP blocks (F8-06) over transient cold-start errors. Warm runs: 100% clean, three times | Explained; F8-06 removes the misleading failure mode |
| F8-11 | INFO | Storefront lint exits 2 on a pre-existing ESLint config error (`react-hooks` plugin not defined in the flat config) before linting any file — independent of any Session 7/8 change | Reported; not fixed (config surgery outside this mission's scope) |
| F8-12 | INFO | LocalMediaStorage upload has a theoretical existence-check race and non-atomic write | Dev-only adapter, random publicIds, ledger-gated delivery; noted, no change |

No P0 findings. No security regression was found in the redesign, the catalog work, or the media adapter; the adapter's security posture is verified in depth in §5.

---

## 2. F8-01 (P1) — /coupons and /reviews RSC crash: root cause and fix

**Reproduction (pre-fix):** with Supabase unconfigured — the sanctioned deployment shape, since coupons/reviews are Phase-8 domains (PLAN.md §22, D-5) with no API model — opening `/admin/coupons` or `/admin/reviews` produced a server-side render failure (`⨯ Error: Your project's URL and Key are required to create a Supabase client!`, digest `1375520748` in the server log) and the route crashed. Neither segment has an `error.tsx`, so there was no graceful surface at all.

**Root cause:** both pages are legacy Phase-8 pages that query Supabase directly via `getAdminServices()` (`apps/admin/src/lib/services.ts` → `src/lib/supabase.ts`). Client construction throws when the env is absent. The API has no coupons/reviews modules (module list verified: audit, auth, cart, catalog, fulfilment, inventory, media, notifications, orders, users), so rewriting the pages onto the API was not an available fix — and inventing a backend for a Phase-8 domain would violate D-5.

**Fix (commit `1d60811`):** in `apps/admin/src/app/(dashboard)/coupons/page.tsx` and `reviews/page.tsx`, the `getAdminServices()` acquisition is wrapped in try/catch. On failure the page renders its PageHeader, the pre-existing `DomainNotLiveNotice` (which already tells operators the truth about these domains), and the page's existing `ErrorState` pattern with an honest description: the legacy service is not configured in this deployment and the domain becomes available when it ships in Phase 8. No fake data, no fabricated rows; when Supabase *is* configured the pages render exactly as before.

**Verification:** rebuilt, restarted, both routes render the full shell + notice + error state with **zero browser console errors and zero server RSC errors**; screenshot evidence captured (`coupons-fixed.png`). The full admin route sweep (all routes, desktop/tablet/mobile) is clean.

---

## 3. F8-02 (P2) — N-1 confirmed and fixed

The pre-commit adversarial review at the end of Session 6 flagged N-1 as a LOW; this audit re-derived it independently and confirms it, at P2 because it sits on the payment-verification path:

**Defect:** `apps/api/src/modules/orders/application/payment-verification.service.ts` — `decide()` dereferenced `order.payment.method` unguarded twice before any null check: in the segregation-of-duties audit metadata (line 123) and in the manual-transfer gate (line 134). F-1 (Session 6) made payment honestly nullable, so a legacy/corrupt order with **no payment subdocument at all** is a representable state. Deciding such an order crashed with a 500: for the owner-admin, instead of the audited 403 the SoD policy promises; for any other admin, instead of a validation refusal. The decision itself was still refused and nothing mutated — the failure was a crash where the system's own contract promises an audited, attributable refusal.

**Fix (commit `3a1c6ce`):** the method is read once, null-safely (`(order.payment as { method?: PaymentMethod } | undefined)?.method`). The SoD audit metadata records `'UNKNOWN'` when absent; a missing method is not a manual transfer, so the request falls through to the existing validation refusal.

**Regression tests (2, in `apps/api/test/checkout/payment-adversarial.spec.ts`):** (1) a payment-less order (`$unset: { payment: 1 }`) decided by its owner-admin returns **403** and writes exactly one refused audit row with reason `SEGREGATION_OF_DUTIES` and `metadata.method === 'UNKNOWN'`; (2) the same order decided by a different admin returns **400**. Both pass in the full-suite run (§8).

---

## 4. F8-03 (P2) — catalog completeness: what was actually missing

The Session 7 catalog claim ("60 products, complete") was re-audited field-by-field against the live database with the *correct* schema (an early pass with wrong field names produced 402 phantom issues and was discarded — recorded here because it is exactly the kind of false evidence this audit exists to catch).

**Confirmed gaps, all in the pre-existing seed products and taxonomy, not in the 26 Session-7 products (which were complete):**
- All **34 seed products** lacked `name.ar`, `shortDescription.ar`, `description.ar`, and `seo` (null).
- **13 of 15 categories** and **7 of 9 brands** lacked Arabic names (the 2 categories and 2 brands Session 7 added had them).

**Fix:** faithful Arabic translations of the existing English content (no added claims; model numbers and technical terms kept in Latin script, matching the Session 7 pattern) plus English SEO title/description per product, applied through the real admin API (the same mechanism Session 7 used): products 34/34, categories 13/13, brands 7/7, zero failures. Category renames cascade to product snapshots through the API's own machinery.

**Why the fix lives in the catalog data and not in `catalog.seed-data.ts`:** the seed file's own header states it is *test infrastructure, not business data (D-6)*, deliberately awkward — products with no images, no reviews, missing fields — so rendering states stay reachable. Making the seed complete would fight its stated purpose. The owner's Session 7 brief was to complete the *catalog*; that is the populated database, and it is now complete by re-audit: **products=60, hard issues: none, categories/brands without Arabic: none, snapshots lacking Arabic: 0**.

**Images (re-verified, not trusted from Session 7):** all 60 source files are valid PNGs with **60 unique MD5 hashes, zero duplicates**; every product has exactly one image; delivery verification through the real pipeline reports 60/60 OK with 60 unique publicIds and every URL answering 200. Visual spot-checks this session (SG90 servo, UNI-T UT61E multimeter) are accurate to the product class; the multimeter's display shows an abstract bargraph rather than invented digits, which is the honest rendering.

**Import safety (code review of `apps/api/src/database/import/`):** SKU-upsert by design, never deletes, `--dry-run` supported, rows naming nonexistent taxonomy are skipped rather than auto-created, identical rows report `unchanged`, images insert-only. Verdict: sound. One defect found inside it is F8-05 (§6).

---

## 5. Mission C — the local media adapter, adversarially

Verdict: **the adapter's security design held up under live attack.** Evidence:

- **Path traversal:** `pathFor()` resolves and containment-checks against the media root; the delivery route's identifier regex requires at least one `/` and forbids dots entirely. Live probes (`..%2f`, `%2e%2e`, versioned and unversioned shapes, unknown ids, no-slash ids) all returned 404.
- **Ledger-gated delivery:** bytes on disk are *not* sufficient — an orphan file planted on disk with no ledger row returns 404, proven live. Delivery authorisation is the ledger, not the filesystem.
- **Production refusal, proven at runtime:** booting with `NODE_ENV=production` + `MEDIA_PROVIDER=local` fails config validation with the intended message; `memory` is refused the same way. The provider switch is explicit (cloudinary/local/memory arms) with **no silent fallback** to local.
- **Upload path (pre-existing pipeline, re-read):** `@Roles(ADMIN, SUPER_ADMIN)` runs before the file interceptor; 5 MB multer limit plus a service-level re-check; MIME allow-list plus magic-byte sniffing plus a sharp decode/re-encode (which strips EXIF and caps dimensions). The local adapter only ever receives already-processed bytes.
- **Frontend exposure is config-scoped:** `dangerouslyAllowLocalIP` and the CSP `img-src`/remotePatterns widenings exist only when the local-media configuration is present; unset, the production policy is byte-identical to before Session 7.

**F8-07 (P3, hygiene):** 84 orphan files totalling 104.3 MB sit in the local media directory with no ledger row (residue of earlier demo-database incarnations). They are **not servable** (ledger gate, above) and not a security issue; they are unbounded disk growth in a dev environment. No prune/reconciliation tooling exists for files, though the adapter's `list()` makes one possible. Recommendation: a report-only reconciliation command first (list orphans, delete nothing), run before any destructive prune is even proposed. Not implemented in this session: it is new tooling, and the mission's fix priority puts it behind the confirmed defects, all of which are done.

**F8-06 (P3, fixed, commit `a6e4939`):** the delivery route threw `NotFoundException` for every refusal, handing the response to the global exception filter whose helmet defaults stamp `Cross-Origin-Resource-Policy: same-origin`. A missing image therefore presented in the browser as a CORP block *against this route* — the console blamed the route's security posture for a missing asset. The route now answers refusals through the response object: **404, CORP `cross-origin`, `Cache-Control: no-store`**, asserted in the delivery spec on every refusal path and verified live with curl.

**F8-10 (INFO):** the intermittent first-cold-run image failures seen in Session 7 and once here are explained by F8-06's mechanism acting on transient cold-start errors: any error response from the route wore the wrong CORP posture and surfaced as a block. With warm servers, three consecutive full browser verifications are 100% clean, and a dedicated cold probe (cleared optimizer cache, fresh API, fresh browser profile) recorded 17/17 delivery responses at 200 with the correct header.

**F8-12 (INFO):** `LocalMediaStorage` checks existence then writes non-atomically; with random publicIds and a dev-only adapter the collision window is theoretical. Noted for the production-media future; no change.

---

## 6. F8-05 (P3) — the import runner stripped Arabic from snapshots

Found by following F8-03's snapshot gaps to their mechanism: `apps/api/src/database/import/import-runner.ts` built the category snapshot as `name: { en: input.category.name, ar: null }` (and identically for brand), because its taxonomy index flattened each name to the English string. The API's own snapshot builders (`product-admin.service.ts`, `category-admin.service.ts`) copy `name.ar` faithfully. So every import run silently stripped Arabic from the snapshots of the products it touched — visible in exactly the 7 products living in the two Session-7 categories.

**Fix (commit `9f9d47b`):** the category/brand refs now carry `nameAr` through the index, and both snapshot constructions copy it. A regression test in `catalogue-import.spec.ts` asserts the copy-through against the taxonomy rows themselves (so it pins the mechanism whatever the seed names are), and a fixture in `import-image-version.spec.ts` was updated for the widened ref type. Proof beyond the unit test: after the fix, a from-scratch demo rebuild (seed → import → enrich → attach) audits at **issues=0 with no snapshot repair step needed** — in the previous rebuild the same 7 gaps appeared and had to be cascaded away.

---

## 7. Mission A — the redesign under audit

- **Design system:** brand tokens verified in `globals.css` (navy `#1a1a2e`, crimson primary, background `#f4f5f7`); Albert Sans + Urbanist loaded in the layout; the redesign is genuinely token-level — routes inherit it, no per-page re-skin. Two Concept-03 remnants survived and are fixed (F8-08 global-error cream, F8-09 table-header cream `#f3f3ed`).
- **Routes:** the full sweep — dashboard, products (+new, [id]/edit), categories, brands, inventory, orders (+[id]), coupons, reviews, customers, audit-log, settings, login, unauthorized — returns 200 on desktop, tablet and mobile viewports with zero console errors, coupons/reviews included after F8-01.
- **Functionality exercised, not just rendered:** product editing was driven 34 times through the real admin API during the F8-03 fix (PATCH round-trips with snapshot cascades); the orders UI renders the seeded wallet/COD orders; order detail renders; the payment-review queue filter from Session 6 still behaves.
- **Accessibility (F8-04, P2, fixed, commit `4d229ff`):** axe (full ruleset) found **serious** color-contrast violations on every admin page. Measured root causes, all token-level: `--color-muted-foreground #6b7280` at 4.41–4.43:1 on the light surfaces and 3.52:1 inside the navy sidebar; status hues used as text on their own tints (success `#16a34a` 2.95:1, danger `#dc2626` 4.12:1, warning `#b45309` 4.41:1); crimson text on its own tint at 4.26–4.29:1 in tabs, pills and pressed filter chips across five components. Fixes: muted-foreground → `#5f6873` (5.16:1) with a sidebar-scoped light slate `#9aa5b5` (6.84:1 on navy; portalled dropdowns unaffected); status hues → their 700/800 shades (6.40 / 5.51 / 6.23:1, white-on-solid still passing); admin `--color-primary` deepened one shade to `#c43047` (4.71:1 on tint, 5.44:1 on white and under white text) and a new `--color-primary-ink #a52338` (5.72:1) for the text-on-tint pattern in the five components; pressed metric-filter chips take the ink via the existing CSS rule. The storefront's last finding (category-tile `image-redundant-alt`, minor) is fixed by marking the tile decorative (`alt=""`) inside its named link. **Final axe state: zero violations on storefront home, products, detail, and admin dashboard, products, orders.**
- **Blog / ADV-3 (Mission D remainder):** the storefront `/blog` is in the same Phase-8 family as coupons/reviews — its own file header documents it as *not migrated*, still reading Supabase, with five known-broken images, and it returns 500 when Supabase is unconfigured. The four options already on record stand (configure Supabase for it, hide the link, fail soft like F8-01, or migrate the blog as a Phase-8 feature). This audit's recommendation is *fail soft* for symmetry with F8-01 **if** the blog stays linked from the storefront chrome; but which of the four is a product decision, and per the mission boundary it is **not** taken here. Release impact is assessed in the readiness report.

---

## 8. Regression evidence (summary)

Full detail in `MUSE_TEST_EVIDENCE.md`. Headlines:

- **Jest (full API suite): 76/77 suites, 1505/1520 tests, 0 failures** — the delta over Session 7 (1503/1518) is exactly the 2 new N-1 tests. The skipped suite is the Cloudinary integration suite, skipped by design (no account, D-4). Teardown residue: exactly 4 audit rows, the established baseline.
- Targeted re-runs after later fixes: import suites 70/70 (incl. the new B-3 test), media delivery spec 6/6 (incl. the new honest-404 assertions).
- Type-checks: API, admin, storefront — clean. Builds: API, admin, storefront — clean (all with `NODE_ENV=production`; see the environment note in the evidence doc). Lint: API clean, admin clean (32 pre-existing warnings, none in touched files), storefront blocked by F8-11's pre-existing config error. OpenAPI: both gates pass (74 paths).
- Browser: full route sweep clean at three viewports; end-to-end smoke (home, grids, search `?q=esp32`, category filter, sort, detail, admin products + edit) 100% clean on the final build, three consecutive runs.

## 9. Commits added by this audit

| Commit | Fix |
|---|---|
| `3a1c6ce` | fix(api): payment verification is null-safe for orders without payment data (N-1) |
| `9f9d47b` | fix(api): catalogue import copies Arabic taxonomy names into snapshots (B-3) |
| `a6e4939` | fix(api): media delivery 404s keep the route's cross-origin posture |
| `1d60811` | fix(admin): Phase-8 pages degrade gracefully when the legacy service is unconfigured |
| `4d229ff` | fix(a11y): WCAG AA contrast pass for the admin console |

Plus the docs commit carrying this session's five deliverables. Nothing pushed, merged, or deployed.

## 10. What this audit did not do

- No production or shared data touched; all work ran against the local demo database and local media directory. No catalog prices or inventory were changed; the only data writes were the F8-03 content completions through the admin API.
- No coupons/reviews/blog backend was invented (D-5); no Cloudinary work was attempted (the account is an owner deliverable, D-4).
- `pnpm audit` still cannot run in the sandbox (proxy), and Playwright is still not in CI — both carried over as known gaps, unchanged by anything Session 7 shipped.
