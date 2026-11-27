# ADV-1 Remediation Report — Admin production CSP blocks a chunk

Date: 2026-11-21 (remediation session, following the adversarial audit)
Branch: `muse/autonomous-engineering` — changes are in the working tree,
uncommitted, per the mission's staging restriction.
Build under test: `next build` + `next start` (production), Next 16.2.4
(Turbopack), against a real API + seeded scratch database.

## Root cause (measured, not inferred)

The policy itself is correct and was never the problem: the admin
proxy mints a per-request nonce and serves
`script-src 'self' 'nonce-…' 'strict-dynamic'`.

On a **cold full-page load** of every dashboard sub-route, exactly one
script was blocked. Raw server HTML for `/admin/orders` (before the
fix) shows why:

- 15 `<script>` tags carry `nonce="<the request nonce>"`.
- Exactly one does not: `…/chunks/09s5_6c4yp62j.js`, emitted with no
  nonce attribute at all. CDP attributes the request to the **parser**
  — it is a server-emitted tag, not a runtime insertion.

That chunk contains exactly one application module: `RefreshButton`
(`apps/admin/src/components/ui/refresh-button.tsx`). It is the
console's only client leaf hanging off a **server module**
(`components/ui/admin.tsx`) that every dashboard page imports for
`PageHeader` / `ErrorState`. Turbopack assigns it a dedicated chunk,
and the server renderer hoists that chunk's script tag through
React's preinit path, which in Next 16.2.4 emits it **without the
request nonce**. Under `strict-dynamic` the browser refuses to
execute it: the component is dead on cold loads (its host pages still
render, because the tag is advisory until something needs the chunk —
which is why the failure looked like "some controls randomly dead"
rather than a blank page).

The Turbopack client runtime compounds the same class of problem for
purely dynamic loads (its chunk loader creates script elements with
no nonce handling at all), but the observed production failure is
the parser-inserted tag above.

### Before evidence (production build, cold load, fresh context per route)

| Route | CSP violations | Blocked URI |
|-------|----------------|-------------|
| /admin | 0 | — |
| /admin/orders, /products, /customers, /categories, /brands, /inventory, /coupons, /reviews, /audit-log, /settings | **1 each** | `09s5_6c4yp62j.js` (`script-src-elem`) |

Console: `Loading the script '…09s5_6c4yp62j.js' violates the
following Content Security Policy directive: "script-src 'self'
'nonce-…' 'strict-dynamic'"` on each of those routes.

## The fix

**One import added** to `apps/admin/src/app/(dashboard)/layout.tsx`:

```ts
import "@/components/ui/refresh-button";
```

with a comment marking it load-bearing. Registering the module in the
dashboard layout's client graph makes Turbopack fold the chunk into
the shell's standard script set — the set the renderer emits **with**
the request nonce on every dashboard page. The un-nonced per-page
hoisted tag disappears (the dedicated chunk no longer exists in the
build output at all). The component is still rendered by
`PageHeader` / `ErrorState`, exactly as before; no UI changed, and
**the CSP was not touched**: no `unsafe-inline`, no `unsafe-eval`,
no directive removed, `strict-dynamic` intact.

### Why not the alternatives

- *Weaken the CSP* (drop `strict-dynamic`, add `unsafe-inline`):
  explicitly prohibited, and unnecessary.
- *Set `__webpack_nonce__`*: that is the webpack runtime's hook; this
  build is Turbopack, whose runtime contains no nonce handling
  (verified by inspection of the emitted runtime chunk).
- *Patch script creation at runtime*: fragile monkey-patching of
  `document.createElement` in production code; the defect is at
  emission time, not insertion time.
- *Emit the chunk tag manually with the nonce*: requires hardcoding a
  build-hash filename in source; breaks on every rebuild.

## After evidence (production build, same probe)

- **CSP violations: 0 on all 11 routes** (dashboard + 10 sub-routes),
  cold load, fresh context per route.
- Raw HTML for `/admin/orders`: **15/15 script tags carry the
  request nonce.**
- **Sign out works end-to-end**: user menu opens, "Sign Out" is
  visible, clicking it lands on `/admin/login`. (This is the exact
  flow the audit found dead.)
- **The formerly blocked component is alive**: with the API stopped,
  `/admin/orders` renders its `ErrorState` ("The order queue could
  not be loaded"); clicking its `RefreshButton` ("Try again") puts
  the button into its pending state ("Refreshing…") and fires the
  RSC refresh requests — proof the handler executes, not merely that
  the tag loads.
- **Policy unchanged**: response header still
  `script-src 'self' 'nonce-…' 'strict-dynamic'` with
  `script-src-attr 'none'`, `object-src 'none'`,
  `frame-ancestors 'none'`, etc.

## Pre-existing issues observed, unchanged by this fix

- `/admin/coupons` and `/admin/reviews` log a Server Components
  render error in production (legacy Supabase-era domains). Present
  identically before and after the fix; unrelated to CSP and out of
  this mission's scope (see ADV-3 in `MUSE_ADVERSARIAL_AUDIT.md`).

## Residual risk

The fix removes the *observed* defect by construction for the one
module that exhibited it. The underlying framework behaviour —
a lone client leaf under a server module getting a dedicated chunk
whose hoisted tag loses the nonce — could recur if a future change
introduces another such leaf outside the layout graph. Two cheap
guards, recommended in `MUSE_REMAINING_WORK.md`: run the admin
Playwright suite against a **production** build in CI (ADV-5), and
treat any new `securitypolicyviolation` in that run as a failure.
The layout comment also warns against removing the import as
"unused".
