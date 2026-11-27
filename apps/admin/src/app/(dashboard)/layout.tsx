import { AdminSidebar } from "@/components/layout/Sidebar";
import { AdminHeader } from "@/components/layout/AdminHeader";
import { readAdminIdentity } from "@/lib/api/identity";

/*
 * ADV-1 (CSP remediation): this import is load-bearing, do not remove it
 * as "unused".
 *
 * `RefreshButton` is the console's only client leaf hanging off a server
 * module (`components/ui/admin.tsx`, imported by every dashboard page
 * for `PageHeader`). Turbopack gives it a dedicated chunk, and the
 * server renderer hoists that chunk's <script> tag through React's
 * preinit path — which, in Next 16.2.4, emits it WITHOUT the request
 * nonce. Under the console's `script-src 'self' 'nonce-…' 
 * 'strict-dynamic'` policy the browser refuses to execute it, so the
 * button (and anything sharing its chunk) is dead on a cold page load.
 *
 * Registering the module in this layout's client graph makes the chunk
 * part of the shell's standard script set, which the renderer emits
 * WITH the nonce on every dashboard page; the per-page hoisted tag
 * then dedupes against the already-present script and is never emitted.
 * The component itself is rendered by `PageHeader`, not here.
 */
import "@/components/ui/refresh-button";

/**
 * The console shell.
 *
 * ## Where the server-side role check happens
 *
 * `readAdminIdentity()` is `GET /auth/me` against the API. It is the only thing
 * in this application that decides who is operating the console, and it decides
 * it from the SERVER's answer — nothing here decodes a token, and no `role`
 * claim is read in the browser. `proxy.ts` checks only that a session cookie
 * exists, which is a navigation convenience and explicitly not the boundary.
 *
 * This layout is the right place for the real check: it renders once per
 * navigation (a proxy runs on every parallel request a page load makes, and
 * refreshing a ROTATING token from several of those at once is how a valid
 * session gets destroyed), and it already needs the identity to draw the
 * header, so the call costs nothing extra.
 *
 * The API's `RolesGuard` remains the enforcement. Everything decided here is
 * about what to RENDER: a non-staff token gets refused on every `admin/*` route
 * whatever this concludes.
 *
 * ## Why it does not redirect
 *
 * `readAdminIdentity()` returns `null` for three different situations — no
 * session, a session the API rejected, and an API that could not be reached —
 * and only the first two are grounds for sending somebody to the sign-in page.
 * Bouncing an operator to `/login` because the API hiccuped for one request
 * would look exactly like being signed out, and they would sign in again to fix
 * a problem that was never theirs.
 *
 * So the shell renders and the header says the identity is unavailable, naming
 * nobody. The PAGES inside call `requireAdmin()`, which redirects; that is the
 * guard, and it runs for every route under this layout.
 */
export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const identity = await readAdminIdentity();

  return (
    <div className="admin-shell">
      <a className="admin-skip" href="#admin-main">Skip to main content</a>
      <AdminSidebar identity={identity} />
      <div className="admin-workspace">
        <AdminHeader identity={identity} />
        <main id="admin-main" className="admin-main" tabIndex={-1}>
          {children}
        </main>
      </div>
    </div>
  );
}
