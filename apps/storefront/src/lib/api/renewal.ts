/**
 * Where a page sends the browser when its access token has expired, and how
 * it gets back afterwards. Mirrors the admin console's renewal module —
 * the storefront has no base path, so paths here are already absolute.
 *
 * ## Why a redirect and not a refresh in place
 *
 * Renewing means writing two cookies, and there are exactly two places in a
 * Next application allowed to do that: a Server Action and a Route Handler.
 * A page render is neither — it throws — which was F01: `apiFetch` refreshed
 * during rendering, the API had already ROTATED (burned) the old refresh
 * token, the cookie write threw, and the session was destroyed; reuse of
 * the burned token could then trigger the API's theft revocation.
 *
 * A redirect is single-flight by construction: one request goes to the
 * renewal route, it renews once, and it sends the browser back.
 *
 * ## Deliberately dependency-free
 *
 * No `server-only`, no `next/headers`. `proxy.ts` imports `PATH_HEADER`,
 * and middleware runs in a context where neither of those exists.
 * Everything here is a pure string function.
 */

/** The route that renews. */
export const RENEWAL_PATH = '/session/renew';

/** The header `proxy.ts` writes so a Server Component knows where it is. */
export const PATH_HEADER = 'x-storefront-path';

/** Where to send somebody whose `next` cannot be trusted or is missing. */
const FALLBACK = '/';

/**
 * A local path, or the home page.
 *
 * The `next` parameter decides where a browser lands after renewing, so it
 * is an open redirect unless it is checked. Anything that is not a
 * single-slash absolute path is discarded rather than corrected —
 * `//evil.example` is a protocol-relative URL, and a value containing a
 * scheme is not a path at all.
 */
export function safeNextPath(raw: string | null | undefined): string {
  if (raw === null || raw === undefined || raw.length === 0) return FALLBACK;
  if (!raw.startsWith('/') || raw.startsWith('//')) return FALLBACK;
  if (raw.includes('\\') || /^\/[a-z][a-z0-9+.-]*:/i.test(raw)) return FALLBACK;

  return raw;
}

/** The URL a page redirects to in order to renew and come back. */
export function renewalUrl(next: string): string {
  return `${RENEWAL_PATH}?next=${encodeURIComponent(safeNextPath(next))}`;
}
