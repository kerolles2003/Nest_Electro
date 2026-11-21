/** Browser policy only: API/provider calls run on the Next server, not in the browser. */
export function contentSecurityPolicy(nonce: string, development: boolean, requestUrl: string): string {
  if (!/^[A-Za-z0-9+/=_-]+$/.test(nonce)) throw new Error('Invalid CSP nonce');
  const websocket = new URL(requestUrl);
  websocket.protocol = websocket.protocol === 'https:' ? 'wss:' : 'ws:';
  return [
    "default-src 'self'",
    `script-src 'self' 'nonce-${nonce}' 'strict-dynamic'${development ? " 'unsafe-eval'" : ''}`,
    "script-src-attr 'none'",
    // React style props, Framer Motion/Radix positioning, and Next development styles.
    // This exception is CSS-only; executable inline scripts still require a nonce.
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' data: blob: https://res.cloudinary.com https://images.unsplash.com https://ampere-electronics.com https://placehold.co https://quhllllvwwuizjfrxvdz.supabase.co",
    "font-src 'self'",
    `connect-src 'self'${development ? ` ${websocket.origin}` : ''}`,
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
    "frame-src 'none'",
  ].join('; ');
}

/** Replace client-supplied nonce/CSP values before Next extracts the script nonce. */
export function cspRequest(headers: Headers, requestUrl: string, development: boolean) {
  const nonce = crypto.randomUUID().replaceAll('-', '');
  const policy = contentSecurityPolicy(nonce, development, requestUrl);
  const forwarded = new Headers(headers);
  forwarded.set('x-nonce', nonce);
  forwarded.set('Content-Security-Policy', policy);
  forwarded.delete('Content-Security-Policy-Report-Only');
  return { forwarded, policy };
}
