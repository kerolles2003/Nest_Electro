# Nest Electronics — Admin design exploration

Phase 1 only. Four isolated, interactive HTML concepts for choosing a visual direction. No production routes, components, styles, APIs, authentication, databases, or business logic are imported or changed by this playground.

## Open the comparison

Double-click `index.html` in this folder, or use your browser's **Open file** command. No server, build, installation, account, or internet connection is required.

Full path: `D:\eng-mina\nest-electronics\admin-redesign-exploration\index.html`

Each concept is also a single self-contained HTML file with embedded CSS, JavaScript, icons, and charts. Copy one `index.html` anywhere to preview it independently. Its “All four concepts” link expects the original folder structure.

| Concept | File | Design direction |
| --- | --- | --- |
| 01 — Premium Minimal | [Open](concept-01-premium-minimal/index.html) | Quiet neutral surfaces, violet accent, open analytics area, compact navigation, restrained cards. |
| 02 — Dark Command Center | [Open](concept-02-dark-command-center/index.html) | Deep blue-gray surfaces, cyan signals, monospaced metrics, segmented KPI strip, persistent pipeline/activity rail. |
| 03 — Editorial / Human-Centered | [Open](concept-03-editorial-human/index.html) | A daily brief, serif headings, warm task surfaces, forest-green accents, grouped bars, comfortable reading rhythm. |
| 04 — Data-First Professional | [Open](concept-04-data-first/index.html) | Compact navy navigation, queue-first layout, exposed filters, bulk selection, contextual order detail, secondary analytics below. |

## What to try

- Search for Ahmed, Cairo, or NE-1048. Enter a nonexistent name to see the filtered empty state.
- Filter order status, payment, and dates. Sort by value or date, change pages, and reset filters.
- Select visible orders and export a sample CSV. Export is the bulk action; no bulk status changes are implied.
- Open an order to inspect its payment, amount, and timeline. Dialogs support Escape and return focus.
- Use the navigation to see small catalog, inventory, customer, review, coupon, audit, and settings previews.
- Open **New product**, validate the fields, and create a sample draft. See the draft in **Products** until the page reloads.
- Open notifications, mark them as read, or inspect the user dropdown.
- Switch the revenue period. The revenue summary changes; all-time queue counts stay unchanged.
- Scroll to **Designed for every state** for empty, loading, recoverable error, and toast examples.
- Resize to mobile. Navigation becomes a keyboard-accessible drawer; tables scroll inside their own container.

All identities, records, alerts, values, charts, and timestamps are illustrative fixtures, not real store data. Changes live only in page memory. Charts are visual explorations, not a promise that the production API exposes the proposed analytics. Navigation module previews demonstrate the visual language rather than complete replacement pages.

## Inspection notes

The implementation was grounded in the current admin source before creating these demos:

- `apps/admin/src/config/navigation.ts`: Dashboard; Products, Categories, Brands, Inventory; Orders, Coupons; Customers, Reviews; Audit Log, Settings. The concepts keep these destinations and explore grouping and emphasis.
- `apps/admin/src/app/(dashboard)`: overview, product list/create/edit, order queue/detail, inventory, categories, brands, customers, reviews, coupons, audit log, and settings. Production uses the `/admin` base path. Login, unauthorized, session renewal, and error/loading routes remain outside this playground.
- `components/layout/Sidebar.tsx` and `AdminHeader.tsx`: grouped navigation, mobile drawer, profile identity, search, breadcrumbs, notification popover, and account dropdown. Production deliberately has no fabricated notification feed; these demos explicitly label sample alerts.
- Dashboard overview: delivered revenue with a trailing window; order queues that are unbounded by that window; catalog/customer counts; recent orders, low stock, and audit activity. The demo charts are added visual studies using local fixtures.
- `components/orders/OrdersTable.tsx`, `QueueFilters.tsx`, and `OrderDetail.tsx`: placed, confirmed, shipped, delivered, delivery failed, cancelled, returned; payment remains a separate axis. The demos retain cash-on-delivery semantics. They do not introduce payment editing.
- `components/products/ProductForm.tsx`, `ProductImageManager.tsx`, and `ProductSpecsEditor.tsx`: product details, SKU, bilingual fields, prices, categories/brands, media/specifications, separate publishing, and inventory ownership. The small demo form creates an unpublished local draft.
- `components/inventory/InventoryAdjustDialog.tsx` and `InventoryHistoryDrawer.tsx`: movement type, quantity, reason, and history. No stock mutation is wired into the demos.
- `packages/ui/src`: buttons, inputs, selects, cards, tables, pagination, status badges, skeletons, empty states, dialogs, dropdowns, avatars, toasts, tabs, breadcrumbs, and section headers.
- `apps/admin/src/app/globals.css` and `layout.tsx`: existing dark-only tokens (`#0f1117` background, `#1a1d27` cards, `#3b82f6` primary), Inter / Space Grotesk / JetBrains Mono, and 4/8/12px radii. The light concepts are deliberate isolated alternatives requested for Phase 1; no global production theme is changed.

## Source and maintenance

- `build.mjs` assembles each standalone demo and the selector.
- `source/styles.css` contains the shared mechanics and four separately scoped design systems.
- `source/interactions.js` contains local fixtures and browser-only interactions.
- `previews/` contains actual desktop/mobile screenshots and the browser verification summary.
- System font stacks keep the demos offline: Segoe UI/Arial for interface text, Georgia for editorial display, Consolas for command-center numerals.

To regenerate the standalone HTML after editing the source:

```powershell
node admin-redesign-exploration/build.mjs
```

Optional browser verification uses the repository's existing Playwright installation; it does not install packages or run the production apps:

```powershell
node admin-redesign-exploration/verify.cjs
```

Verification covers Chromium at 1440, 1024, 768, 390, and 320px widths, page overflow, search, empty results, status filtering, sorting, pagination, selection, CSV export, dialogs, draft creation, menus, mobile navigation, simulated loading/retry, and revenue-period scope. All four pages make zero HTTP requests. The selector checks all preview images and four demo links. This is prototype QA, not a full production accessibility or cross-browser certification.

## Phase boundary

The next step is the owner's choice of direction. Phase 2 implementation across the real admin has not started.
