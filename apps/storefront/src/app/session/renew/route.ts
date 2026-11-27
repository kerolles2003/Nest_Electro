import { NextResponse, type NextRequest } from 'next/server';
import { renewSession } from '@/lib/api/client';
import { safeNextPath } from '@/lib/api/renewal';
import {
  clearSession,
  markRenewalAttempted,
  readSession,
  writeSession,
} from '@/lib/api/session';

/**
 * The ONE place the storefront renews a session (F01).
 *
 * ## Why it is a route handler and not part of a page
 *
 * Renewing writes two cookies, and Next's documentation is unambiguous:
 * "Setting cookies is not supported during Server Component rendering. To
 * modify cookies, invoke a Server Function from the client or use a Route
 * Handler."
 *
 * The storefront used to renew inside `apiFetch`, which pages call while
 * rendering. The write threw — after the API had already rotated the
 * refresh token and burned the old one — so the browser went on presenting
 * a dead credential until the API revoked the family for reuse. A crash
 * followed by a silent sign-out, from nothing but leaving a tab open for
 * fifteen minutes.
 *
 * ## Why not middleware, which can also write cookies
 *
 * Middleware runs on every request a page load makes, including the RSC
 * prefetches a hovered link fires. The refresh token ROTATES on every use,
 * so two concurrent renewals burn each other and the API — correctly —
 * reads the loser as theft. A redirect is single-flight by construction:
 * one request arrives here, one renewal happens, the browser goes back.
 *
 * ## What protects `next`
 *
 * It decides where a browser lands, so an unchecked value is an open
 * redirect. `safeNextPath` accepts only a single-slash local path and
 * discards everything else rather than trying to repair it.
 */
export async function GET(request: NextRequest): Promise<NextResponse> {
  const next = safeNextPath(request.nextUrl.searchParams.get('next'));
  const session = await readSession();

  /*
   * The marker goes down BEFORE the outcome is known, and deliberately.
   *
   * It answers "has renewal just been attempted", not "did it work". If
   * this request dies half way — the API times out, the process is killed
   * — the next expiry must still find the breadcrumb and degrade to
   * signed-out rather than starting the loop over.
   */
  await markRenewalAttempted();

  if (session === null) return redirectTo('/login');

  const renewed = await renewSession(session.refreshToken);

  if (renewed === null) {
    /*
     * The refresh token is gone, revoked, or already burned. Nothing here
     * can recover it, and leaving the cookies in place would make every
     * subsequent navigation repeat this round trip.
     */
    await clearSession();

    return redirectTo('/login');
  }

  await writeSession({
    accessToken: renewed.accessToken,
    refreshToken: renewed.refreshToken,
  });

  return redirectTo(next);
}

/**
 * A RELATIVE redirect. Legal per RFC 7231, and resolved by the browser
 * against the URL it actually requested — building an absolute URL from
 * `request.url` risks silently moving the customer between origins
 * (`localhost` vs `127.0.0.1` are different origins to a cookie jar).
 *
 * 303, not 307: the browser must GET the destination.
 */
function redirectTo(path: string): NextResponse {
  return new NextResponse(null, { status: 303, headers: { Location: path } });
}
