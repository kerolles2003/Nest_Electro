# Nest Electro — P1 Remediation Report

Date: 2026-10-08, Africa/Cairo. Scope: CR-01, CR-02 and CR-03 from P1_CLOSURE_REVIEW.md only.

## Executive Summary

**P1 CONDITIONALLY CLOSED — RUNTIME CERTIFICATION DEFERRED.**

| Finding | Implementation result | Evidence boundary |
|---|---|---|
| CR-01 / P1.4 — importer bypasses arrangement versioning | FIXED | Shared authoritative CAS, nine focused importer regressions; real Mongo transactions remain uncertified here. |
| CR-02 / P1.6 — conditional taxonomy deletion emits false success | FIXED | Both brand/category reject zero-match writes; eight focused regressions; model state and audit calls checked. |
| CR-03 / P1.1 — missing planned CSP | FIXED | Enforced nonce policy in both apps, eight policy/proxy/browser cases and seven fresh production Next runtime cases. |

The decision follows source-path review and regression evidence, not a test-count-only inference. All three reviewed implementation gaps are addressed. This is not production approval, Mongo certification, provider certification, migration authorization or permission to start P2.

The six required documents were reviewed in this continuing session: MASTER_IMPLEMENTATION_PLAN.md, AUDIT.md, P1_COMPLETION_REPORT.md, P1_CLOSURE_REVIEW.md, OWNER_DECISIONS_2026-10-07.md and G_ENTRY_SCOPE_REBASELINE_REPORT.md. Full prior reads were retained; SHA-256 comparison confirmed the master plan, audit, owner decisions and scope report unchanged since those reads. The completion/closure history includes the immediately preceding review and its appended evidence. Historical reports are not silently rewritten as successful execution.

Evidence: [C] source, [T] executed automated tests, [V] local browser/runtime observation, [D] historical evidence. No live business database or provider evidence is claimed.

## Defect 1 — Image Importer

**Previous finding:** CR-01. ImportRunner took a product/images snapshot, uploaded asynchronously, then unconditionally set `images` by `_id`. A newer admin arrangement could be overwritten without changing `imageVersion`.

**Confirmed path:** `apps/api/src/database/import/import-runner.ts`, existing-row upsert → importImages → product write → retainAll. Both normal and bulk catalogue imports use this runner. `ProductImageService` already guarded admin attach/detach/reorder with a versioned whole-array write. No replacement architecture was needed.

**Fix [C]:**

- Extract that same compare-and-swap into `apps/api/src/modules/catalog/application/write-product-images.ts:6`. Admin writes delegate to it; importer writes call it inside their existing transaction.
- Existing-row upsert forwards its observed `imageVersion` (missing legacy value means zero), captured before upload. Creation retains version zero semantics.
- Predicate checks product ID, undeleted state and expected version; a successful mutation sets the whole array and increments `imageVersion` once. Missing/changed/deleted records and invalid versions return the existing concurrent-modification exception.
- `import-runner.ts:428` retains references only after the guarded write, in the same existing transaction. Failed CAS never reaches retainAll. Failed retain rolls the write/version back through that transaction boundary.
- Import failure still retains uploaded bytes for explicit fenced cleanup. No destructive provider rollback was added. Corrected outdated comments that had described physical destruction despite the existing retain-for-cleanup implementation.
- Narrowed ImageImporter's returned array annotation from `unknown[]` to `object[]`, matching its actual descriptors. No external/public API contract or dependency changed.

**Tests [T]:** `apps/api/test/p1/import-image-version.spec.ts`, nine tests:

1. Row upsert forwards a nonzero observed version.
2. Version zero advances on success.
3. Nonzero version advances on success.
4. Missing legacy version is treated as zero.
5. Normal reorder during upload wins; stale importer neither writes nor retains.
6. A newer populated arrangement survives the stale upload.
7. Successful import makes an older normal reorder stale.
8. Two concurrent imports cannot both commit the same version.
9. Retain failure restores the previous descriptors/version in the transaction fixture.

The tests call the actual ImportRunner, ProductImageService and shared writer with injected database/provider fakes. Upload barriers create a real asynchronous interleaving; the transaction fixture serializes transactions and restores model state on failure. This proves the application protocol, not Mongo snapshot/write-conflict/retry semantics. No catalogue CLI, import of real content, database or Cloudinary operation ran.

