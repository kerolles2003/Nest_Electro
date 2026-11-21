# Test Evidence — Adversarial Audit Session (2026-11-21)

Exact commands, environments, counts and limitations. Starting HEAD
`1a9d76f2cfca31adc0379bf550b545c0490de045` (17 commits over base
`bb7c331`). Nothing in this document is estimated; every number was
observed in this session.

## Environment

- Sandbox VM: 1.5 shared CPUs, 6 GB RAM. All timings below carry
  that constraint; relative comparisons are meaningful, absolute
  browser timings are not.
- MongoDB 7.0.24, single-node replica set `nest-test-rs0`,
  127.0.0.1:27018 (project test harness scratch databases only;
  no development or production database was touched).
- Node 24, pnpm 9.0.0 (shim), Playwright Chromium 1234
  (headless shell), axe-core 4.11.3 (already in the dependency tree).
- Jest harness env: `NEST_TEST_MONGODB_URI` pointing at the replica
  set, throwaway random `JWT_SECRET` per run, `NODE_ENV=test`.

## New adversarial suites written for this audit

Command pattern (each):
`cd apps/api && npx jest <path> --runInBand` with the harness env.

| Suite | Tests | Result |
| --- | --- | --- |
| `test/checkout/payment-adversarial.spec.ts` | 11 | 11/11 pass after fixes (2 failed before: self-approval 200 vs expected 403; resubmit-on-cancelled 200 vs expected refusal) |
| `test/security/security-adversarial.spec.ts` | 14 | 14/14 pass |
| `test/database/integrity-adversarial.spec.ts` | 4 | 4/4 pass |
| `test/checkout/manual-payment.spec.ts` (pre-existing, regression check after the payment fixes) | 11 | 11/11 pass |

## Full regression

