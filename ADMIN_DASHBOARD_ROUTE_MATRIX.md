# Admin route coverage

Discovered recursively from `apps/admin/src/app`, independently of sidebar links: **16 page files and 2 route handlers**. All 18 received a browser or HTTP routing probe. Dynamic paths used fixture IDs; production record coverage is NOT VERIFIED. Anonymous navigation checks cover every page plus both handlers.

| Route | Page | Auth Required | Roles | Data Source | Tested | Result |
|---|---|---|---|---|---|---|
| /admin/audit-log | [(dashboard)/audit-log/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/audit-log/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest audit logs/action vocabulary | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/brands | [(dashboard)/brands/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/brands/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest taxonomy | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/categories | [(dashboard)/categories/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/categories/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest taxonomy | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/coupons | [(dashboard)/coupons/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/coupons/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Legacy Supabase via lib/supabase | Rendered + 9 widths + anonymous direct URL | Fixture renders; A04/A09–A11/A21; real RLS NOT VERIFIED |
| /admin/customers | [(dashboard)/customers/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/customers/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest customers + dashboard | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/inventory | [(dashboard)/inventory/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/inventory/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest inventory + dashboard + taxonomy | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/orders/[id] | [(dashboard)/orders/[id]/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/orders/[id]/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest orders/status counts | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/orders | [(dashboard)/orders/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/orders/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest orders/status counts | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin | [(dashboard)/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest dashboard/orders/audit | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/products/[id]/edit | [(dashboard)/products/[id]/edit/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/products/[id]/edit/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest catalogue + taxonomy | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/products/new | [(dashboard)/products/new/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/products/new/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest catalogue + taxonomy | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/products | [(dashboard)/products/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/products/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest catalogue + taxonomy | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/reviews | [(dashboard)/reviews/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/reviews/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Legacy Supabase via lib/supabase | Rendered + 9 widths + anonymous direct URL | Fixture renders; A04/A09–A11/A21; real RLS NOT VERIFIED |
| /admin/settings | [(dashboard)/settings/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/(dashboard)/settings/page.tsx>) | Yes | ADMIN / SUPER_ADMIN | Nest shipping rates | Rendered + 9 widths + anonymous direct URL | Fixture renders; real data/workflows NOT VERIFIED (A01) |
| /admin/api/check-slug | [api/check-slug/route.ts](<D:/eng-mina/nest-electronics/apps/admin/src/app/api/check-slug/route.ts>) | Yes | ADMIN / SUPER_ADMIN | GET /admin/catalog/slug-availability | Handler/routing probe | Handler 200; caller broken A07 |
| /admin/login | [login/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/login/page.tsx>) | No | Public | POST /auth/login | Rendered + 9 widths + anonymous direct URL | Renders |
| /admin/session/renew | [session/renew/route.ts](<D:/eng-mina/nest-electronics/apps/admin/src/app/session/renew/route.ts>) | Refresh cookie | Session renewal | POST /auth/refresh | Handler/routing probe | 303 safety tests; A14/A15 |
| /admin/unauthorized | [unauthorized/page.tsx](<D:/eng-mina/nest-electronics/apps/admin/src/app/unauthorized/page.tsx>) | No | Public | Static | Rendered + 9 widths + anonymous direct URL | Renders |

Additional surfaces: `/admin/not-a-real-route` exercises not-found (404) at all nine widths; `global-error.tsx` is a root boundary, not a URL, and was source-reviewed only. Dashboard error boundary was exercised by malformed JSON and upload transport failure. Loading boundaries exist for dashboard, products and orders. Favicon/static assets are not application workflows; no broken static assets appeared in the page sweep.

Protected pages without cookies redirected to `/admin/login`; the CUSTOMER identity fixture also redirected there. This proves frontend decisions, not API JWT validation. Successful real ADMIN/SUPER_ADMIN/customer token requests remain NOT VERIFIED because API startup fails.

Evidence: [browser.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/browser.json>), [adversarial.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/adversarial.json>), [states.json](<D:/eng-mina/nest-electronics/admin-dashboard-audit/evidence/states.json>).


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