## Defect 2 — Taxonomy Deletion

**Previous finding:** CR-02. Brand/category deletion used `(await conditionalUpdate) ?? current`, then recorded success. A concurrent loser could return the undeleted snapshot and emit a successful deletion event.

**Fix [C]:**

- `brand-admin.service.ts:244` and `category-admin.service.ts:316` explicitly reject a null conditional result with the existing `AppException.concurrentModification()` / HTTP 409 convention.
- This occurs before product unbranding, cache invalidation, success audit and return. An already-deleted entity still uses the existing deleted-domain error; missing entities retain the existing not-found behavior.
- Existing controller delegation/response serialization is preserved: a rejected service promise is handled by the existing exception boundary, not serialized as a deleted entity.
- Existing durable pre-mutation intent remains distinct from completion. A rejected attempt can retain its requested intent; it does not emit BRAND_DELETED/CATEGORY_DELETED success. No new transaction or generic audit system was introduced.

**Tests [T]:** `apps/api/test/p1/taxonomy-delete-outcome.spec.ts`, four cases each for brand and category (eight total): valid matched deletion returns the actual changed state; zero-match conflict has no success audit or downstream effects; concurrent calls yield one successful deletion/audit; repeated deletion preserves the original timestamp/evidence and fails.

The fixture stores changed state and checks the returned state and audit calls, including the existing 409 error. It does not pretend to persist a Mongo audit record. Broader taxonomy fan-out consistency/parent constraints were not rewritten under this narrowly authorized false-success correction.

## Defect 3 — Content Security Policy

**Previous finding:** CR-03. The master plan explicitly required a compatible CSP; no application policy/nonce mechanism existed. Existing content sanitizer and script-safe JSON serialization were preserved.

### Inspected dependencies and selected policy

[C] Read both next.config.ts files, proxies, layouts, route handlers, JSON-LD sinks, browser/API clients, shared UI and script/style/font/image usage. Read installed Next 16.2.4 documentation at `apps/storefront/node_modules/next/dist/docs/01-app/02-guides/content-security-policy.md`, including dynamic rendering and development-only evaluation requirements. Applied the Next.js best-practices skill. No new package was installed.

| Dependency | Policy consequence |
|---|---|
| Next App Router scripts/RSC/client components | Fresh request nonce, forwarded CSP for Next's own nonce extraction; script-src includes nonce and strict-dynamic. |
| Product/blog JSON-LD | All four existing script elements receive the trusted request nonce and still use serializeJsonLd. |
| Existing React inline style props and UI positioning; Next dev styles | CSS-only `style-src 'self' 'unsafe-inline'` exception retained deliberately. No inline executable-script exception. |
| Next/font and locally served admin fonts | `font-src 'self'`; no Google browser-script/font origin added. Runtime test uses Next's font test hook with local Arial, not a Google call. |
| Same-origin Server Actions and route handlers; server-only Nest clients | `connect-src 'self'` in production. No browser permission to Nest, Supabase, email, payments or Cloudinary APIs. |
| Existing image sources and local previews | Exact HTTPS image hosts: res.cloudinary.com, images.unsplash.com, ampere-electronics.com, placehold.co, quhllllvwwuizjfrxvdz.supabase.co; self/data/blob previews. No wildcard host or scheme-wide HTTPS allowance. |
| Development React diagnostics/HMR | unsafe-eval and the exact request-origin WebSocket source only when NODE_ENV is development. Neither appears in production policy. |
| No active frame/embedded-object integration | frame-src/object-src/frame-ancestors none; base-uri/form-action self; script-src-attr none. |

The legacy Supabase image hostname is a narrowly permitted existing image source, not a commerce authority, API connection or new launch dependency. No Supabase code was removed or changed. Analytics/gateway/WhatsApp scripts were not added.

### Implementation

