const { chromium, expect } = require('../../apps/admin/node_modules/@playwright/test');
const fs = require('node:fs');
const path = require('node:path');
const origin = 'http://127.0.0.1:3410/admin';
const results = [];
(async () => {
  await fetch('http://127.0.0.1:3411/__qa/scenario?value=populated');
  const browser = await chromium.launch();
  try {
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, reducedMotion: 'reduce' });
    await page.context().addCookies(['nest_admin_at', 'nest_admin_rt'].map(name => ({ name, value: 'local-visual-fixture', url: origin, httpOnly: true })));
    for (const width of [320, 375, 768, 1024, 1280, 1440]) {
      await page.setViewportSize({ width, height: 900 });
      for (const [route, button] of [['categories', 'New category'], ['brands', 'New brand'], ['categories', 'Delete category'], ['brands', 'Delete brand'], ['inventory', 'Adjust'], ['inventory', 'Movement history'], ['products', 'Delete (recoverable)']]) {
        await page.goto(`${origin}/${route}`, { waitUntil: 'networkidle' });
        const opener = button === 'Movement history' || button === 'Delete (recoverable)' ? page.getByTitle(button).first() : page.getByRole('button', { name: button, exact: true }).first();
        await opener.click();
        const dialog = page.getByRole('dialog');
        await expect(dialog).toBeVisible();
        if (button === 'Movement history') await expect(dialog.getByText('Local QA receipt')).toBeVisible();
        const bounds = await dialog.boundingBox();
        if (bounds.x < -1 || bounds.x + bounds.width > width + 1 || bounds.y < -1 || bounds.y + bounds.height > 901) throw new Error(`Dialog outside viewport: ${route} ${button} ${width} ${JSON.stringify(bounds)}`);
        if (width === 320 || width === 1440) await page.screenshot({ path: path.join(__dirname, 'screenshots', `${route}-${button.replaceAll(' ', '-')}-${width}.png`), fullPage: false });
        await page.keyboard.press('Tab');
        await expect(dialog.locator(':focus')).toHaveCount(1);
        await page.keyboard.press('Escape');
        await expect(dialog).toHaveCount(0);
        await expect(opener).toBeFocused();
        results.push({ width, route, button, focusTrap: true, escape: true, focusReturn: true });
      }
      if (width < 1024) {
        const opener = page.getByRole('button', { name: 'Open navigation' });
        await opener.click();
        const dialog = page.getByRole('dialog', { name: 'Store navigation' });
        await expect(dialog).toBeVisible();
        await dialog.getByRole('link', { name: 'Orders', exact: true }).click();
        await expect(page).toHaveURL(/\/admin\/orders$/);
        await expect(dialog).toHaveCount(0);
        results.push({ width, mobileNavigation: true });
      }
    }
    await page.goto(`${origin}/orders`, { waitUntil: 'networkidle' });
    await page.keyboard.press('Control+k');
    await expect(page.getByRole('searchbox', { name: 'Search orders', exact: true })).toBeFocused();
    await page.getByRole('searchbox', { name: 'Search orders', exact: true }).fill('NE-QA');
    await page.keyboard.press('Enter');
    await expect(page).toHaveURL(/q=NE-QA/);
    await page.getByTestId('queue-sort').selectOption('oldest');
    await expect(page).toHaveURL(/sort=oldest/);
    await page.getByRole('button', { name: 'Confirmed 8', exact: true }).click();
    await expect(page).toHaveURL(/status=CONFIRMED/);
    results.push({ searchShortcut: true, searchQuery: true, sortQuery: true, statusQuery: true });
    await page.goto(`${origin}/products/new`, { waitUntil: 'networkidle' });
    await page.getByRole('button', { name: 'Add specification' }).click();
    await page.getByLabel('Label', { exact: true }).fill('Operating voltage');
    await expect(page.getByLabel('Key', { exact: true })).toHaveValue('operating-voltage');
    await page.getByRole('button', { name: 'Remove specification' }).click();
    await expect(page.getByLabel('Label', { exact: true })).toHaveCount(0);
    results.push({ specLabels: true, specAddRemove: true });
    await page.goto(`${origin}/settings`, { waitUntil: 'networkidle' });
    await page.getByRole('button', { name: 'Edit Fee' }).first().click();
    await expect(page.getByRole('spinbutton', { name: /Shipping fee for/ })).toBeVisible();
    await page.getByRole('button', { name: 'Cancel fee edit' }).click();
    await expect(page.getByRole('spinbutton')).toHaveCount(0);
    results.push({ shippingInlineEditor: true });
    console.log(`Passed ${results.length} interaction checks.`);
    fs.writeFileSync(path.join(__dirname, 'interaction-qa-results.json'), JSON.stringify({ fixtureOnly: true, results }, null, 2));
  } finally { await browser.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });
