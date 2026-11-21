# ADMIN DASHBOARD ADVERSARIAL AUDIT

Overall Score: **5.2 / 10**

Verdict: **🔴 NO-GO / PRODUCTION BLOCKED**

Audit date: 2026-10-08 (Africa/Cairo). Scope: the current dirty checkout, not a deployed production instance. No production code fixes were made.

| Category | Score / 10 | Critical Findings |
|---|---:|---|
| Functional Correctness | 3 | A01, A03, A07 |
| Navigation & Information Architecture | 7 | A08, A15 |
| Authentication | 6 | A13, A14, A15 |
| Authorization & Permissions | 5 | A04; real enforcement integration blocked |
| Security | 3 | A02, A04, A11 |
| Data Integrity | 4 | A05, A06, A10 |
| Error Handling | 5 | A06, A12, A22 |
| Failure Resilience | 4 | A03, A12, A16 |
| Concurrency / Race Conditions | 3 | A05, A14 |
| Forms & Validation | 5 | A07, A09, A19 |
| Tables / Search / Filtering | 6 | A08, A20, A21 |
| CRUD Workflows | 3 | A01, A03, A10 |
| UX / Usability | 6 | A08, A19, A22 |
| Visual Design | 8 | A17; strong Concept 03 match |
| Design System Consistency | 8 | Legacy controls and fine text remain inconsistent |
| Responsive Design | 8 | 153 checks without document overflow; table scrolling remains necessary |
| Accessibility | 7 | A17, A18; automated pass is not full conformance |
| Performance | 6 | A16, A20; limited fixture benchmark |
| API Efficiency | 6 | Legacy serial counts and redundant product count requests |
| State Management / Caching | 5 | A05, A08, A21 |
| Loading / Empty / Error States | 7 | A03, A12; otherwise explicit fallbacks |
| Browser Stability | 6 | A03, A07, A12 |
| Testing & Test Coverage | 4 | A01; successful real CRUD/role/concurrency suite unavailable |
| Maintainability | 6 | Centralized clients/primitives, but split legacy contracts and broad CSS overrides |
| Production Readiness | 2 | A01, A02, A03, A05, A06 |

## Executive summary

22 findings: **1 P0, 5 P1, 14 P2, 2 P3**. The principal release gate is backend startup. The most consequential additional issues concern vulnerable dependencies, file transport, authorization during identity failure, and product update integrity.

### Top 10 strengths

1. Server-side staff identity is read from /auth/me instead of trusting a browser role claim.
2. Mutation exports guard the acting operator; the isolated denied-actor probe made no data call.
3. Global JWT and role guards exist; SUPER_ADMIN restrictions cover destructive account/permanent-product operations.
4. Role-guard, password-policy, audit-diff and pricing DTO unit suites passed: 37 tests.
5. Server-only API tokens use HttpOnly cookies; production cookies are Secure and SameSite=Lax.
6. API reads use no-store; backend order transitions and stock operations use transaction-oriented services.
7. The nine-width sweep found no document-level horizontal overflow across 153 page/viewport checks.
8. Dialog/nav focus entry, Escape, return, and ordinary interaction checks passed in 48 fixture checks.
9. Most default page states passed automated WCAG A/AA checks; fields have substantial label coverage.
10. Concept 03 colors, serif hierarchy, warm surfaces and quiet navigation are consistently recognizable; typecheck, lint and build pass.

### Top 10 weaknesses

1. API startup is broken (A01).
2. Known vulnerable runtime dependencies remain installed (A02).
3. Routine image sizes break the editor (A03).
4. Legacy reads continue without confirmed identity (A04).
5. Concurrent product writes lack a version contract (A05).
6. Failure messages can deny an already-applied write (A06).
7. Slug checks request a nonexistent URL (A07).
8. Filter reset races local search state (A08).
9. Legacy validation, affected-row checks and audit attribution are incomplete (A09–A11).
10. A long form can lose unsaved work; error and accessibility states still contain defects (A17–A19).

### Top 10 risks

1. Releasing a checkout whose backend cannot start.
2. Framework availability exposure and conditional RCE on affected deployment configurations.
3. Overwriting another administrator’s product price.
4. Repeating a mutation after an uncertain/partial success.
5. Relying on unverified Supabase RLS when API identity fails.
6. Believing success toasts for zero-row legacy mutations.
7. Losing operational attribution on legacy mutations.
8. Unexpected sign-in interruptions during throttling or multi-tab refresh.
9. Operators losing search context and lengthy product drafts.
10. Overestimating readiness from fixture checks while real CRUD and authorization integration remain unverified.

