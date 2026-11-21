# Admin dashboard test results

## Evidence boundaries

- **Real application:** the unchanged Next frontend was built and exercised in Chromium. Its backend reads were replaced only through process environment variables with an isolated loopback fixture; application source was not replaced.
- **Real integration:** the unchanged Playwright/API startup was attempted on a disposable loopback Mongo replica set. It failed during Nest dependency resolution before tests ran (A01). Successful persisted CRUD, real role enforcement, real refresh rotation, IDOR, and multi-admin Mongo transactions are **NOT VERIFIED**.
- **Action/service probes:** execute unchanged action modules or the freshly compiled ProductAdminService with explicit in-memory dependency doubles. They prove branching and write ordering, not deployed database behavior.
- **Security:** static enforcement review and safe routing tests only. No destructive DoS/RCE payload, production account, real upload provider, real Supabase write, or external customer data was used. Scanner findings were reviewed for applicability, not treated as successful exploitation.
- **Performance:** production Next build, local fixture data, Chromium, small ordinary datasets plus a separate 1,000-record taxonomy probe. These are measurements, not production SLOs or a Lighthouse score.
- **Accessibility:** axe 4.11.3 on 16 rendered page states plus keyboard/dialog probes and conditional-control inspection. Full screen-reader/browser coverage is **NOT VERIFIED**.
- The scores are conservative engineering judgments based on this evidence. They are not pass percentages. Unverified business workflows lower assurance even where source protections look sound.

## Executed checks

| Check | Result | Evidence / limits |
|---|---|---|
| Admin TypeScript | PASS | [typecheck.log](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/typecheck.log>) (empty log, exit 0) |
| Admin ESLint | PASS with 32 warnings, 0 errors | [lint.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/lint.json>); warnings not suppressed |
| Fresh production Next build | PASS | [build.log](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/build.log>) |
| Existing real Playwright suite | BLOCKED before test execution | [real-e2e.log](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/real-e2e.log>); A01; no claimed passing integration tests |
| Existing isolated backend unit suites | 37/37 PASS across 4 suites | [unit.log](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/unit.log>); custom audit config omits DB global setup only for these non-DB suites |
| Route responsive sweep | 153 checks: 16 pages + not-found × 9 widths | [browser.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/browser.json>); 320/375/390/414/768/1024/1280/1440/1920; zero document overflow, zero default visible unlabeled fields |
| Dialog and interaction rerun | 48 PASS | [dialog-results.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/dialog-results.json>); fixture-backed |
| Axe 4.11.3 | 16 page states, one contrast violation | [supplemental.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/supplemental.json>); conditional unnamed button additionally found |
| Empty/service-error states | 22 route-state checks at 320px | [states.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/states.json>); presentation-only |
| Fault/auth/navigation suite | 24 scenarios completed | [adversarial.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/adversarial.json>); failures recorded as findings, not reported as passes |
| Mutation/race/context suite | 5 scenarios completed | [advanced.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/advanced.json>); one confirm POST on double click; two refresh POSTs on concurrent renewal |
| Action normalization/zero-row probes | 17 probes | [action-probes.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/action-probes.json>); in-memory dependencies |
| Compiled product-service probes | 2 deterministic defects reproduced | [service-probes.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/service-probes.json>); repository doubles, not real Mongo concurrency |
| Large taxonomy | 1,000 long-name records per screen | [large.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/large.json>); ~20k DOM nodes, no document overflow |
| Dependency audit | Nonzero vulnerability result | [dependency-audit.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/dependency-audit.json>); see applicability triage |

## Performance measurements

| Route | Mode | Network idle ms | JS transfer bytes | Decoded JS bytes | DOM nodes |
|---|---|---:|---:|---:|---:|
| /admin | Local, CPU 1× | 1640 | 206571 | 683979 | 530 |
| /admin/products | Local, CPU 1× | 789 | 218518 | 719529 | 514 |
| /admin/products/new | Local, CPU 1× | 685 | 223758 | 736974 | 373 |
| /admin | 150 ms / 200 KB/s / CPU 4× | 3996 | 206571 | 683979 | 530 |
| /admin/products | 150 ms / 200 KB/s / CPU 4× | 3913 | 218518 | 719529 | 514 |
| /admin/products/new | 150 ms / 200 KB/s / CPU 4× | 3361 | 223758 | 736974 | 373 |