- `packages/config/src/content-security-policy.ts` owns one policy builder and request-header helper used by both proxies. Nonces are generated server-side for every request. Client-supplied nonce/CSP/report-only headers are replaced/removed before rendering; policy construction validates nonce characters. Production policy does not interpolate a request origin.
- Each proxy wraps its existing navigation guard, forwarding trusted nonce/CSP headers on pass-through (including Server Actions), and setting exactly one enforced response CSP on every branch, including redirects. Admin PATH_HEADER behavior is retained.
- Matchers cover public and protected page routes, including unknown/dotted page paths. `/api`, Next static/image responses and favicon are excluded. Admin's check-slug handler still enforces requireAdminActor independently. Nest API response policy was not changed.
- Admin root layout awaits `connection()` so its shell cannot be prerendered with nonce-less scripts. Storefront already uses a dynamic session-aware root. No Next experimental SRI, new rendering framework, report collector, dependency or provider integration was introduced.
- Config-generated legacy redirects and excluded static/API responses are not claimed as HTML document CSP coverage. Inherited sanitized HTML/JSON-LD protections remain essential; CSP is defense in depth.

### Security verification

[T] Eight cases in `apps/storefront/scripts/test-csp.cjs`: production directives/exact hosts; development-only evaluation/HMR; invalid nonce rejection; both actual proxy matchers using the installed Next testing utility; both proxies' response branches and fresh trusted request nonces; Chromium-enforced nonce/inline-handler/CSS/JSON-LD fixture.

[V/T] Seven actual production Next runtime cases, detailed below, verify that the header is not a test-only mock. Both fresh application builds include the actual proxy/layout/page changes.

## Tests — Exact Commands and Results

Commands ran on 2026-10-08. Working directory is listed; all final commands below exited 0.

| Directory | Command | Result |
|---|---|---|
| apps/api | `node node_modules/jest/bin/jest.js --config jest.p1.config.js --runInBand --no-cache` | **73/73**, nine suites. Existing 56 plus nine importer and eight taxonomy regressions. Final run 59.321 seconds. |
| apps/api | `node node_modules/jest/bin/jest.js --config jest.p0.config.js --runInBand --no-cache` | **50/50**, two suites; ownership/provider isolation safeguards preserved. |
| apps/storefront | `node scripts/test-content-safety.cjs` | **7/7** existing Chromium content helper cases; network aborted. |
| apps/storefront | `node scripts/test-csp.cjs` | **8/8** policy/proxy/Chromium cases. |
| apps/storefront | `node scripts/test-csp-runtime.cjs` | **7/7** production Next runtime cases; two clean copied-source builds via `next build --webpack`, then loopback `next start`. |
| apps/api | `node node_modules/typescript/bin/tsc --noEmit --incremental false` | PASS, including final added tests. |
| apps/admin | `node node_modules/typescript/bin/tsc --noEmit --incremental false` | PASS. |
| apps/storefront | `node node_modules/typescript/bin/tsc --noEmit --incremental false` | PASS. |
| apps/api | `node node_modules/@nestjs/cli/bin/nest.js build` | PASS; build only, no API bootstrap. |
| apps/api | `node node_modules/eslint/bin/eslint.js src/database/import/import-runner.ts src/database/import/image-importer.ts src/modules/catalog/application/write-product-images.ts src/modules/catalog/application/product-image.service.ts src/modules/catalog/application/brand-admin.service.ts src/modules/catalog/application/category-admin.service.ts test/p1/import-image-version.spec.ts test/p1/taxonomy-delete-outcome.spec.ts` | PASS, no warnings/errors. |
| apps/admin | `node node_modules/eslint/bin/eslint.js src/proxy.ts src/app/layout.tsx` | PASS. |
| apps/storefront | `node node_modules/eslint/bin/eslint.js src/proxy.ts "src/app/products/[slug]/page.tsx" "src/app/blog/[slug]/page.tsx"` | PASS; three existing unused-import warnings (Check/X/Heart), left untouched. |
| apps/storefront | `node --check scripts/test-csp.cjs` | PASS. |
| apps/storefront | `node --check scripts/test-csp-runtime.cjs` | PASS. |
| apps/storefront | `node --check scripts/csp-test-network.cjs` | PASS. |
| apps/storefront | `node --check scripts/csp-test-fonts.cjs` | PASS. |

Development iterations are not hidden: initial new-test typing failures (fixture attribution/types and import array annotation) were corrected; CSP harness initially required the installed Next test utility name/AsyncLocalStorage setup and a trimmed directive lookup; the isolated build fixture initially needed Windows NODE_OPTIONS slash normalization and a valid mocked @font-face. Browser selectors initially matched multiple submit/alert elements and were narrowed. The final complete runs above passed. No failing iteration is presented as certification.

## Browser Verification