### Top 10 recommended fixes

1. Repair API module wiring and run the unchanged integration suites.
2. Upgrade affected dependencies and verify deployment-specific advisory exposure.
3. Align upload limits and preserve editor state on transport failure.
4. Fail closed on unavailable identity and consolidate the legacy authorization path.
5. Add a product version/conflict contract and test concurrent administrators.
6. Make multi-step product writes atomic or expose/reconcile partial outcomes.
7. Repair the slug fetch basePath and add a real form-to-route check.
8. Synchronize search input, filters and browser history.
9. Harden legacy number/date/ID validation, affected-row verification and audit/state refresh.
10. Fix conditional control names/contrast, add draft recovery, then rerun adversarial checks.

## Evidence boundaries

- **Real application:** the unchanged Next frontend was built and exercised in Chromium. Its backend reads were replaced only through process environment variables with an isolated loopback fixture; application source was not replaced.
- **Real integration:** the unchanged Playwright/API startup was attempted on a disposable loopback Mongo replica set. It failed during Nest dependency resolution before tests ran (A01). Successful persisted CRUD, real role enforcement, real refresh rotation, IDOR, and multi-admin Mongo transactions are **NOT VERIFIED**.
- **Action/service probes:** execute unchanged action modules or the freshly compiled ProductAdminService with explicit in-memory dependency doubles. They prove branching and write ordering, not deployed database behavior.
- **Security:** static enforcement review and safe routing tests only. No destructive DoS/RCE payload, production account, real upload provider, real Supabase write, or external customer data was used. Scanner findings were reviewed for applicability, not treated as successful exploitation.
- **Performance:** production Next build, local fixture data, Chromium, small ordinary datasets plus a separate 1,000-record taxonomy probe. These are measurements, not production SLOs or a Lighthouse score.
- **Accessibility:** axe 4.11.3 on 16 rendered page states plus keyboard/dialog probes and conditional-control inspection. Full screen-reader/browser coverage is **NOT VERIFIED**.
- The scores are conservative engineering judgments based on this evidence. They are not pass percentages. Unverified business workflows lower assurance even where source protections look sound.

## Scoring

Weighted score: 532/103 = 5.165049 → **5.2/10**. Suggested weights are normalized because they total 103. See [ADMIN_DASHBOARD_SCORECARD.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_SCORECARD.md>) for the complete calculation.

## Findings

### A01 — API cannot bootstrap: missing TransactionService provider

ID: A01

Severity: **P0**

Category: Functional Correctness

Score Impact: Contributes to Functional Correctness and related readiness scores; not a mechanically additive deduction.

Route: All API-backed routes

Component: [apps/api/src/modules/users/users.module.ts:58](<D:/eng-mina/nest-electronics/apps/api/src/modules/users/users.module.ts:58>)

Title: API cannot bootstrap: missing TransactionService provider

Description: CustomersAdminService now injects TransactionService, but UsersModule does not import its exporting DatabaseModule. The existing integration harness stops before any test executes.

Reproduction: Start the dedicated loopback replica set and run the unchanged admin Playwright configuration. See TEST_RESULTS for commands.

Expected: The API starts and the integration tests reach their test bodies.

Actual: Nest throws UnknownDependenciesException at constructor index 3.

Evidence: real-e2e.log; CustomersAdminService constructor line 97; UsersModule imports.

Impact: The audited full application cannot run from this checkout. A frontend build is not evidence that its backend boots.

Recommendation: Repair the module dependency in a separate fix, then rerun startup and the full integration suite. Do not bypass the provider or remove the test.

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

### A03 — Advertised 5 MB upload crashes above Next’s 1 MB action limit

ID: A03

Severity: **P1**

Category: CRUD Workflows

Score Impact: Contributes to CRUD Workflows and related readiness scores; not a mechanically additive deduction.

Route: /admin/products/[id]/edit

Component: [apps/admin/src/components/products/ProductImageManager.tsx:57](<D:/eng-mina/nest-electronics/apps/admin/src/components/products/ProductImageManager.tsx:57>)

Title: Advertised 5 MB upload crashes above Next’s 1 MB action limit

Description: The image control advertises 5 MB, but next.config.ts has no Server Action body-size override. Its upload loop does not catch the transport exception.