`cd apps/api && npx jest --runInBand` (all suites, real replica set):
**72 of 73 suites ran: 71 passed, 1 skipped, 1 failed; 1461 of 1477
tests passed, 15 skipped, 1 failed.** The single failure was
`test/infrastructure/money-formatting.spec.ts`, caused by this
session's own accessibility fix: the new `aria-valuetext` lines in
`FilterSidebar.tsx` put a currency symbol beside a
`toLocaleString()` value, which the project's money-formatting gate
flags unless a written allowance is registered (the mechanism the
project itself uses for the identical visible chips in the same
file). Two allowances with justifications were registered and the
gate suite re-run standalone: **4/4 pass**, including its
stale-allowance check. No other suite was affected by the change
(the edit touches only that spec's allowance list), so the full run
was not repeated for it.

Type-checks after all session changes: api `tsc --noEmit` exit 0;
storefront `tsc --noEmit` exit 0. Storefront production build after
the FilterSidebar change: success (new BUILD_ID issued). OpenAPI
drift gate after the payment-service changes:
`pnpm --filter api openapi:check` → "drift gate: OK".

## Production-mode Playwright probes (temporary, removed after use)

Method: the projects' own Playwright configs were copied with the
Next server command swapped from `next dev` to `next start`
(production builds), `NEXT_DIST_DIR` pointed at the real `.next`,
and a single probe spec each. Probe files were deleted after the
runs; `git status` verified clean.

- **Storefront probe** (API + storefront, both production builds,
  suite database `storefront-e2e`): 2/2 probe tests passed.
  - Product page (`/products/usb-logic-analyser-8-channel`): zero
    hydration errors; 2 JSON-LD scripts, both with content.
  - Catalogue (`/products`): 7 images rendered (some external image
    requests fail in this sandbox with proxy tunnel errors and are
    excluded by construction); every loaded image had computed
    opacity 1, before and after scrolling.
- **Admin probe** (API + admin, production builds, suite database
  `admin-e2e`): the probe test FAILED on its assertions, which is
  the finding — 1 CSP violation recorded (chunk
  `09s5_6c4yp62j.js` blocked under `strict-dynamic`), and the user
  menu never became interactive ("Sign out" not visible after
  10 s). Screenshot retained in the run output at the time.

For comparison, session 2's dev-mode runs: storefront 97/105,
admin 13/33 with 168 CSP violations.

## Accessibility measurement

Method: production storefront (`next start`) + production API on a
seeded scratch database; axe-core 4.11.3 injected via Playwright
`addScriptTag`; `axe.run(document, { resultTypes: ['violations'] })`
on 6 public pages.

| Page | Violations (rule × axe impact × nodes) |
| --- | --- |
| `/` | color-contrast serious ×51; image-redundant-alt minor ×6 |
| `/products` | color-contrast serious ×55; label critical ×2 (pre-fix run) |
| `/products/esp32-devkit-v1` | color-contrast serious ×25 |
| `/login` | color-contrast serious ×9; heading-order moderate ×2 |
| `/register` | color-contrast serious ×8; heading-order moderate ×2 |
| `/cart` | color-contrast serious ×7; heading-order moderate ×1 |

Post-fix re-run (after `d00b69f`): `/products` shows **no `label`
violations**; color-contrast persists on the other pages (51/25/9/8/7
nodes). Variance note: one `/products` re-run reported
document-title/landmark/region findings instead of contrast —
axe results vary with which UI regions are mounted when the audit
runs; the stable signals across runs are color-contrast (5 of 6
pages, both rounds) and the label defect (present before, absent
after). Measured contrast example: `#ffffff` on `#e14a5c`, 3.93:1
vs 4.5:1 required.

## Performance measurement

- **API timings**: production API build against the seeded
  `storefront-e2e` scratch database; `curl` total time, 9 sequential
  warm requests per endpoint, median reported.
  `GET /products` 8.1 ms; `GET /products?limit=100` 8.9 ms;
  `GET /products/:slug` 4.2 ms; `GET /products?q=esp32` 4.7 ms;
  `GET /products?category=development-boards` 4.9 ms;
  `GET /categories` 1.4 ms; `GET /health` 1.1 ms.
  Limitation: seed-scale data (tens of products) on localhost —
  these numbers say the code paths are not pathologically slow;
  they say nothing about production data volumes.
- **Bundle sizes**: measured from the production builds' chunk
  directories (uncompressed, all chunks): storefront 956 kB across
  36 JS files (largest 227 kB); admin 1076 kB across 31 files
  (largest 227 kB). Not per-route first-load figures.
- **Lighthouse**: not available in this environment; not run.

## Release-engineering checks

- Env validation: booting the API with `JWT_SECRET` unset fails
  immediately with "Configuration invalid — JWT_SECRET: Invalid or
  missing value"; same for `MONGODB_URI`. Fail-fast, named, no
  partial boot.
- Security headers (real built server, `curl -I /api/v1/health`):
  `Content-Security-Policy: default-src 'none'; frame-ancestors
  'none'`, HSTS `max-age=31536000; includeSubDomains`,
  `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`,
  `Referrer-Policy: strict-origin-when-cross-origin`, CORP/COOP
  `same-origin`.
- CORS: preflight from `https://evil.example` and from an
  unconfigured localhost origin both return **no**
  `Access-Control-Allow-Origin`. `CORS_ORIGINS` defaults to empty
  by design (server-to-server topology); fails closed.
- CI (`.github/workflows/ci.yml`, read in full): jobs lint,
  type-check, build, transaction-gate (runs the FULL Jest suite:
  `pnpm --filter api test`, against the CI-named replica set with a
  per-run throwaway `JWT_SECRET`), contract-gate (OpenAPI page +
  drift checks). `permissions: contents: read`; no
  `continue-on-error`; no secrets referenced. **No Playwright job
  exists** — browser behaviour is not gated anywhere.
- Dependency audit: `pnpm audit` could NOT be executed — the
  sandbox's registry proxy denies the audit endpoint (HTTP 403,
  policy_denied). Recorded as not verified, not as clean.

## Limitations of this evidence

- All browser work ran on 1.5 shared CPUs; dev-mode Playwright
  numbers from session 2 and these probes are classification
  evidence, not performance data.
- The admin probe exercised login, the orders page, and the user
  menu only — ADV-1 blocks deeper browser verification of the
  console.
- No coverage percentages were collected (a coverage run was not
  performed); suite/test counts are reported instead.