The runtime harness copies actual app source/config and shared source into a UUID-owned directory under ignored `.next/`, links existing dependencies, excludes `.env` files, and supplies a minimal child environment. No package installation or workspace config rewrite. Both production builds are fresh, not assumed correct from an old cache. The compiler is explicitly webpack; this is not certification of a future deployment's compiler/hosting setup.

All API responses come from a newly bound loopback synthetic fixture. Next's supported font mock returns local font CSS. A test-only preload rejects non-loopback fetch/http/https requests; browser routing aborts external origins. No credentials, real database or external provider are supplied. Child servers are stopped in finally; owned build/log artifacts are retained, not destructively cleaned.

Successful artifacts: `apps/storefront/.next/csp-remediation-c37638fe-bc74-41a1-94f7-712b301a1d24/` (ignored). Logs include storefront/admin build and start output. Earlier failed harness-run artifacts are separate UUID directories and were not reused as passing builds.

Seven passing cases:

1. Storefront production login HTML: CSP present, every executable framework/page script has the matching nonce, React hydration and password-reveal interaction work; zero CSP violations/page errors.
2. Storefront real Server Action posts to synthetic API and displays a handled failure; CSP retained.
3. Storefront protected navigation redirects with CSP.
4. Storefront actual product page renders a synthetic script-breaking name; both JSON-LD nodes retain the correct nonce and round-trip the value as data; no injection or CSP violation.
5. Admin production login HTML: CSP/nonces, hydration and CSS work with zero CSP violations/page errors.
6. Admin real Server Action displays handled synthetic rejection and retains CSP.
7. Admin protected navigation redirects with CSP.

These tests do not log in a real user, certify complete commerce/admin journeys, exercise a payment/provider, or read a production record. The separate helper Chromium test verifies that un-nonced scripts and inline event handlers are blocked while nonce scripts and required CSS work.

## Runtime Certification Boundary

- NEST_TEST_MONGODB_URI was absent from this process (presence-only check; no value printed). No attempt was made to solve/provision it or bypass P0 ownership guards.
- Real Mongo transaction rollback, write-conflict retries, simultaneous service requests, reference ledger persistence and durable audit persistence require a separately available safe, run-owned transaction-capable Mongo environment. Model transaction fixtures are not that evidence.
- Required installed unique indexes/readiness/reconciliation/opening provenance remain existing P2 work, not modifications made here. Earlier P1 media safety still depends on its documented index prerequisite.
- Full API-backed customer/admin browser journeys, default deployment compiler/toolchain, real assets/fonts, approved production origins/ingress/CDN nonce/cache handling and actual provider behavior remain future production-like certification. CSP runtime evidence here covers the named pages/actions under synthetic local API/font conditions.
- Final production DB topology/transaction validation, recovery, migration rehearsal/cutover and production deployment remain separately authorized future work. Supabase and historical credential investigation remain excluded/deferred under the owner scope decision.

## Remaining P1 Risks

No remaining implementation gap among CR-01/02/03 was identified after remediation and diff review. Remaining limitations are the explicit runtime boundary above. CSS inline permission is a documented compatibility exception, not permission for inline JavaScript. New browser integrations/origins must be reviewed against this policy when separately authorized; broadening it speculatively would be inappropriate.

Nonces require dynamic HTML. The storefront was already dynamic; admin now explicitly opts in. Later hosting/caching certification must not cache HTML with a stale nonce or strip/duplicate the header. HTML sanitizer and script-safe JSON serialization remain in place.

## P2 Handoff — Not Started

Only the existing roadmap tasks: P2.1 index correctness; P2.2 fail-closed readiness; P2.3 reconciliation including zero-ledger/orphan cases; P2.4 owner-approved development opening-balance provenance. No index creation, ledger reconciliation, stock baseline, Mongo setup or data operation was performed.

## Files Authored by This Remediation

Modified implementation:

- apps/api/src/database/import/import-runner.ts
- apps/api/src/database/import/image-importer.ts
- apps/api/src/modules/catalog/application/product-image.service.ts
- apps/api/src/modules/catalog/application/brand-admin.service.ts
- apps/api/src/modules/catalog/application/category-admin.service.ts
- apps/admin/src/proxy.ts
- apps/admin/src/app/layout.tsx
- apps/storefront/src/proxy.ts
- apps/storefront/src/app/products/[slug]/page.tsx
- apps/storefront/src/app/blog/[slug]/page.tsx