Reproduction: Open a product editor and upload a valid PNG between 1 and 5 MB. supplemental.cjs creates a valid 1,923,982-byte PNG without accessing external media.

Expected: Upload reaches validation, or a local error preserves the editor.

Actual: The action POST returns 500 and the editor is replaced by the route error boundary before the API upload endpoint is called.

Evidence: supplemental.json; upload-failure.png; upload-server-errors.log; installed Next serverActions.md documents the default.

Impact: Routine product media management fails; unsaved editor context can be lost.

Recommendation: Align client, Next transport, and API limits with multipart overhead; catch upload transport errors and retain editor state.

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

### A07 — Slug availability request omits /admin

ID: A07

Severity: **P2**

Category: Forms & Validation

Score Impact: Contributes to Forms & Validation and related readiness scores; not a mechanically additive deduction.

Route: /admin/products/new; /admin/products/[id]/edit

Component: [apps/admin/src/components/products/ProductForm.tsx:176](<D:/eng-mina/nest-electronics/apps/admin/src/components/products/ProductForm.tsx:176>)

Title: Slug availability request omits /admin

Description: The form uses an absolute fetch path that bypasses the configured basePath.

Reproduction: Type a new product name or change its slug; inspect the request.

Expected: GET /admin/api/check-slug returns the actual availability.

Actual: GET /api/check-slug returns 404 and the form shows “Could not check”. Saving still relies on backend uniqueness.

Evidence: adversarial.json: slug wrong basePath and correctly prefixed control; slug.png.

Impact: Duplicate discovery happens late and every new slug creates a real failed network request.

Recommendation: Use the shared basePath for fetch URLs and test the real form request, not only the route handler.

### A08 — Clear filters is undone by stale local search state

ID: A08

Severity: **P2**

Category: Tables / Search / Filtering

Score Impact: Contributes to Tables / Search / Filtering and related readiness scores; not a mechanically additive deduction.

Route: /admin/customers; analogous coupon/review filters

Component: [apps/admin/src/components/customers/CustomersTable.tsx:107](<D:/eng-mina/nest-electronics/apps/admin/src/components/customers/CustomersTable.tsx:107>)

Title: Clear filters is undone by stale local search state

Description: Clear changes the URL but leaves searchInput unchanged. The debounce effect observes the mismatch and pushes the old search back. The same pattern appears in coupons/reviews; those variants were source-inspected.

Reproduction: Search customers for Salma, wait for the URL, click Clear, and wait more than 350 ms.

Expected: Input and URL both clear.

Actual: The URL returns to ?search=Salma&page=1; the input remains Salma.

Evidence: adversarial.json: clear customer search; effect at CustomersTable.tsx:84.

Impact: Reset/back navigation is unreliable and can trap an operator in filtered results.

Recommendation: Synchronize local input with navigation, cancel stale debounces, and update both on reset; add back/forward and rapid-filter coverage.

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

### A12 — Malformed successful responses escape typed error handling

ID: A12

Severity: **P2**

Category: Failure Resilience

Score Impact: Contributes to Failure Resilience and related readiness scores; not a mechanically additive deduction.

Route: All API-backed routes

Component: [apps/admin/src/lib/api/client.ts:176](<D:/eng-mina/nest-electronics/apps/admin/src/lib/api/client.ts:176>)

Title: Malformed successful responses escape typed error handling

Description: safeJson returns null for invalid JSON, but apiFetch accepts it as T for any non-error status. Consumers dereference data without runtime validation.

