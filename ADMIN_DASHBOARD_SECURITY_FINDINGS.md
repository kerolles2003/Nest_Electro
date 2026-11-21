# Admin dashboard security findings

## Evidence boundaries

- **Real application:** the unchanged Next frontend was built and exercised in Chromium. Its backend reads were replaced only through process environment variables with an isolated loopback fixture; application source was not replaced.
- **Real integration:** the unchanged Playwright/API startup was attempted on a disposable loopback Mongo replica set. It failed during Nest dependency resolution before tests ran (A01). Successful persisted CRUD, real role enforcement, real refresh rotation, IDOR, and multi-admin Mongo transactions are **NOT VERIFIED**.
- **Action/service probes:** execute unchanged action modules or the freshly compiled ProductAdminService with explicit in-memory dependency doubles. They prove branching and write ordering, not deployed database behavior.
- **Security:** static enforcement review and safe routing tests only. No destructive DoS/RCE payload, production account, real upload provider, real Supabase write, or external customer data was used. Scanner findings were reviewed for applicability, not treated as successful exploitation.
- **Performance:** production Next build, local fixture data, Chromium, small ordinary datasets plus a separate 1,000-record taxonomy probe. These are measurements, not production SLOs or a Lighthouse score.
- **Accessibility:** axe 4.11.3 on 16 rendered page states plus keyboard/dialog probes and conditional-control inspection. Full screen-reader/browser coverage is **NOT VERIFIED**.
- The scores are conservative engineering judgments based on this evidence. They are not pass percentages. Unverified business workflows lower assurance even where source protections look sound.

## Advisory triage

[dependency-audit.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/dependency-audit.json>) contains the raw workspace production dependency response. It reports 50 vulnerability counts; neither that total nor upstream CVSS automatically establishes exploitability in this admin. Installed Next.js is 16.2.4.