New implementation/tests:

- apps/api/src/modules/catalog/application/write-product-images.ts
- apps/api/test/p1/import-image-version.spec.ts
- apps/api/test/p1/taxonomy-delete-outcome.spec.ts
- packages/config/src/content-security-policy.ts
- apps/storefront/scripts/test-csp.cjs
- apps/storefront/scripts/test-csp-runtime.cjs
- apps/storefront/scripts/csp-test-network.cjs
- apps/storefront/scripts/csp-test-fonts.cjs

Reports: this new P1_REMEDIATION_REPORT.md; append-only P1_COMPLETION_REPORT.md. P1_CLOSURE_REVIEW.md is retained as historical evidence.

## Safety and Final Validation

No architectural rewrite. D01 remains COD plus manual Wallet/InstaPay, WhatsApp evidence-only and authorized approval before paid status; no payment code changed. No database connection/migration/reset/index operation, provider configuration/call, credentials, Supabase action, infrastructure/DNS/deployment, dependency/lockfile change, staging, commit or push by this remediation.

The worktree was already dirty and shared with an independent dashboard audit. Its new ADMIN_DASHBOARD_* reports, admin-dashboard-audit artifacts and tsconfig activity are not this remediation's edits. No unrelated changes were reverted. Global Git diff includes prior P0/P1 and dashboard work and must not be attributed wholesale to this run. Ignored test build copies/API dist output are local verification artifacts, not deployment.

Final Git and hash evidence is appended below. P1 stops here; P2 or any later work requires separate authorization.

### Final repository snapshot — 2026-10-08T02:06:48.869339+03:00

- Branch: `phase-1-2-overnight`; HEAD unchanged: `de8a353808c74b3885c2700ab89d756176dcecc7`.
- All six final Git commands exited 0. `git diff --check`: no whitespace errors. `git diff --cached --stat`: empty, nothing staged.
- Global tracked stat: **107 files changed, 3166 insertions, 2954 deletions**. This includes previous/shared changes; untracked files are not included in that stat.
- This remediation authored **20 files**: ten modified implementation files, eight new implementation/test files, and two reports listed above. The completion report's original **46,001 bytes** were verified byte-identical after append. The master plan, audit, owner record, scope rebaseline and historical closure review match entry hashes.
- No tracked/nonignored dependency manifest, lockfile, environment or unrelated source change was authored by this run. SHA-256 entry/exit comparison separately observed independent `apps/admin/tsconfig.json` changes, new dashboard-audit artifacts/reports, and removal of the dashboard audit's `axe.min.js`; no such operation was issued by this remediation. There is no claim that the shared tree as a whole stayed static.
- Git emitted existing LF/CRLF and inaccessible global-ignore warnings; these did not prevent checks. Ignored UUID test-build artifacts are documented above and contain no copied environment files.