Reproduction: Return HTTP 200 with {broken for /admin/catalog/products and open the list.

Expected: A controlled protocol error preserves page context and gives meaningful retry feedback.

Actual: A TypeError takes the whole page into its route boundary. The boundary recovers the shell, but the requested screen disappears.

Evidence: adversarial.json: malformed 200 product response; client.ts:114,176.

Impact: Bad gateway/upstream responses can erase forms and bypass normal error messages.

Recommendation: Validate success envelopes at the API boundary and map decoding/schema failures to a typed protocol error.

### A13 — Identity rate limiting is treated as a rejected session

ID: A13

Severity: **P2**

Category: Authentication

Score Impact: Contributes to Authentication and related readiness scores; not a mechanically additive deduction.

Route: All protected routes

Component: [apps/admin/src/lib/api/identity.ts:122](<D:/eng-mina/nest-electronics/apps/admin/src/lib/api/identity.ts:122>)

Title: Identity rate limiting is treated as a rejected session

Description: Only network/server errors map to unavailable. A 429 maps to rejected and triggers refresh with /login as the destination.

Reproduction: Return 429 from /auth/me while session cookies exist; navigate to products.

Expected: Preserve the session and context, show throttling feedback, and retry after backoff.

Actual: The app calls /auth/refresh and lands on login even when refresh succeeds.

Evidence: adversarial.json: identity 429.

Impact: Transient throttling interrupts work and causes unnecessary token rotation.

Recommendation: Handle throttled identity separately and retain context/session unless credentials are actually rejected.

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

### A15 — Session renewal discards filters and pagination

ID: A15

Severity: **P2**

Category: Navigation & Information Architecture

Score Impact: Contributes to Navigation & Information Architecture and related readiness scores; not a mechanically additive deduction.

Route: Protected deep links after expiry

Component: [apps/admin/src/proxy.ts:160](<D:/eng-mina/nest-electronics/apps/admin/src/proxy.ts:160>)

Title: Session renewal discards filters and pagination

Description: The forwarded path header contains pathname only, omitting search parameters.

Reproduction: Open /admin/orders?q=audit&page=3&status=PLACED while /auth/me reports TOKEN_EXPIRED; inspect the renewal redirect.

Expected: Return to the full local path and query.

Actual: Renewal receives next=/orders and redirects to /admin/orders. The forced repeated-expiry fixture then reaches login via the loop guard.

Evidence: advanced.json: session expiry drops query context; proxy passThroughWithPath.

Impact: Operators lose their queue/filter position after idle-session recovery.

Recommendation: Carry a validated pathname plus search through renewal and test query-bearing deep links.

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

### A17 — Cash-collection warning fails text contrast

ID: A17

Severity: **P2**

Category: Accessibility

Score Impact: Contributes to Accessibility and related readiness scores; not a mechanically additive deduction.

Route: /admin/orders/[id]

Component: [apps/admin/src/components/orders/OrderDetail.tsx:208](<D:/eng-mina/nest-electronics/apps/admin/src/components/orders/OrderDetail.tsx:208>)

Title: Cash-collection warning fails text contrast

Description: Opacity on the warning text reduces contrast below the normal-text threshold.

Reproduction: Open the order detail fixture and run axe WCAG AA checks.

Expected: At least 4.5:1 for the 12px normal-weight text.

Actual: Axe measured 3.74:1 (#97743f on #f2efe9).

Evidence: supplemental.json: color-contrast; order-detail screenshot.

Impact: A financial consequence is harder to read for low-vision users.

Recommendation: Use an opaque tested warning foreground and recheck the rendered background.

### A18 — Search clear icon has no accessible name

ID: A18

Severity: **P2**

Category: Accessibility

Score Impact: Contributes to Accessibility and related readiness scores; not a mechanically additive deduction.

Route: /admin/customers search; similar legacy controls

Component: [apps/admin/src/components/customers/CustomersTable.tsx:153](<D:/eng-mina/nest-electronics/apps/admin/src/components/customers/CustomersTable.tsx:153>)

Title: Search clear icon has no accessible name

Description: The conditional X button has no text, title, aria-label, or referenced label. The default-state axe sweep misses it because it appears only after typing.

Reproduction: Type a customer search and inspect the X button in the accessibility tree/DOM.

Expected: The button announces Clear customer search.

Actual: The button contains only an unlabeled SVG.

Evidence: supplemental.json: unnamed search clear.

Impact: Keyboard/screen-reader users cannot identify the control’s purpose.

Recommendation: Name conditional icon controls and include interaction states in accessibility regression checks.

### A19 — Unsaved product work is lost without warning

ID: A19

Severity: **P2**

Category: UX / Usability

Score Impact: Contributes to UX / Usability and related readiness scores; not a mechanically additive deduction.

Route: /admin/products/new and edit

Component: [apps/admin/src/components/products/ProductForm.tsx:261](<D:/eng-mina/nest-electronics/apps/admin/src/components/products/ProductForm.tsx:261>)

Title: Unsaved product work is lost without warning

Description: The form has no dirty-state navigation guard or persisted draft recovery.

Reproduction: Type a new product name, choose Back to catalogue, then use browser Back.

Expected: Warn before discarding or restore an unsaved draft.

Actual: No dialog appears and the name field returns empty.

Evidence: advanced.json: unsaved product navigation.

Impact: Long product-entry work is easily lost through ordinary navigation.

Recommendation: Add a consistent dirty-state policy and draft recovery for long forms.

### A20 — Taxonomy lists render every record at once

ID: A20

Severity: **P3**

Category: Performance

Score Impact: Contributes to Performance and related readiness scores; not a mechanically additive deduction.

Route: /admin/categories; /admin/brands

Component: [apps/api/src/modules/catalog/application/brand-admin.service.ts:85](<D:/eng-mina/nest-electronics/apps/api/src/modules/catalog/application/brand-admin.service.ts:85>)

Title: Taxonomy lists render every record at once

Description: The API returns an unbounded list and the client maps it to DOM without pagination/virtualization.

Reproduction: Run large.cjs with 1,000 synthetic long Unicode names at 320px.

Expected: Bounded rendering or an explicit tested capacity target.

Actual: About 20,225 DOM nodes; dev fixture navigation took 1.55–2.55 seconds. No document overflow occurred. This is a capacity risk, not a demonstrated crash.

Evidence: large.json; large-brands.png and large-categories.png; BrandsManager map.

Impact: Further growth increases rendering/memory cost, particularly on lower-end devices.

Recommendation: Define volume targets and paginate/virtualize taxonomy management; benchmark with production-shaped data.

### A21 — Legacy mutations patch rows without reconciling counters or filters

ID: A21

Severity: **P2**

Category: State Management / Caching

Score Impact: Contributes to State Management / Caching and related readiness scores; not a mechanically additive deduction.

Route: /admin/coupons; /admin/reviews

Component: [apps/admin/src/components/reviews/ReviewsTable.tsx:131](<D:/eng-mina/nest-electronics/apps/admin/src/components/reviews/ReviewsTable.tsx:131>)

Title: Legacy mutations patch rows without reconciling counters or filters

Description: Moderation/toggle/delete update local arrays, but server-derived stats, total and totalPages remain props. Legacy actions revalidate /admin-prefixed paths, unlike the API-backed actions, and do not refresh the client router.

Reproduction: Source trace: approve a pending review or remove a last-page row. The local branch changes/removes a row only. Real persisted mutation verification is blocked/unavailable.

Expected: Counts, active filters, pagination and rows agree after a successful mutation.

Actual: State update code does not recalculate these values or force an authoritative read.

Evidence: ReviewsTable.tsx:131,149; CouponsTable.tsx:228,246; legacy action revalidatePath calls. Source-confirmed state gap; end-to-end persistence NOT VERIFIED.

Impact: Ghost rows under a status filter, stale counters, or empty last pages can mislead moderation work.

Recommendation: Revalidate actual route paths and refresh/reconcile the full query result after success; cover last-row deletion.

### A22 — Shared error messages incorrectly refer to orders

ID: A22

Severity: **P3**

Category: Error Handling

Score Impact: Contributes to Error Handling and related readiness scores; not a mechanically additive deduction.

Route: Non-order API screens

Component: [apps/admin/src/lib/api/errors.ts:153](<D:/eng-mina/nest-electronics/apps/admin/src/lib/api/errors.ts:153>)

Title: Shared error messages incorrectly refer to orders

Description: The global operatorMessage translator uses order-specific not-found/conflict wording for products and taxonomy too.

Reproduction: Return 404 for the product list or 409 for category creation.

Expected: An entity-correct recovery instruction.

Actual: “That order no longer exists” or “Reload the order” appears on catalogue/category screens.

Evidence: adversarial.json products GET 404/409; advanced.json category failure.

Impact: Error recovery instructions point users toward the wrong entity.

Recommendation: Use neutral wording or supply entity context to the translator.

## Audit artifacts

- [ADMIN_DASHBOARD_AUDIT_MAP.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_AUDIT_MAP.md>)
- [ADMIN_DASHBOARD_SCORECARD.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_SCORECARD.md>)
- [ADMIN_DASHBOARD_ROUTE_MATRIX.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_ROUTE_MATRIX.md>)
- [ADMIN_DASHBOARD_SECURITY_FINDINGS.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_SECURITY_FINDINGS.md>)
- [ADMIN_DASHBOARD_UX_FINDINGS.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_UX_FINDINGS.md>)
- [ADMIN_DASHBOARD_TEST_RESULTS.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_TEST_RESULTS.md>)

Raw evidence and reproducible scripts: [evidence directory](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/>) and [audit scripts](<D:/eng-mina/nest-electronics/admin-dashboard-audit/>).



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