- **Applicable availability condition:** App Router plus Server Actions. Maintainer: [Server Actions DoS](https://github.com/vercel/next.js/security/advisories/GHSA-m99w-x7hq-7vfj). Fixed range starts at 16.2.11 for this advisory alone; do not choose that version without checking newer advisories.
- **Conditional critical:** Windows-hosted Next without Cache Components. The local audit host is Windows; deployment OS is NOT VERIFIED. Maintainer: [Windows RCE](https://github.com/vercel/next.js/security/advisories/GHSA-p293-qw3h-jr36), fixed in 16.3.3 for this advisory.
- **Conditional critical:** affected image optimizer processing AVIF input. Media allow-lists and transitive Sharp versions need deployment-specific review. Maintainer: [Image optimizer AVIF advisory](https://github.com/vercel/next.js/security/advisories/GHSA-2xp9-vwfh-vxw4). No hostile image was tested.
- **Not demonstrated applicable:** next/og attacker-controlled SVG RCE; no ImageResponse usage was found in admin source. Likewise custom-server SSRF and Pages Router/i18n-specific alerts must not be presented as proven here.
- Other graph alerts include multer, Sharp, ws and proxy-addr. The complete graph includes API/storefront/shared/build paths. Reachability and production transitive versions beyond the reviewed Next cases are NOT VERIFIED.

## Enforcement and safe negative checks

Anonymous requests to all protected frontend pages and both route handlers ended at login. A fixture CUSTOMER identity was rejected by the real frontend guard. The direct prefixed slug handler returned 200 only with the fixture staff session. Hostile next values (absolute URL, double slash, backslash) stayed on the local /admin origin; encoded separators were not followed off-origin.

All inspected mutations use requireAdminActor, including the order action common dispatcher. The denied-actor unit probe made zero data calls. Backend global guards, privileged tokenVersion checks, per-controller roles, and SUPER_ADMIN method overrides were inspected. Real token signature rejection, demotion, ID substitution and protected-delete requests are NOT VERIFIED because the API cannot bootstrap.

No dangerouslySetInnerHTML, eval, new Function, browser token storage, or next/og ImageResponse was found in admin source. React text rendering handles ordinary hostile strings. This is not a comprehensive XSS proof. The review search builds a raw PostgREST OR expression; delimiter behavior and deployed RLS remain NOT VERIFIED. Server-only imports and non-public token configuration are positive boundaries, but no complete secret comparison against deployed bundles was performed.

Next defaults enforce same-origin Server Actions; HttpOnly/Secure/Lax cookie settings were source-reviewed. Cross-origin action exploitation and deployment CSP/frame headers were NOT VERIFIED. No production secret files were printed.

## Findings

### A02 — Installed Next.js has applicable high and conditional critical advisories

ID: A02

Severity: **P1**

Category: Security

Score Impact: Contributes to Security and related readiness scores; not a mechanically additive deduction.

Route: All admin routes

Component: [apps/admin/package.json](<D:/eng-mina/nest-electronics/apps/admin/package.json>)

Title: Installed Next.js has applicable high and conditional critical advisories

Description: The installed Next.js 16.2.4 is flagged by the current registry audit. The App Router + Server Actions denial-of-service condition applies. The Windows remote-code-execution condition matches the local host and configuration; production OS is NOT VERIFIED. Image optimizer exposure requires separate media-path assessment. No exploit was attempted.

Reproduction: Run pnpm audit --prod --json; inspect installed next/package.json and the linked maintainer advisories in SECURITY_FINDINGS.

Expected: Production dependencies are outside applicable vulnerable ranges.

Actual: The workspace production graph reports 4 critical, 27 high, 15 moderate and 4 low vulnerability counts. These are scanner counts, not 50 proven admin exploits.

Evidence: dependency-audit.json; Next.js maintainer GHSA-m99w-x7hq-7vfj and GHSA-p293-qw3h-jr36.

Impact: Availability risk on the known Server Action surface; conditional RCE exposure on Windows. Authentication checks do not repair framework vulnerabilities.

Recommendation: Upgrade to a supported release that clears all applicable advisories, assess deployed OS/image paths, and rerun regression/security checks. Treat Windows public deployment as a critical release gate.

### A04 — Legacy pages continue reading when identity cannot be established

ID: A04

Severity: **P1**

Category: Authorization & Permissions

Score Impact: Contributes to Authorization & Permissions and related readiness scores; not a mechanically additive deduction.

Route: /admin/coupons; /admin/reviews

Component: [apps/admin/src/app/(dashboard)/coupons/page.tsx:24](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/coupons/page.tsx:24>)

Title: Legacy pages continue reading when identity cannot be established

Description: requireAdmin returns null for API unavailability. These pages ignore the return and continue querying the independent Supabase client. The real Supabase RLS policy and account linkage are NOT VERIFIED; this is a confirmed fail-open application read path, not a demonstrated production data leak.

Reproduction: Set the audit fixture /auth/me response to 500 while retaining a refresh-cookie value, then open /admin/coupons.

Expected: No protected data request/render occurs until staff identity is established.

Actual: The page renders coupon rows and sends five legacy data/count requests despite unavailable identity.

Evidence: adversarial.json: identity unavailable legacy read; identity.ts:199; reviews page has the same ignored return.

Impact: Authorization depends on a second unverified identity system at exactly the time the authoritative check failed.

Recommendation: Stop protected reads on unavailable identity; consolidate legacy data access behind the API and verify deployed RLS before release.

### A05 — Concurrent product edits overwrite previously saved prices

ID: A05

Severity: **P1**

Category: Concurrency / Race Conditions

Score Impact: Contributes to Concurrency / Race Conditions and related readiness scores; not a mechanically additive deduction.

Route: /admin/products/[id]/edit

Component: [apps/api/src/modules/catalog/application/product-admin.service.ts:449](<D:/eng-mina/nest-electronics/apps/api/src/modules/catalog/application/product-admin.service.ts:449>)

Title: Concurrent product edits overwrite previously saved prices

Description: Product update reads the old document, builds the whole pricing object, then writes by _id only. There is no expected-version predicate. A second request that read the same original can undo a completed price edit even when changing only cost.

Reproduction: Run service-probes.cjs. Two requests see basePrice 10000. The first saves 15000; the second saves costPrice 4000 using its earlier snapshot.

Expected: The second update preserves the new price or returns an explicit conflict.

Actual: The resulting basePrice and effectivePrice revert to 10000. Both update filters contain only _id.

Evidence: service-probes.json (real compiled service, deterministic repository doubles); update DTO/action has no version contract.

Impact: Silent loss of another administrator’s financial edit. Real Mongo interleaving is NOT VERIFIED because A01 blocks integration.

Recommendation: Use optimistic version checks or a transaction with appropriate conflict handling, and avoid whole-pricing writes based on stale snapshots.

### A06 — A failed update can already have changed the product

ID: A06

Severity: **P1**

Category: Data Integrity

Score Impact: Contributes to Data Integrity and related readiness scores; not a mechanically additive deduction.

Route: /admin/products/[id]/edit

Component: [apps/api/src/modules/catalog/application/product-admin.service.ts:489](<D:/eng-mina/nest-electronics/apps/api/src/modules/catalog/application/product-admin.service.ts:489>)

Title: A failed update can already have changed the product

Description: The product write commits before redirect/recount work. A subsequent thrown failure reaches the frontend as an error. operatorMessage nevertheless promises “Nothing was changed” for server/network errors. Durable audit intent records the attempt but does not roll back the write.

Reproduction: Run service-probes.cjs with recount throwing after findOneAndUpdate. The actual compiled update method rejects after writing the new price in the repository double.

Expected: Atomic completion or an explicit indeterminate/partial outcome with reconciliation.

Actual: The method throws while the new price remains 20000. Generic UI failure copy claims no change.

Evidence: service-probes.json; product-admin.service.ts:449,489; apps/admin/src/lib/api/errors.ts operatorMessage.

Impact: An operator may retry an already-applied mutation or trust a stale price. Database fault injection remains NOT VERIFIED.

Recommendation: Make dependent changes atomic where possible; otherwise return a recoverable operation outcome and re-read before advising retry. Never assert no write from a generic transport/500 error.

### A09 — Coupon parsing accepts malformed values and impossible ranges

ID: A09

Severity: **P2**

Category: Forms & Validation

Score Impact: Contributes to Forms & Validation and related readiness scores; not a mechanically additive deduction.

Route: /admin/coupons

Component: [apps/admin/src/actions/coupon.actions.ts:29](<D:/eng-mina/nest-electronics/apps/admin/src/actions/coupon.actions.ts:29>)

Title: Coupon parsing accepts malformed values and impossible ranges

Description: parseFloat(... ) || 0 turns blank/text into zero and accepts numeric prefixes; parseInt truncates fractional usage limits. Percentage values have no upper bound; dates are arbitrary strings with no ordering validation.

Reproduction: Run action-probes.cjs with abc, 12oops, percentage 101, usage_limit 1.9 and invalid date strings.

Expected: Reject malformed finite numbers, fractional limits, invalid dates and invalid percentage/date ranges.

Actual: The action forwards these normalized values and returns success when the repository reports no error. Negative value -1 is correctly rejected.

Evidence: action-probes.json; couponSchema lines 9–20. This is action behavior with mocked Supabase, not proof that a real database accepts every value.

Impact: Invalid promotions can be stored or produce confusing database errors; the UI cannot be treated as the validation boundary.

Recommendation: Strictly parse finite values, validate IDs and dates, apply cross-field/domain limits, and enforce matching backend constraints.

### A10 — Legacy updates/deletes report success when zero rows change

ID: A10

Severity: **P2**

Category: Data Integrity

Score Impact: Contributes to Data Integrity and related readiness scores; not a mechanically additive deduction.

Route: /admin/coupons; /admin/reviews

Component: [apps/admin/src/actions/coupon.actions.ts:98](<D:/eng-mina/nest-electronics/apps/admin/src/actions/coupon.actions.ts:98>)

Title: Legacy updates/deletes report success when zero rows change

Description: Actions check only error, not returned rows/count. A nonexistent or RLS-invisible target can be a successful zero-row query.

Reproduction: Run action-probes.cjs with a repository result {error:null,data:null,count:0} for update, moderation and deletion.

Expected: A no-match result is reported as not found/conflict, with no success toast.

Actual: Coupon/review mutations return success:true. Delete actions also accept malformed IDs without action validation.

Evidence: action-probes.json; review.actions.ts update/delete branches.

Impact: The UI can claim a successful mutation with no backend change.

Recommendation: Require a returned affected record/count and distinguish idempotent deletion from permission/no-match failures.

### A11 — Legacy mutation audit is intentionally skipped for current actors

ID: A11

Severity: **P2**

Category: Security

Score Impact: Contributes to Security and related readiness scores; not a mechanically additive deduction.

Route: /admin/coupons; /admin/reviews

Component: [apps/admin/src/lib/audit/log-action.ts:67](<D:/eng-mina/nest-electronics/apps/admin/src/lib/audit/log-action.ts:67>)

Title: Legacy mutation audit is intentionally skipped for current actors

Description: Current admin identity uses Mongo ObjectIds. logAdminAction only accepts UUIDs and returns before writing for those actors.

Reproduction: Trace any coupon/review action with the normal 24-character API actor ID into logAdminAction.

Expected: Every privileged mutation has durable actor/outcome attribution.

Actual: A warning is emitted once per process; no legacy audit row is written.

Evidence: log-action.ts:67–79; all coupon/review actions call this function. Source-confirmed; real legacy writes are NOT VERIFIED.

Impact: No usable accountability trail for the remaining exposed legacy controls.

Recommendation: Migrate the controls and their audit writes together, or explicitly disable legacy mutations until the trail works.

### A14 — Two renewals independently rotate the same session

ID: A14

Severity: **P2**

Category: Concurrency / Race Conditions

Score Impact: Contributes to Concurrency / Race Conditions and related readiness scores; not a mechanically additive deduction.

Route: /admin/session/renew

Component: [apps/admin/src/app/session/renew/route.ts:61](<D:/eng-mina/nest-electronics/apps/admin/src/app/session/renew/route.ts:61>)

Title: Two renewals independently rotate the same session

Description: The route has no deduplication/coordination. Its comment calls a redirect single-flight, but two tabs or direct concurrent requests still enter independently.

Reproduction: Run the simultaneous renewal probe: two concurrent GETs use the same cookies with the refresh response delayed 300 ms.

Expected: Only one rotation per refresh-token generation, or safe backend replay handling.

Actual: Two /auth/refresh POSTs are observed. The fixture accepts both; actual family revocation is NOT VERIFIED.

Evidence: advanced.json: simultaneous session renewal; client/route source.

Impact: The real rotating-token backend may interpret a normal multi-tab race as token reuse and sign out the operator.

Recommendation: Add session-scoped coordination or a carefully bounded backend rotation-replay design; verify two tabs against real authentication.

### A16 — API client has no application request deadline

ID: A16

Severity: **P2**

Category: Failure Resilience

Score Impact: Contributes to Failure Resilience and related readiness scores; not a mechanically additive deduction.

Route: All API reads and uploads

Component: [apps/admin/src/lib/api/client.ts:91](<D:/eng-mina/nest-electronics/apps/admin/src/lib/api/client.ts:91>)

Title: API client has no application request deadline

Description: Both JSON and multipart fetches have no AbortSignal/deadline; response.text is also outside the network-error catch. The app relies on infrastructure/runtime timeouts.

Reproduction: Inspect both fetch calls; the controlled five-second delay keeps navigation pending until the response. An indefinitely stalled upstream was not allowed to hang this audit.

Expected: A bounded operational deadline produces recoverable feedback and appropriate mutation uncertainty.

Actual: No explicit bound exists in the application; a slow response waits through the whole delay.

Evidence: adversarial.json: slow API 5 seconds and disconnect; client.ts:91,211.

Impact: Slow upstreams can occupy server resources and leave operators uncertain for an uncontrolled duration.

Recommendation: Add bounded, operation-specific deadlines and handle body-read failures; reconcile uncertain mutations rather than promising no change.



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
