# Admin dashboard audit map

## Scope and architecture

[apps/admin/next.config.ts](<D:/eng-mina/nest-electronics/apps/admin/next.config.ts>) defines a Next.js 16.2.4 App Router application at /admin. apps/api is its NestJS/Mongo backend. apps/storefront is separate. Shared visual primitives live in packages/ui; types/providers/services remain in packages. The audit reviewed the current working tree, including pre-existing backend and image changes; findings are not attributed solely to the redesign.

The source-derived route inventory is [ADMIN_DASHBOARD_ROUTE_MATRIX.md](<D:/eng-mina/nest-electronics/ADMIN_DASHBOARD_ROUTE_MATRIX.md>).

| Concern | Enforcement/implementation | Audit observations |
|---|---|---|
| Root/shell | app/layout.tsx; (dashboard)/layout.tsx; AdminHeader; Sidebar | Warm admin-app scope, skip link, mobile Radix drawer, role identity from server |
| Auth navigation | proxy.ts | Cookie-presence convenience guard; not the authorization boundary; action requests pass through |
| Identity | lib/api/identity.ts | /auth/me role check; requireAdmin returns null on outage, requireAdminActor throws |
| Sessions | lib/api/session.ts; renewal.ts; app/session/renew/route.ts | HttpOnly pair, Secure in production, Lax; refresh rotates via route; A13–A15 |
| API transport | lib/api/client.ts; endpoints.ts; types.ts; errors.ts | Server-only bearer, no-store, typed errors; no deadline/schema validation; A06/A12/A16 |
| Mutations | src/actions: admin-auth, admin-order, product, product-image, category-brand, inventory, shipping-rates, coupon, review | Authenticated server actions. Validation mixed: API DTOs for modern domains, Zod/loose coercion for legacy |
| Backend auth | AppModule global JwtAuthGuard and RolesGuard | Role metadata on all admin controllers; tokenVersion check on privileged routes |
| Elevated operations | admin-customers.controller; admin-products.controller | SUPER_ADMIN role change/account deletion/permanent product deletion; runtime tests blocked |
| Domain integrity | order-lifecycle, inventory-admin, product-admin, taxonomy, shipping services | Order/inventory transaction paths; product update still permits lost/partial writes |
| Legacy data | lib/supabase.ts; getAdminServices; coupon/review actions | Independent anon/session client; no API-to-Supabase sign-in bridge; RLS NOT VERIFIED |
| Audit | API AuditService; legacy log-action.ts | API actor/intent/diff records; legacy actor UUID mismatch skips writes |
| UI primitives | components/ui/admin.tsx, admin-dialog, form-field, status-badge; packages/ui | Reusable headers/cards/states/table scrolling, portal dialogs and field associations |
| Forms | ProductForm, ProductSpecsEditor, taxonomy dialogs, InventoryAdjustDialog, shipping editor, login/form | Client state + server actions; validation associations mostly present; no long-form draft recovery |
| Tables/queries | ProductTable, OrdersTable/QueueFilters, InventoryTable, CustomersTable, CouponsTable, ReviewsTable, AuditLogTable | URL filters/paging; API lists bounded; taxonomy lists unbounded; legacy reset race |
| Charts | dashboard order distribution | Real count bars, no fabricated revenue time series; accessible group with numeric labels |
| Modals/drawers | AdminDialog + Radix; mobile navigation; inventory history | Focus/Escape/return checked; history only shows most recent 25, no older-page control |
| Notifications | AdminHeader | Explicit unavailable message; no notification backend/feed claimed |
| Media | ProductImageManager; product-image.actions; API media service | API 5 MB/type/magic-byte processing; Next transport 1 MB mismatch; image-version conflict contract exists |
| State/caching | React state, URLSearchParams, router.refresh, revalidatePath; API no-store | No broad optimistic domain store. Legacy row patches/counters diverge; shipping keeps initialRates in local state |
| Loading/error/empty | route loading/error boundaries; shared states; per-domain panels | Empty/error fixture pass; malformed success enters boundary; root boundary NOT VERIFIED in browser |
| Responsive/theme | app/globals.css | Explicit shared Tailwind source, light Concept 03 tokens, 1024px nav breakpoint, internal table scrolling, reduced motion |

## Backend endpoint groups traced

/auth/login, /auth/me, /auth/refresh, /auth/logout; /admin/dashboard/stats; /admin/orders and lifecycle actions; /admin/catalog/products and images/publish/delete/restore; /admin/catalog/categories, brands and slug-availability; /admin/inventory, events and adjust; /admin/customers and elevated account actions; /admin/audit-logs; /admin/shipping-rates. All are beneath the API /api/v1 prefix. Coupon/review data remains Supabase REST.

## Discovery method

Recursive route enumeration; action/guard/controller searches; source review of request/response contracts, mutation handlers, relevant services, stylesheet and representative components; fresh build/typecheck/lint; existing test inventory; real integration startup attempt; isolated browser/fault/action/service probes. Existing redesign reports were treated as historical claims and not counted as newly passing tests.


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
