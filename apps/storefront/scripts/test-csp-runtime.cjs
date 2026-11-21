// Production Next builds in a fresh, run-owned COPY. No real API, database or provider.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const http = require('node:http');
const { randomUUID } = require('node:crypto');
const { spawn } = require('node:child_process');
const { chromium } = require('@playwright/test');
const root = path.resolve(__dirname, '../../..');
const run = path.join(root, 'apps/storefront/.next', `csp-remediation-${randomUUID()}`);
fs.mkdirSync(run, { recursive: true });
const copy = (from, to) => { if (fs.existsSync(from)) fs.cpSync(from, to, { recursive: true }); };
for (const app of ['storefront', 'admin']) {
  const dir = path.join(run, 'apps', app); fs.mkdirSync(dir, { recursive: true });
  for (const name of ['src', 'public', 'next.config.ts', 'tsconfig.json', 'next-env.d.ts', 'package.json', 'postcss.config.mjs']) copy(path.join(root, 'apps', app, name), path.join(dir, name));
  fs.symlinkSync(path.join(root, 'apps', app, 'node_modules'), path.join(dir, 'node_modules'), 'junction');
}
for (const pkg of fs.readdirSync(path.join(root, 'packages'))) {
  const from = path.join(root, 'packages', pkg), to = path.join(run, 'packages', pkg);
  if (!fs.statSync(from).isDirectory()) continue;
  fs.mkdirSync(to, { recursive: true });
  copy(path.join(from, 'src'), path.join(to, 'src'));
  copy(path.join(from, 'package.json'), path.join(to, 'package.json'));
}
fs.symlinkSync(path.join(root, 'node_modules'), path.join(run, 'node_modules'), 'junction');
const fixture = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');
  if (req.url.includes('/auth/login')) {
    res.statusCode = 401; return res.end(JSON.stringify({ error: { code: 'INVALID_CREDENTIALS', message: 'Synthetic credentials refused.', details: [] } }));
  }
  if (req.url === '/api/v1/products/csp-fixture') {
    const money = { amount: 1000, currency: 'EGP', formatted: 'EGP 10.00' };
    return res.end(JSON.stringify({ data: { id: '000000000000000000000001', slug: 'csp-fixture', sku: 'CSP-FIXTURE',
      name: '</script><script>window.injected=true</script>', shortDescription: null, description: 'Synthetic CSP fixture',
      category: { id: '000000000000000000000002', slug: 'fixture', name: 'Fixture' }, brand: null,
      pricing: { basePrice: money, salePrice: null, effectivePrice: money }, primaryImage: null, images: [], specs: [],
      rating: { average: 0, count: 0 }, availability: 'IN_STOCK', stockOnHand: 1, salesCount: 0, weight: null, isFeatured: false,
      createdAt: '2026-10-08T00:00:00Z', updatedAt: '2026-10-08T00:00:00Z' } }));
  }
  res.end(JSON.stringify({ data: [], meta: { total: 0, page: 1, pageSize: 20, totalPages: 0 } }));
});
const listen = server => new Promise(resolve => server.listen(0, '127.0.0.1', () => resolve(server.address().port)));
const children = new Set();
function child(app, args, env) {
  const log = fs.openSync(path.join(run, `${app}-${args[0]}.log`), 'w');
  const process = spawn(global.process.execPath, [path.join(root, 'apps', app, 'node_modules/next/dist/bin/next'), ...args], {
    cwd: path.join(run, 'apps', app), env, windowsHide: true, stdio: ['ignore', log, log],
  }); fs.closeSync(log); children.add(process); return process;
}
const exited = process => new Promise((resolve, reject) => {
  process.on('error', reject); process.on('exit', code => { children.delete(process); code === 0 ? resolve() : reject(new Error(`Next process exited ${code}; logs in ${run}`)); });
});
(async () => {
  let browser;
  try {
    const apiPort = await listen(fixture);
    // Deliberately exclude the parent shell's credentials/environment configuration.
    const env = Object.fromEntries(['PATH', 'SystemRoot', 'WINDIR', 'TEMP', 'TMP', 'USERPROFILE', 'LOCALAPPDATA', 'APPDATA'].filter(k => process.env[k]).map(k => [k, process.env[k]]));
    Object.assign(env, { NODE_ENV: 'production', NEXT_TELEMETRY_DISABLED: '1', API_BASE_URL: `http://127.0.0.1:${apiPort}/api/v1`,
      NEXT_FONT_GOOGLE_MOCKED_RESPONSES: path.join(__dirname, 'csp-test-fonts.cjs'),
      NODE_OPTIONS: `--require "${path.join(__dirname, 'csp-test-network.cjs').replaceAll('\\', '/')}"` });
    browser = await chromium.launch({ channel: 'chrome', headless: true });
    let cases = 0;
    await Promise.all(['storefront', 'admin'].map(app => {
      console.log(`Building isolated ${app} production copy...`);
      return exited(child(app, ['build', '--webpack'], env));
    }));
    for (const app of ['storefront', 'admin']) {
      const probe = http.createServer(); const port = await listen(probe); await new Promise(resolve => probe.close(resolve));
      const server = child(app, ['start', '--hostname', '127.0.0.1', '--port', String(port)], env);
      const origin = `http://127.0.0.1:${port}`, prefix = app === 'admin' ? '/admin' : '';
      for (let attempt = 0; ; attempt++) {
        try { await fetch(origin + prefix + '/login'); break; } catch {
          if (attempt > 120 || server.exitCode !== null) throw new Error('Isolated Next server did not start');
          await new Promise(resolve => setTimeout(resolve, 250));
        }
      }
      const page = await browser.newPage(); const errors = [], violations = [];
      await page.route('**/*', route => new URL(route.request().url()).origin === origin ? route.continue() : route.abort());
      page.on('pageerror', e => errors.push(e.message));
      await page.exposeFunction('recordCspViolation', data => violations.push(data));
      await page.addInitScript(() => document.addEventListener('securitypolicyviolation', e => window.recordCspViolation({ directive: e.effectiveDirective, blocked: e.blockedURI })));
      const response = await page.goto(origin + prefix + '/login'); assert.equal(response.status(), 200);
      const csp = response.headers()['content-security-policy']; assert(csp); assert(!csp.includes('unsafe-eval'));
      const nonce = csp.match(/'nonce-([^']+)'/)[1];
      await page.waitForFunction(() => [...document.querySelectorAll('input')].some(e => Object.keys(e).some(k => k.startsWith('__reactProps'))));
      assert(await page.evaluate(n => [...document.scripts].filter(s => s.src || s.textContent).every(s => s.nonce === n), nonce));
      if (app === 'storefront') {
        await page.getByRole('button', { name: 'Show password', exact: true }).click();
        assert.equal(await page.locator('input[name=password]').getAttribute('type'), 'text');
      }
      assert.deepEqual(errors, []); assert.deepEqual(violations, []); cases++;
      console.log(`PASS ${app}: production HTML, matching script nonces, hydration, CSS; no CSP violations/page errors`);
      // Existing Server Action must still return a handled fixture failure, not a CSP block.
      await page.locator('input[name=email]').fill('fixture@example.invalid');
      await page.locator('input[name=password]').fill('SyntheticPassword123!');
      const [action] = await Promise.all([
        page.waitForResponse(r => r.request().method() === 'POST'),
        page.getByRole('button', { name: 'Sign In', exact: true }).click(),
      ]);
      assert(action.status() < 500); assert(action.headers()['content-security-policy']);
      await page.locator('[role="alert"]:not(#__next-route-announcer__)').waitFor(); assert.deepEqual(violations, []); cases++;
      console.log(`PASS ${app}: Server Action response retains CSP and displays a handled synthetic rejection`);
      const denied = await fetch(origin + prefix + (app === 'admin' ? '/products' : '/account'), { redirect: 'manual' });
      assert.equal(denied.status, 307); assert(denied.headers.get('content-security-policy')); cases++;
      console.log(`PASS ${app}: protected navigation redirect retains CSP`);
      if (app === 'storefront') {
        const product = await page.goto(origin + '/products/csp-fixture'); assert.equal(product.status(), 200);
        const productNonce = product.headers()['content-security-policy'].match(/'nonce-([^']+)'/)[1];
        const structured = await page.locator('script[type="application/ld+json"]').evaluateAll(scripts => scripts.map(s => ({ nonce: s.nonce, data: JSON.parse(s.textContent) })));
        assert.equal(structured.length, 2); assert(structured.every(s => s.nonce === productNonce));
        assert.equal(structured[0].data.name, '</script><script>window.injected=true</script>');
        assert.equal(await page.evaluate(() => !!window.injected), false); assert.deepEqual(violations, []); cases++;
        console.log('PASS storefront: actual product SSR and JSON-LD preserve untrusted data without execution');
      }
      await page.close(); server.kill();
    }
    console.log(`PASS: ${cases} production Next runtime cases. Isolated artifacts: ${run}`);
  } finally {
    for (const process of children) process.kill();
    if (browser) await browser.close();
    await new Promise(resolve => fixture.close(resolve));
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
