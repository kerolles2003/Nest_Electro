# Nest Electro — Test Coverage Gaps

**HEAD:** `bb7c331` on `phase-1-2-overnight`

## What was actually executed in this audit (2026-11-21)

| Command | Result |
|---|---|
| `pnpm install --frozen-lockfile` (workspace) | ✅ Passed (960 packages) |
| `apps/api`: `tsc --noEmit` | ✅ Passed (exit 0) |
| `apps/api`: `nest build` | ✅ Passed (exit 0) |
| `apps/storefront`: `tsc --noEmit` | ✅ Passed (no errors) |
| `apps/admin`: `tsc --noEmit` | ✅ Passed (no errors) |
| `node scripts/scan-secrets.mjs` | ✅ Clean — 935 blobs, 16 patterns, canaries self-proven |
| API bootstrap: `node dist/main.js` (generated JWT secret, dummy Mongo URI) | ❌ **Failed as expected — this is the A01 reproduction:** `UnknownDependenciesException … TransactionService at index [3] is available in the UsersModule` |
| `jest test/catalog/slug.spec.ts` | ⚠️ Not executed — Jest global setup refuses to run without `NEST_TEST_MONGODB_URI` pointing at a dedicated local replica set. No MongoDB was available in the audit environment (a `mongodb-memory-server` binary download timed out), and per the assignment no shared database was touched. **No DB-backed test result is claimed anywhere in this assessment.** |

Inventory at HEAD: **67 API spec files** (`apps/api/test/**`, plus Jest configs `jest.p0.config.js` / `jest.p1.config.js`) and **18 Playwright spec files** across storefront and admin `e2e/`.

## The structural gap that matters most

**No test compiles the full `AppModule` graph.** Suites build partial testing modules and/or use the scratch-DB harness with provider overrides. That is why a codebase with this much test investment shipped a bootstrap that cannot start: every suite proved its own slice, and the composition root — the one thing production actually runs — was never instantiated in a test. A01 is the proof.

**Gap G1 (blocker-grade):** add a smoke suite that calls `NestFactory.create(AppModule)` (or `Test.createTestingModule({ imports: [AppModule] }).compile()`) against the scratch replica set and asserts the app reaches `listen`/health. This single test would have caught all three missing `DatabaseModule` imports.

## Coverage gaps by area

| ID | Area | Gap | Risk |
|---|---|---|---|
| G1 | Bootstrap / DI graph | No full-AppModule compile test (above). | Total outage ships undetected — already happened. |
| G2 | Storefront session renewal (F01) | No test exercises an expired access token during a Server Component render. Existing e2e covers login/logout happy paths; the renewal-during-render path — where `cookies().set()` throws — is untested in both apps' storefront suites. Admin has the renewal-route pattern; storefront has no equivalent test because it has no equivalent code. | Silent session destruction in production. |
| G3 | Admin slug check (A07) | API-side slug tests exist (`test/catalog/slug.spec.ts`) and pass/fail against the API contract, but no admin e2e asserts the browser actually reaches `/admin/api/check-slug` under the basePath, and no unit test covers `ProductForm`'s fetch URL or its `response.ok` handling. | A permanently "unknown" slug state ships silently — already happened. |
| G4 | Product update concurrency (A05/A06) | No concurrent-update test for `ProductAdminService.update()` (two writers, same product), and no failure-injection test proving redirect/recount/audit cannot diverge from the product write. Delete/restore paths have the transactional pattern; update has neither the pattern nor the test. | Lost price updates; catalogue/audit divergence. |
| G5 | Wallet/InstaPay | Zero — the feature does not exist, so neither do tests. When built, it needs: unauthorized-transition attempts, duplicate/concurrent approval, amount mismatch, rejection-then-resubmission, approval-after-cancellation, and idempotency replay tests *before* it is trusted. | Financial-integrity failures in the highest-risk workflow. |
| G6 | Shipping (F16) | Service-level behaviour is described in docs; there is no end-to-end checkout test against an *unseeded* governorate proving the failure is a clean, customer-readable error rather than a 500, and no test pins "seed data ≠ owner-approved rates" as a configuration gate. | Checkout failure per-governorate in production. |
| G7 | Contact form (F17) | No test — the form calls nothing, so there is nothing to assert against. Any fix must land with a test that a submission produces a delivery attempt (or that the form no longer claims success). | Silent customer-message loss — already happening. |
| G8 | Category/brand pagination (F18) | No e2e asserts reachability of product #25+ on category/brand pages. Listing and search pagination are covered by their implementations but a shared pagination regression test across all four surfaces (listing, search, category, brand) does not exist. | Silent catalogue truncation. |
| G9 | Reviews presentation (F38) | No test asserts the storefront never renders "verified" or emits `aggregateRating` JSON-LD for products without provenance-backed reviews. | SEO/consumer-trust claim with no backing data. |
| G10 | Notifications resilience | By design there is no outbox/retry; correspondingly there is no test characterising what a customer experiences when the email provider fails mid-checkout (order committed? email lost? any record?). The behaviour should at minimum be pinned by a test so the trade-off is explicit. | Lost order confirmations with no trace. |
| G11 | CI branch coverage | Main CI (lint/type-check/build/tests) triggers on `main` pushes and PRs only; the secret scan runs on all branches. A long-lived branch like `phase-1-2-overnight` (146 commits ahead of `main` per the handoff) can accumulate unverified work. | Late discovery of exactly the class of failure in G1. |
| G12 | Accessibility & performance | No automated a11y checks in either e2e suite and no performance budgets/Lighthouse gate found. | Unknown — unmeasured, not proven bad. |

## What is genuinely well covered (for balance)

- Scratch-database isolation per suite, with a teardown that *fails the run* if a suite leaves data behind.
- Email-vendor isolation forced in Jest setup (prevents tests sending real email) and production-like rate limits pinned in tests.
- Index-health verification across users/products/categories/brands/orders/reviews.
- Slug availability API behaviour, media rejection paths (magic bytes, oversize, MIME mismatch), checkout idempotency and overselling guard — at the service/API level, within the partial-graph limitation of G1.