Production build on port 3413, cache disabled for each measured navigation. Backend is local fixtures. Network idle includes Playwright’s idle waiting period and is not LCP/INP. Transfer includes per-resource overhead. No Lighthouse score, field Core Web Vitals, memory-leak endurance, or real API latency percentile is claimed.

The normal dashboard request log contained one /auth/me request plus dashboard stats, order stats, recent orders and audit activity. This disproved the suspected duplicate identity call on that render: no duplicate was observed. Product listing makes separate published/draft/deleted count requests; coupons make five sequential legacy requests and reviews six. Counts from a truncated legacy used_count query can become incomplete at service row limits; real volume behavior is NOT VERIFIED.

## Failure matrix

| Scenario | Observation |
|---|---|
| Products GET 400 / 422 | Visible validation/error state |
| Products GET 401 / 403 | Session/permission message with retry; no false success |
| Products GET 404 / 409 | Error shown, but order-specific copy (A22) |
| Products GET 429 | Wait-and-retry message |
| Products GET 500 / disconnect | Error state; generic “Nothing was changed” is unsafe for mutations (A06) |
| HTTP 200 invalid JSON | Route boundary (A12) |
| /auth/me 429 | Unnecessary refresh and login navigation (A13) |
| /auth/me 500 + legacy coupon data | Protected legacy read continues (A04) |
| Slow response, 5 seconds | Page eventually renders; no app deadline (A16) |
| Category POST 409 | Dialog and hostile/Unicode text preserved, no success; incorrect order copy |
| Order confirm double click | One fixture POST; explicit refusal preserved |
| 1.9 MB valid PNG | 500 / whole editor error boundary (A03) |
| Expired identity | Loop guard terminates; renewal drops query (A15) |
| Concurrent renewals | Two refresh POSTs (A14); real token revocation NOT VERIFIED |

Every real browser defect identified above is represented in the findings. Expected 404 for the deliberately nonexistent page and controlled injected errors are not independent defects. The slug 404 is a real application defect. Initial harness selector/timing errors were corrected and the relevant scripts rerun; they are not application findings.

## Coverage gaps and unavailable workflows

- **NOT VERIFIED:** successful persistent product/category/brand create/update/delete/restore/publish; inventory adjustments; shipping updates; all six real order transitions; coupon/review database mutations; refresh/reload data equivalence. A01 blocks Nest integration, and no real Supabase writes were authorized or used.
- **NOT VERIFIED:** real unauthenticated/customer/admin/super-admin API permission matrix; forged JWTs; revoked tokenVersion; arbitrary IDs; last-super-admin protections; actual multi-admin races and idempotency. Source guards and isolated unit tests provide partial evidence only.
- **NOT VERIFIED:** backend responses to every hostile string, minimum/maximum numeric boundary, duplicate, nonexistent/malformed ID, and malformed multipart variant. The normalization probes cover a subset explicitly shown in JSON.
- **NOT VERIFIED:** browser offline during an in-flight successful mutation, indefinite timeout, response lost after real commit, reload during a real write, rollback, final-page deletion, large order/product datasets, memory endurance, mobile Safari/Firefox, assistive technology sessions.
- JavaScript-disabled product form structure was inspected; completing a mutation without hydration was not attempted. It uses a client submit handler and has no equivalent native action. Root global-error was source-reviewed, not forced.
- Existing browser specs concentrate on auth, identity, renewal, hydration and orders. No dedicated real browser specs were found for taxonomy CRUD, product/image lifecycle, inventory, shipping, coupons/reviews, nine-width responsive states or draft loss. API domain specs exist but their presence is not a passing run.

## Reproduction

From the repository root, start `node admin-dashboard-audit/fixture.cjs` (loopback 3411). Start the admin from apps/admin with process-only values:

```powershell
$env:API_BASE_URL='http://127.0.0.1:3411/api/v1'
$env:NEXT_PUBLIC_SUPABASE_URL='http://127.0.0.1:3411'
$env:NEXT_PUBLIC_SUPABASE_ANON_KEY='local-visual-fixture'
$env:NEXT_DIST_DIR='.next-editorial-qa'
$env:DEV_ORIGIN_HOST='127.0.0.1'
node node_modules/next/dist/bin/next dev --hostname 127.0.0.1 --port 3410
```

