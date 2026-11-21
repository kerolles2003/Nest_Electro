# Concept 03 implementation

The real admin application now uses the Editorial / Human-Centered direction from `admin-redesign-exploration/concept-03-editorial-human`. Architecture and preservation boundaries are recorded in the root `CODEBASE_MAP.md`. `changed-files.txt` lists the redesign's frontend files and excludes the pre-existing image/action/API edits.

## Scope

The overview, products list/new/edit, orders list/detail, inventory, categories, brands, customers, coupons, reviews, audit log, shipping settings, login, unauthorized page, and 404 share the same visual system. Loading boundaries and error recovery use the same surfaces and type hierarchy. The global error fallback uses the warm palette even when the root stylesheet cannot load.

The redesign does not modify backend code, action handlers, API contracts, queries, schemas, roles, sessions, routes, validation rules, environment files, or production configuration. Existing unrelated edits remain in place. No dependencies were added. Existing shared UI components remain available to the storefront with their original source unchanged.

## Design system

- Canvas `#f8f7f4`, surface `#fffefa`, sidebar `#efefe7`, ink `#292f2c`, secondary text `#62675f` (slightly stronger contrast than the demo), border `#e0e2d8`, forest accent `#3d604c`.
- Peach `#ecd5c5`, sage `#e6ecdf`, slate `#e8eceb`, and rose `#f1e9e3` support the operational metrics.
- Georgia display headings/numbers; Segoe UI/Arial interface text; Consolas identifiers. System fonts avoid a network dependency.
- 12px surfaces, 6px controls, restrained shadows, visible forest focus outlines.
- Admin-only presentation primitives: `PageHeader`, `SectionHeader`, `AdminCard`, `StatCard`, `FilterBar`, `TableScroll`, `LoadingState`, `ErrorState`, `RefreshButton`, `ActivityItem`, `ChartContainer`, `AdminDialog`, `FormField`, and an admin adapter for `StatusBadge`.
- Existing Button, Input, Avatar, Pagination, EmptyState, Toast, and Radix menu/dialog primitives are reused. Tailwind explicitly scans shared UI source so portal and control styles are generated.

## Responsive and accessible behavior

The sidebar becomes a focus-trapped drawer below 1024px. Cards reflow, mobile form controls use readable type, and wide tables scroll inside labeled keyboard-focusable regions. Filters wrap; the page itself does not scroll horizontally. The product save controls follow its fields in source and keyboard order.

The shell includes a skip link, current-route markers, and labeled menu controls. Dialogs provide a title, description, Escape dismissal, trapped focus, and focus return. Product, taxonomy, specification, search, review status, and inline shipping controls have accessible labels; existing validation feedback is associated with relevant fields. Reduced-motion preferences are respected. Header search uses the existing order query; Ctrl/Cmd K focuses it. Sign-out keeps the existing Server Action and is keyboard-operable.

## Validation

- TypeScript: passed.
- ESLint: passed with 0 errors and 32 existing warnings (legacy `any`, effect synchronization, and unused values; not suppressed).
- Production build: passed, including all existing routes.
- Responsive visual QA: `visual-qa-results.json` records 17 page/fallback views at 320, 375, 768, 1024, 1280, and 1440px, plus empty/error checks on 11 data pages. Screenshots are generated locally in `screenshots/`.
- Interaction QA: `interaction-qa-results.json` records dialog bounds, focus trapping/return, Escape, mobile navigation, query filters, specification editing, and shipping inline editing. Notification/profile menus and keyboard sign-out were also checked.
- API/action call inventory: `preservation-check.json` records unchanged API, guard, and mutation call expressions across 24 touched frontend files. This check is deliberately narrower than a workflow test.
- Both existing Playwright configurations were attempted against a dedicated disposable loopback MongoDB replica set. Both stop before test execution: `CustomersAdminService` cannot resolve `TransactionService` in `UsersModule` while the API starts. **The real API workflow suite has not passed.** No backend change was made to bypass this failure.

## Architecture limits

The API supplies revenue aggregates and order-status counts, but no daily revenue series or growth comparison. The dashboard therefore visualizes the real status distribution and retains the existing revenue period controls. There are no invented trends, users, or records in application code.

Coupons/reviews retain their existing legacy service and their notices explaining that changes are not live on the storefront. There is no notification feed or additional profile, report, or payment route; none was fabricated. The new route error boundary and global error fallback were source-reviewed; service failure states were exercised through the local fixture service.

## Reproduce presentation QA

These scripts are outside the application and are **presentation fixtures only**, not integration tests. They never access a database. The fixture service is bound to loopback and refuses mutations except its simulated session endpoints. Do not point it at any real account or service.

1. From the repository root, run `node docs/admin-redesign/qa-service.cjs`.
2. In a separate PowerShell terminal, run the isolated admin preview:

```powershell
cd apps/admin
$env:API_BASE_URL = 'http://127.0.0.1:3411/api/v1'
$env:NEXT_PUBLIC_SUPABASE_URL = 'http://127.0.0.1:3411'
$env:NEXT_PUBLIC_SUPABASE_ANON_KEY = 'local-visual-fixture'
$env:NEXT_DIST_DIR = '.next-editorial-qa'
$env:DEV_ORIGIN_HOST = '127.0.0.1'
node node_modules/next/dist/bin/next dev --hostname 127.0.0.1 --port 3410
```

3. From the root, run `node docs/admin-redesign/visual-qa.cjs`, then `node docs/admin-redesign/interaction-qa.cjs` sequentially. They share the fixture scenario switch.
4. Stop both servers. Next may add the temporary output directory to `tsconfig.json`; remove only those generated include entries after QA, retaining existing configuration.

For the real workflow suite, follow the existing project test harness and supply its dedicated loopback `NEST_TEST_MONGODB_URI`. Fix the backend startup dependency in its own task before treating this redesign as fully integration-verified.