Observed independently changed/added/removed paths (outside this remediation's manifest):

- admin-dashboard-audit/evidence/states.json
- admin-dashboard-audit/report-data.cjs
- ADMIN_DASHBOARD_UX_FINDINGS.md
- ADMIN_DASHBOARD_ROUTE_MATRIX.md
- ADMIN_DASHBOARD_SECURITY_FINDINGS.md
- admin-dashboard-audit/states.cjs
- ADMIN_DASHBOARD_AUDIT_REPORT.md
- ADMIN_DASHBOARD_AUDIT_MAP.md
- ADMIN_DASHBOARD_SCORECARD.md
- admin-dashboard-audit/evidence/score.json
- admin-dashboard-audit/evidence/snapshot-drift.json
- ADMIN_DASHBOARD_TEST_RESULTS.md
- apps/admin/tsconfig.json
- admin-dashboard-audit/evidence/upload-server-errors.log
- admin-dashboard-audit/write-reports.cjs
- admin-dashboard-audit/evidence/after.patch
- admin-dashboard-audit/axe.min.js

Exact `git status --short` output at the snapshot:

```text
 M apps/admin/e2e/global-teardown.ts
 M apps/admin/e2e/origin.ts
 M apps/admin/playwright.shared.ts
 M apps/admin/src/actions/product-image.actions.ts
 M apps/admin/src/app/(dashboard)/audit-log/page.tsx
 M apps/admin/src/app/(dashboard)/brands/page.tsx
 M apps/admin/src/app/(dashboard)/categories/page.tsx
 M apps/admin/src/app/(dashboard)/coupons/page.tsx
 M apps/admin/src/app/(dashboard)/customers/page.tsx
 M apps/admin/src/app/(dashboard)/inventory/page.tsx
 M apps/admin/src/app/(dashboard)/layout.tsx
 M apps/admin/src/app/(dashboard)/loading.tsx
 M apps/admin/src/app/(dashboard)/orders/[id]/page.tsx
 M apps/admin/src/app/(dashboard)/orders/loading.tsx
 M apps/admin/src/app/(dashboard)/orders/page.tsx
 M apps/admin/src/app/(dashboard)/page.tsx
 M apps/admin/src/app/(dashboard)/products/[id]/edit/page.tsx
 M apps/admin/src/app/(dashboard)/products/loading.tsx
 M apps/admin/src/app/(dashboard)/products/new/page.tsx
 M apps/admin/src/app/(dashboard)/products/page.tsx
 M apps/admin/src/app/(dashboard)/reviews/page.tsx
 M apps/admin/src/app/(dashboard)/settings/page.tsx
 M apps/admin/src/app/global-error.tsx
 M apps/admin/src/app/globals.css
 M apps/admin/src/app/layout.tsx
 M apps/admin/src/app/login/form.tsx
 M apps/admin/src/app/login/page.tsx
 M apps/admin/src/app/not-found.tsx
 M apps/admin/src/app/template.tsx
 M apps/admin/src/app/unauthorized/page.tsx
 M apps/admin/src/components/audit-log/AuditLogTable.tsx
 M apps/admin/src/components/brands/BrandsManager.tsx
 M apps/admin/src/components/categories/CategoriesManager.tsx
 M apps/admin/src/components/coupons/CouponsTable.tsx
 M apps/admin/src/components/customers/CustomersTable.tsx
 M apps/admin/src/components/inventory/InventoryAdjustDialog.tsx
 M apps/admin/src/components/inventory/InventoryHistoryDrawer.tsx
 M apps/admin/src/components/inventory/InventoryTable.tsx
 M apps/admin/src/components/layout/AdminHeader.tsx
 M apps/admin/src/components/layout/Sidebar.tsx
 M apps/admin/src/components/orders/OrderDetail.tsx
 M apps/admin/src/components/orders/OrdersTable.tsx
 M apps/admin/src/components/orders/QueueFilters.tsx
 M apps/admin/src/components/products/ProductForm.tsx
 M apps/admin/src/components/products/ProductImageManager.tsx
 M apps/admin/src/components/products/ProductSpecsEditor.tsx
 M apps/admin/src/components/products/ProductTable.tsx
 M apps/admin/src/components/reviews/ReviewsTable.tsx
 M apps/admin/src/components/settings/ShippingRatesTable.tsx
 M apps/admin/src/components/system/DomainNotLiveNotice.tsx
 M apps/admin/src/lib/api/endpoints.ts
 M apps/admin/src/lib/api/types.ts
 M apps/admin/src/proxy.ts
 M apps/api/scripts/cloudinary-tests.js
 M apps/api/src/database/import/image-importer.ts
 M apps/api/src/database/import/import-runner.ts
 M apps/api/src/database/testing/scratch-database.cli.ts
 M apps/api/src/database/testing/scratch-database.ts
 M apps/api/src/database/testing/scratch-databases.ts
 M apps/api/src/modules/audit/application/audit.service.ts
 M apps/api/src/modules/audit/domain/audit-action.ts
 M apps/api/src/modules/audit/domain/audit-diff.ts
 M apps/api/src/modules/catalog/application/brand-admin.service.ts
 M apps/api/src/modules/catalog/application/category-admin.service.ts
 M apps/api/src/modules/catalog/application/product-admin.service.ts
 M apps/api/src/modules/catalog/application/product-image.service.ts
 M apps/api/src/modules/catalog/application/slug-redirect.service.ts
 M apps/api/src/modules/catalog/infrastructure/schemas/product.schema.ts
 M apps/api/src/modules/catalog/presentation/admin-products.controller.ts
 M apps/api/src/modules/catalog/presentation/dto/admin-product-image.dto.ts
 M apps/api/src/modules/catalog/presentation/dto/admin-product-response.dto.ts
 M apps/api/src/modules/fulfilment/application/shipping-rates-admin.service.ts
 M apps/api/src/modules/inventory/application/inventory-admin.service.ts
 M apps/api/src/modules/media/application/media.service.ts
 M apps/api/src/modules/media/infrastructure/repositories/media-asset.repository.ts
 M apps/api/src/modules/media/infrastructure/schemas/media-asset.schema.ts
 M apps/api/src/modules/media/media.module.ts
 M apps/api/src/modules/media/presentation/dto/media-response.dto.ts
 M apps/api/src/modules/media/presentation/media.controller.ts
 M apps/api/src/modules/orders/application/order-lifecycle.service.ts
 M apps/api/src/modules/users/application/customers-admin.service.ts
 M apps/api/src/modules/users/infrastructure/schemas/user.schema.ts
 M apps/api/test/audit/admin-order-audit.spec.ts
 M apps/api/test/catalog/admin-product-create.spec.ts
 M apps/api/test/catalog/admin-product-delete.spec.ts
 M apps/api/test/catalog/admin-product-update.spec.ts
 M apps/api/test/catalog/admin-taxonomy.spec.ts
 M apps/api/test/catalog/product-images.spec.ts
 M apps/api/test/database/scratch-databases.spec.ts
 M apps/api/test/import/image-import.spec.ts
 M apps/api/test/infrastructure/index-health.spec.ts
 M apps/api/test/media/cloudinary-integration.spec.ts
 M apps/api/test/media/media-upload.spec.ts
 M apps/api/test/setup/email-isolation.spec.ts
 M apps/api/test/setup/email-isolation.ts
 M apps/api/test/setup/prepare-scratch-database.ts
 M apps/api/test/setup/scratch-database.ts
 M apps/api/test/users/admin-customers.spec.ts
 M apps/storefront/e2e/global-teardown.ts
 M apps/storefront/e2e/origin.ts
 M apps/storefront/playwright.config.ts
 M apps/storefront/src/app/blog/[slug]/page.tsx
 M apps/storefront/src/app/products/[slug]/page.tsx
 M apps/storefront/src/components/blog/BlogContent.tsx
 M apps/storefront/src/proxy.ts
 M docs/api/index.html
 M docs/api/openapi.v1.json
?? ADMIN_DASHBOARD_AUDIT_MAP.md
?? ADMIN_DASHBOARD_AUDIT_REPORT.md
?? ADMIN_DASHBOARD_ROUTE_MATRIX.md
?? ADMIN_DASHBOARD_SCORECARD.md
?? ADMIN_DASHBOARD_SECURITY_FINDINGS.md
?? ADMIN_DASHBOARD_TEST_RESULTS.md
?? ADMIN_DASHBOARD_UX_FINDINGS.md
?? AUDIT.md
?? CODEBASE_MAP.md
?? G_ENTRY_OWNER_ACTIONS.md
?? G_ENTRY_SCOPE_DECISION_2026-10-07.md
?? G_ENTRY_SCOPE_REBASELINE_REPORT.md
?? G_ENTRY_UNBLOCK_REPORT.md
?? MASTER_IMPLEMENTATION_PLAN.md
?? OA01_COMPLETION_REPORT.md
?? OWNER_DECISIONS_2026-10-07.md
?? P0_COMPLETION_REPORT.md
?? P1_CLOSURE_REVIEW.md
?? P1_COMPLETION_REPORT.md
?? P1_REMEDIATION_REPORT.md
?? admin-dashboard-audit/
?? admin-redesign-exploration/
?? apps/admin/src/app/(dashboard)/error.tsx
?? apps/admin/src/components/ui/
?? apps/api/jest.p0.config.js
?? apps/api/jest.p1.config.js
?? apps/api/scripts/sync-p1-openapi.cjs
?? apps/api/src/database/testing/scratch-run.ts
?? apps/api/src/database/testing/test-providers.ts
?? apps/api/src/modules/catalog/application/write-product-images.ts
?? apps/api/test/database/scratch-run.spec.ts
?? apps/api/test/p1/
?? apps/storefront/scripts/
?? apps/storefront/src/lib/safe-content.ts
?? docs/P0_DECISIONS.md
?? docs/admin-redesign/
?? packages/config/src/content-security-policy.ts
```

**STOP: P1 remediation complete; runtime certification deferred. P2 not started.**

