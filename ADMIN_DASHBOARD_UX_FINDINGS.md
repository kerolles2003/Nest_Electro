# Admin dashboard UX and visual findings

## Concept 03 comparison

Reference: [admin-redesign-exploration/concept-03-editorial-human/index.html](<D:/eng-mina/nest-electronics/admin-redesign-exploration/concept-03-editorial-human/index.html>). The active .editorial overrides use canvas #f8f7f4, surface #fffefa, ink #292f2c, forest #3d604c, 12px surfaces and a quiet sidebar. The implementation matches these, with darker muted text (#62675f instead of #696c65), a 224px sidebar rather than 216px, Georgia headings and system UI labels. These are coherent adaptations.

The real overview substitutes actual available order-count bars for illustrative demo charts. It does not invent growth data or a notification feed. The warm shell, tables, form surfaces and portal dialogs carry through the reviewed screenshots. No entire old dark page remained among the 16 discovered pages. Small legacy controls, tiny uppercase metadata, native confirmation dialogs and some copy retain inconsistent detail. The mobile product form is long (about 3,764px in the captured 320px view), making missing draft recovery particularly costly.

Visual judgment: recognizable, intentional Concept 03 rather than a generic decorative treatment; good default hierarchy does not establish operational correctness. The 8/10 visual score is separate from the 2/10 production-readiness score.

## Accessibility and interaction

Axe found one WCAG AA contrast failure in the 16 default page states, and manual conditional-state inspection found an unnamed search clear button. Zero axe findings on a page is not full conformance: incomplete rules, pointer spacing exceptions, screen-reader reading order, 200% text scaling and long-session assistive workflows need follow-up. The 24px small-target scan is diagnostic only; inline-link/spacing exceptions mean it is not a conformance verdict.

The 48 reused interaction checks were rerun against this checkout and passed (seven dialogs at six widths, mobile navigation, filters/spec editing/shipping cancel). The keyboard mobile menu trapped initial focus, closed with Escape and returned focus. Full keyboard-only CRUD completion is NOT VERIFIED.

Evidence: [supplemental.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/supplemental.json>), [dialog-results.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/dialog-results.json>), [browser.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/browser.json>).

## Findings

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

## Further validation needed

Screen-reader sessions; touch use on actual low-end phones; 200%/400% zoom; empty final page after a real deletion; dirty dialogs dismissed by outside click; live status updates and real reconciliation after refresh. Suggested UI follow-up sequence after correctness repairs: $impeccable harden, $impeccable adapt, $impeccable audit, then $impeccable polish. No redesign is recommended by this audit.


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
