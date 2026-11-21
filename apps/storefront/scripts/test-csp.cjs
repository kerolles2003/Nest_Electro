const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const ts = require('typescript');
globalThis.AsyncLocalStorage = require('node:async_hooks').AsyncLocalStorage;
const { NextRequest } = require('next/server');
const { unstable_doesMiddlewareMatch: unstable_doesProxyMatch } = require('next/experimental/testing/server');
const { chromium } = require('@playwright/test');
const root = path.resolve(__dirname, '../../..');
function load(file, imports = {}) {
  const exports = {};
  const code = ts.transpileModule(fs.readFileSync(file, 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 } }).outputText;
  new Function('exports', 'require', code)(exports, id => imports[id] ?? require(id));
  return exports;
}
const policy = load(path.join(root, 'packages/config/src/content-security-policy.ts'));
const safe = load(path.join(root, 'apps/storefront/src/lib/safe-content.ts'));
const proxies = ['storefront', 'admin'].map(app => ({ app, ...load(path.join(root, `apps/${app}/src/proxy.ts`), {
  '../../../packages/config/src/content-security-policy': policy,
  '@/lib/logger': { logAuthFailure() {}, logAdminAuthFailure() {} },
  '@/lib/api/session': { ADMIN_REFRESH_COOKIE: 'nest_admin_rt' },
  '@/lib/api/renewal': { PATH_HEADER: 'x-admin-path' },
}) }));
let cases = 0;
function check(name, run) { run(); cases++; console.log(`PASS ${name}`); }
const production = policy.contentSecurityPolicy('syntheticNonce123', false, 'https://store.example.invalid');
check('production directive restrictions and exact media hosts', () => {
  for (const directive of ["default-src 'self'", "script-src-attr 'none'", "object-src 'none'", "frame-ancestors 'none'", "form-action 'self'", "connect-src 'self'", "font-src 'self'"]) assert(production.includes(directive));
  assert(!production.includes('*')); assert(!production.includes('unsafe-eval'));
  assert(!production.split(';').find(s => s.trim().startsWith('script-src ')).includes('unsafe-inline'));
  assert(production.includes('https://res.cloudinary.com')); assert(production.includes("style-src 'self' 'unsafe-inline'"));
});
check('development-only evaluation and exact local HMR origin', () => {
  const dev = policy.contentSecurityPolicy('syntheticNonce123', true, 'http://127.0.0.1:3999/login');
  assert(dev.includes("'unsafe-eval'")); assert(dev.includes('ws://127.0.0.1:3999')); assert(!production.includes('ws:'));
});
check('nonce validation prevents directive injection', () => assert.throws(() => policy.contentSecurityPolicy("x'; script-src *", false, 'https://example.invalid')));
const saved = process.env.NODE_ENV;
process.env.NODE_ENV = 'production';
try {
  for (const { app, proxy, config } of proxies) {
    check(`${app}: pages matched, API and assets excluded`, () => {
      const nextConfig = app === 'admin' ? { basePath: '/admin' } : {};
      const prefix = app === 'admin' ? '/admin' : '';
      for (const suffix of ['/login', '/products/sample', '/unknown', '/product.png']) assert(unstable_doesProxyMatch({ config, nextConfig, url: prefix + suffix }));
      for (const suffix of ['/api/session/renew', '/_next/static/a.js', '/_next/image?url=a']) assert(!unstable_doesProxyMatch({ config, nextConfig, url: prefix + suffix }));
    });
    check(`${app}: every guard branch has one enforced policy and fresh trusted nonce`, () => {
      for (const [url, headers] of [
        ['/login', {}], ['/products', {}], ['/account', {}],
        ['/login', { cookie: app === 'admin' ? 'nest_admin_rt=synthetic' : 'nest_rt=synthetic' }],
        ['/account', { 'next-action': 'synthetic' }],
      ]) {
        const request = new NextRequest('https://store.example.invalid' + url, { headers: { ...headers, 'x-nonce': 'attacker', 'Content-Security-Policy': 'script-src *' } });
        const response = proxy(request); const header = response.headers.get('Content-Security-Policy');
        assert(header); assert(!header.includes('attacker')); assert(!header.includes('*'));
        assert(!header.includes('unsafe-eval')); assert(!response.headers.has('Content-Security-Policy-Report-Only'));
        const second = proxy(request).headers.get('Content-Security-Policy'); assert.notEqual(header, second);
        if (!response.headers.has('location')) {
          assert.equal(response.headers.get('x-middleware-request-content-security-policy'), header);
          assert(header.includes(`nonce-${response.headers.get('x-middleware-request-x-nonce')}`));
        }
      }
    });
  }
} finally { if (saved === undefined) delete process.env.NODE_ENV; else process.env.NODE_ENV = saved; }

(async () => {
  const browser = await chromium.launch({ channel: 'chrome', headless: true });
  try {
    const page = await browser.newPage();
    await page.route('**/*', route => {
      if (route.request().url() !== 'https://csp.example.invalid/') return route.abort();
      const json = safe.serializeJsonLd({ name: '</script><script>window.injected=true</script>' });
      return route.fulfill({ contentType: 'text/html', headers: { 'Content-Security-Policy': production }, body: `<!doctype html><p style="color:rgb(255, 0, 0)">Safe</p><script nonce="syntheticNonce123">window.allowed=true</script><script>window.injected=true</script><script nonce="syntheticNonce123" type="application/ld+json">${json}</script><button onclick="window.injected=true">Blocked handler</button>` });
    });
    await page.goto('https://csp.example.invalid/'); await page.locator('button').click();
    assert.deepEqual(await page.evaluate(() => ({ allowed: window.allowed, injected: !!window.injected, color: getComputedStyle(document.querySelector('p')).color, json: JSON.parse(document.querySelector('[type="application/ld+json"]').textContent).name })),
      { allowed: true, injected: false, color: 'rgb(255, 0, 0)', json: '</script><script>window.injected=true</script>' });
    cases++; console.log('PASS Chromium enforced policy: nonce script, blocked inline/handler, CSS and JSON-LD data');
  } finally { await browser.close(); }
  console.log(`PASS: ${cases} CSP cases (proxy/policy contracts plus Chromium fixture; not Next runtime certification).`);
})().catch(error => { console.error(error); process.exitCode = 1; });
