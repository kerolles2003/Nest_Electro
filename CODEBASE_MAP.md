# Nest Electronics codebase map

## Applications and boundaries

This pnpm/Turbopack monorepo contains a Next.js 16.2.4 admin (`apps/admin`), a separate Next.js storefront (`apps/storefront`), and the NestJS API (`apps/api`). Workspace packages provide UI, types, configuration, providers, repositories, and services. Admin routes have the existing `/admin` base path.

The Concept 03 redesign is frontend-only. Its source of truth is `admin-redesign-exploration/concept-03-editorial-human/index.html`. Shared `packages/ui` components are also consumed by the storefront: the editorial theme is scoped to the admin application, so adopting it does not restyle the store. The pre-change working-tree inventory is in `docs/admin-redesign/baseline-status.txt`; existing backend, test-harness, media, and storefront work is independent of this redesign.

## Admin route inventory

| Route | Page / component | Data and behavior to preserve |
| --- | --- | --- |
| `/admin` | `(dashboard)/page.tsx` | `getDashboardStats(window)`, `orderStatusCounts`, recent orders, audit activity; 30d/90d/all revenue scope; all-time queues |
| `/admin/products` | `ProductTable` | API catalog; q, state, category, brand, sort, page; separate publish/unpublish, soft delete/restore |
| `/admin/products/new` | `ProductForm` | Category/brand data; validated unpublished draft creation |
| `/admin/products/[id]/edit` | `ProductForm`, `ProductImageManager`, `ProductSpecsEditor` | Bilingual content, immutable SKU, slug availability, pricing, media, specifications; separate publishing and inventory |
| `/admin/orders` | `QueueFilters`, `OrdersTable` | API queue; q, placedFrom, placedTo, sort, status, page; seven lifecycle statuses |
| `/admin/orders/[id]` | `OrderDetail` | API detail and server-authorized transitions; shipment, customer, payment, status history, print |
| `/admin/inventory` | `InventoryTable`, `InventoryAdjustDialog`, `InventoryHistoryDrawer` | Stock filters, movement type/quantity/reason validation, paginated ledger; no product-form stock writes |
| `/admin/categories` | `CategoriesManager` | Category tree, bilingual fields, depth/parent constraints, create/edit/delete/restore |
| `/admin/brands` | `BrandsManager` | Optional product brands; create/edit/delete/restore |
| `/admin/customers` | `CustomersTable` | API customer search/pagination, server-formatted spend, customer statistics |
| `/admin/coupons` | `CouponsTable` | Existing Supabase legacy domain; existing not-live notice, filters, create/edit/toggle/delete |
| `/admin/reviews` | `ReviewsTable` | Existing Supabase legacy domain; existing not-live notice, search, moderation, selection and bulk actions |
| `/admin/audit-log` | `AuditLogTable` | API filters/pagination; actor/entity/change details, append-only log |
| `/admin/settings` | `ShippingRatesTable` | API shipping rates, inline editing, nonnegative fee validation; no deletions |
| `/admin/login` | `login/page.tsx`, `form.tsx` | Existing login Server Action, validation, pending/error feedback |
| `/admin/unauthorized` | `unauthorized/page.tsx` | Existing access refusal and login link |

`not-found.tsx`, `global-error.tsx`, and loading boundaries are system states, not new business routes. `/admin/session/renew` and `/admin/api/check-slug` are existing handlers; they are not UI redesign targets. There are no separate payments, reports, profile, analytics, or notifications routes.

## Authentication, API access, and mutations

- `src/proxy.ts` performs the existing session-cookie navigation check and path forwarding. It is not the authorization boundary.
- `src/lib/api/identity.ts` reads `/auth/me`; `requireAdmin` handles staff identity, renewal, and redirects. Server roles remain authoritative.
- `src/lib/api/client.ts`, `session.ts`, `renewal.ts`, `endpoints.ts`, and `types.ts` own contracts, session handling, errors, and data fetching. They are outside redesign scope.
- Existing `src/actions/*.actions.ts` retain Server Actions, validation, permission checks, auditing, and backend calls.
- The dashboard and most domains use the NestJS API. Coupons and reviews still use `getAdminServices()` / Supabase and disclose their legacy status. No migration is part of the redesign.
- Monetary strings stay server-formatted where supplied. Payment is separate from order status; cash collection follows the existing delivery transition.

## UI and state architecture

- Root: `src/app/layout.tsx`, `globals.css`, `template.tsx`, `AdminProviders` / existing toast context.
- Shell: `(dashboard)/layout.tsx`, `components/layout/Sidebar.tsx`, `AdminHeader.tsx`, `config/navigation.ts`.
- Existing primitives in `packages/ui/src`: Card, Button, Input, Select, Table, StatusBadge, Pagination, EmptyState, Skeleton, Avatar, Tabs, Radix Dialog/Dropdown, Toast, SectionHeader.
- Domain components contain native form controls, server-result errors, table wrappers, inline forms, modal confirmations, inventory drawer, and local busy state. Their data/action logic stays in place.
- Server components remain responsible for reads. Interactive filters and form components remain clients. The redesign adds reusable presentation wrappers in `apps/admin/src/components/ui` and scopes global styling to `.admin-app`.

## Design contract

Concept 03 uses `#f8f7f4` canvas, `#fffefa` cards, `#efefe7` sidebar, `#292f2c` ink, `#696c65` secondary text, `#e0e2d8` borders, `#3d604c` primary, `#e8eee5` selected surfaces, and peach/sage/slate metric tones. Georgia is the editorial display face; Segoe UI/Arial remains the practical interface face. Cards use 12px corners, controls 6px, restrained shadows, and a 4px spacing scale.

The API supplies aggregates, not a daily revenue time series or period-over-period growth. The production dashboard must visualize existing order-status counts instead of copying the demo's invented line/bar trend or growth percentages. No fabricated notifications, user names, metrics, or records may enter production.

## Verification

Admin TypeScript, ESLint, and Next production build are local checks. Existing Playwright suites exercise auth, identity, lifecycle operations, session renewal, hydration, and unreachable APIs. They require the dedicated loopback `nest-test-*` Mongo replica set and per-run ownership capability defined by the existing test harness; never substitute the development/production database. Responsive visual QA targets 320, 375, 768, 1024, 1280, and 1440px.
