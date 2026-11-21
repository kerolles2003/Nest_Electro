// Presentation-only checks against qa-service.cjs. This is NOT the API E2E suite.
const { chromium } = require('../../apps/admin/node_modules/@playwright/test');
const fs = require('node:fs');
const path = require('node:path');
const output = path.join(__dirname, 'screenshots');
const widths = [320, 375, 768, 1024, 1280, 1440];
const routes = ['/', '/products', '/products/new', '/products/000000000000000000000030/edit', '/orders', '/orders/000000000000000000000050', '/inventory', '/categories', '/brands', '/customers', '/coupons', '/reviews', '/audit-log', '/settings', '/login', '/unauthorized', '/not-a-real-route'];
const slug = (route) => route === '/' ? 'overview' : route.replaceAll('/', '-').replace(/^-/, '').replace(/0{10,}/g, 'id');
async function scenario(value) { await fetch(`http://127.0.0.1:3411/__qa/scenario?value=${value}`); }
async function measure(page) {
  return page.evaluate(() => ({
    width: innerWidth, documentWidth: document.documentElement.scrollWidth,
    title: document.querySelector('h1')?.textContent,
    unlabeled: [...document.querySelectorAll('input:not([type=hidden]),select,textarea')].filter(e => e.getClientRects().length && !e.labels?.length && !e.getAttribute('aria-label') && !e.getAttribute('aria-labelledby')).map(e => ({ tag: e.tagName, placeholder: e.getAttribute('placeholder'), type: e.getAttribute('type') })),
  }));
}
(async () => {
  fs.mkdirSync(output, { recursive: true });
  await scenario('populated');
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width: 1440, height: 1000 }, reducedMotion: 'reduce' });
  await context.addCookies(['nest_admin_at', 'nest_admin_rt'].map(name => ({ name, value: 'local-visual-fixture', url: 'http://127.0.0.1:3410', httpOnly: true, sameSite: 'Lax' })));
  const page = await context.newPage();
  page.setDefaultNavigationTimeout(120000);
  const errors = [], checks = [];
  page.on('pageerror', error => errors.push({ route: page.url(), message: error.message }));
  page.on('console', message => { if(message.type() === 'error' && /hydrat|uncaught|invalid.*nest/i.test(message.text())) errors.push({route:page.url(),message:message.text()}); });
  for (const route of routes) {
    await page.goto(`http://127.0.0.1:3410/admin${route === '/' ? '' : route}`, { waitUntil: 'networkidle' });
    for (const width of widths) {
      await page.setViewportSize({ width, height: 1000 });
      await page.evaluate(() => new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve))));
      const result = await measure(page);
      checks.push({ route, ...result });
      if ([320, 1440].includes(width)) await page.screenshot({ path: path.join(output, `${slug(route)}-${width}.png`), fullPage: true });
    }
    fs.writeFileSync(path.join(__dirname, 'visual-qa-progress.json'), JSON.stringify({checks,errors},null,2));
    console.log(`${route}: ${checks.slice(-6).some(c => c.documentWidth > c.width + 1) ? 'OVERFLOW' : 'fits all six widths'}`);
  }
  for (const state of ['empty', 'error']) {
    await scenario(state);
    for (const route of ['/', '/products', '/orders', '/inventory', '/categories', '/brands', '/customers', '/coupons', '/reviews', '/audit-log', '/settings']) {
      await page.goto(`http://127.0.0.1:3410/admin${route === '/' ? '' : route}`, { waitUntil: 'networkidle' });
      checks.push({ state, route, ...await measure(page) });
      if (['/', '/products', '/coupons'].includes(route)) await page.screenshot({ path: path.join(output, `${slug(route)}-${state}.png`), fullPage: true });
    }
    console.log(`${state}: checked 11 data routes`);
  }
  await scenario('populated');
  await browser.close();
  const report = { fixtureOnly: true, widths, checks, errors, overflows: checks.filter(c => c.documentWidth > c.width + 1), unlabeled: checks.filter(c => c.unlabeled.length) };
  fs.writeFileSync(path.join(__dirname, 'visual-qa-results.json'), JSON.stringify(report, null, 2));
  console.log(JSON.stringify({ checks: checks.length, errors, overflows: report.overflows, unlabeledRoutes: [...new Set(report.unlabeled.map(c => c.route))] }, null, 2));
  if (errors.length || report.overflows.length) process.exitCode = 1;
})().catch(error => { console.error(error); process.exitCode = 1; });