Run browser.cjs, adversarial.cjs, supplemental.cjs, dialogs.cjs, advanced.cjs, large.cjs and states.cjs from the audit directory path, **sequentially**: they share fault state. Example: `node admin-dashboard-audit/adversarial.cjs`. The fixture wraps the existing docs/admin-redesign/qa-service.cjs; all tokens/data are fake. It has no database connection. Do not point these scripts at production.

Run `node admin-dashboard-audit/action-probes.cjs`; `node admin-dashboard-audit/service-probes.cjs` (requires the current API build); and `node apps/api/node_modules/jest/bin/jest.js --config admin-dashboard-audit/unit.config.cjs --runInBand`.

Production measurement: build with NEXT_DIST_DIR=.next-audit-build and the same fixture environment, then `next start --hostname 127.0.0.1 --port 3413`; run performance.cjs. Stop the servers afterward. Next can add output-directory includes to tsconfig; those generated changes must be restored without changing existing entries.

Real integration attempt: dedicated local Mongo 8.2.6 at 127.0.0.1:27139, replica set nest-test-audit, fresh directory in the OS temporary folder. Initialize the set, set NEST_TEST_MONGODB_URI=mongodb://127.0.0.1:27139/?replicaSet=nest-test-audit, then from apps/admin run `node node_modules/@playwright/test/cli.js test --config playwright.config.ts`. The existing harness allocates its own scratch database. The initial sandbox invocation hit a pnpm environment restriction; the elevated retry reached and reproduced A01. No dependencies were upgraded or production database used.


## Concurrent workspace drift — verification limit

The final before/after patch comparison detected edits made outside this audit while checks were running. This audit did not author or revert them. Admin root layout/proxy now include CSP/nonce work, and backend taxonomy/media/import files also changed. The source predicates underlying the findings remain present on inspection, but earlier successful build/typecheck/browser measurements do **not** certify these later edits. Final combined-tree regression and CSP behavior are **NOT VERIFIED**. The score is the evidence-backed audit baseline, not a certification of a frozen commit.

- [apps/admin/src/app/layout.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/layout.tsx>)
- [apps/api/src/database/import/image-importer.ts](<D:/eng-mina/nest-electronics/apps/api/src/database/import/image-importer.ts>)
- [apps/api/src/modules/catalog/application/brand-admin.service.ts](<D:/eng-mina/nest-electronics/apps/api/src/modules/catalog/application/brand-admin.service.ts>)
- [apps/api/src/modules/catalog/application/category-admin.service.ts](<D:/eng-mina/nest-electronics/apps/api/src/modules/catalog/application/category-admin.service.ts>)
- [apps/api/src/modules/catalog/application/product-image.service.ts](<D:/eng-mina/nest-electronics/apps/api/src/modules/catalog/application/product-image.service.ts>)
- [apps/storefront/src/app/blog/[slug]/page.tsx](<D:/eng-mina/nest-electronics/apps/storefront/src/app/blog/[slug]/page.tsx>)
- [apps/storefront/src/app/products/[slug]/page.tsx](<D:/eng-mina/nest-electronics/apps/storefront/src/app/products/[slug]/page.tsx>)
- [apps/admin/src/proxy.ts](<D:/eng-mina/nest-electronics/apps/admin/src/proxy.ts>)
- [apps/api/src/database/import/import-runner.ts](<D:/eng-mina/nest-electronics/apps/api/src/database/import/import-runner.ts>)
- [apps/storefront/src/proxy.ts](<D:/eng-mina/nest-electronics/apps/storefront/src/proxy.ts>)

A new untracked packages/config/src/content-security-policy.ts was also observed. See [snapshot-drift.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/snapshot-drift.json>) and the before/after patches for tracked-file evidence. Audit-owned Next tsconfig include additions were removed; the pre-existing tsconfig content was restored. Audit servers and the disposable Mongo process were stopped. No production-code fix, dependency upgrade, commit, deployment, or real-service mutation was performed by this audit.
