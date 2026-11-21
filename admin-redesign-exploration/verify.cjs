// Optional QA helper using the repository's existing Playwright installation.
// The demos themselves need neither Node nor Playwright.
const { chromium } = require('../apps/admin/node_modules/@playwright/test');
const { mkdirSync, writeFileSync } = require('node:fs');
const { join } = require('node:path');
const { pathToFileURL } = require('node:url');
const assert = require('node:assert/strict');
const root=__dirname;
const concepts=['01-premium-minimal','02-dark-command-center','03-editorial-human','04-data-first'];
(async()=>{
  mkdirSync(join(root,'previews'),{recursive:true});
  const browser=await chromium.launch({headless:true});
  const results=[];
  try {
    for(const concept of concepts){
      const context=await browser.newContext({viewport:{width:1440,height:1000},reducedMotion:'reduce'});
      const page=await context.newPage();
      const errors=[];page.on('pageerror',e=>errors.push(e.message));
      const requests=[];page.on('request',r=>{if(/^https?:/.test(r.url()))requests.push(r.url());});
      await page.goto(pathToFileURL(join(root,`concept-${concept}`,'index.html')).href);
      await page.locator('#order-rows tr').first().waitFor();
      await page.screenshot({path:join(root,'previews',`concept-${concept.slice(0,2)}.png`)});
      await page.screenshot({path:join(root,'previews',`concept-${concept.slice(0,2)}-full.png`),fullPage:true});
      await page.locator('#order-search').fill('Ahmed');
      assert.equal(await page.locator('#order-rows tr').count(),1);
      await page.locator('#order-search').fill('unmatched record');
      assert(await page.locator('#table-empty').isVisible());
      await page.locator('#table-empty [data-action=reset]').click();
      const filtersWereHidden=!(await page.locator('#advanced-filters').isVisible());
      if(filtersWereHidden)await page.locator('[data-action=filters]').click();
      await page.locator('#date-from').fill('2026-10-06');await page.locator('#date-to').fill('2026-10-06');
      assert.equal(await page.locator('#order-rows tr').count(),3);
      await page.locator('#payment-filter').selectOption('Paid');assert.equal(await page.locator('#order-rows tr').count(),1);
      assert((await page.locator('#order-rows').innerText()).includes('NE-1042'));
      await page.locator('#advanced-filters [data-action=reset]').click();
      if(filtersWereHidden)await page.locator('[data-action=filters]').click();
      await page.locator('#status-filter').selectOption('Confirmed');
      assert.equal(await page.locator('#order-rows tr').count(),2);
      await page.locator('#status-filter').selectOption('All statuses');
      await page.locator('#sort').selectOption('high');
      assert((await page.locator('#order-rows tr').first().innerText()).includes('NE-1040'));
      await page.locator('#sort').selectOption('newest');
      await page.locator('#next-page').click();
      assert.equal(await page.locator('#page-number').innerText(),concept.startsWith('04')?'2 / 2':'2 / 3');
      await page.locator('#previous-page').click();
      await page.locator('#select-all').check();
      assert(await page.locator('#bulk-export').isEnabled());
      const downloadPromise=page.waitForEvent('download');
      await page.locator('#bulk-export').click();
      const download=await downloadPromise;assert.equal(download.suggestedFilename(),'nest-sample-orders.csv');
      await page.locator('#select-all').uncheck();
      assert(await page.locator('#bulk-export').isDisabled());
      await page.getByRole('button',{name:'View order NE-1048',exact:true}).click();
      assert(await page.locator('#detail-modal').isVisible());
      assert((await page.locator('#detail-content').innerText()).includes('Ahmed Hassan'));
      await page.keyboard.press('Escape');
      assert(!(await page.locator('#detail-modal').isVisible()));
      await page.locator('[data-action=new-product]').first().click();
      await page.locator('[name=name]').fill('Test sensor');await page.locator('[name=sku]').fill('TEST-01');await page.locator('[name=price]').fill('99.50');
      await page.getByRole('button',{name:'Create sample draft',exact:true}).click();
      assert((await page.locator('#toast').innerText()).includes('Test sensor'));
      await page.locator('[data-nav=Products]').click();
      assert((await page.locator('#module-content').innerText()).includes('Test sensor'));
      await page.keyboard.press('Escape');
      await page.getByRole('button',{name:'Notifications',exact:true}).click();
      assert(await page.locator('#notifications').isVisible());
      await page.getByRole('button',{name:'Mark all as read',exact:true}).click();
      assert((await page.locator('#notifications').innerText()).includes('caught up'));
      await page.keyboard.press('Escape');
      await page.getByRole('button',{name:'User menu',exact:true}).click();assert(await page.locator('#user-menu').isVisible());await page.keyboard.press('Escape');
      await page.locator('#period').selectOption('90');assert.equal(await page.locator('#chart-total').innerText(),'EGP 792,480');
      assert.equal(await page.locator('.kpi-1 .kpi-value').innerText(),'24');
      await page.locator('#period').selectOption('30');
      await page.locator('[data-action=loading]').click();await page.getByText('64 units available',{exact:true}).waitFor();
      await page.locator('[data-action=retry]').click();await page.getByRole('heading',{name:'Inventory loaded',exact:true}).waitFor();
      for(const width of [1440,1024,768,390,320]){
        await page.setViewportSize({width,height:900});
        const dimensions=await page.evaluate(()=>({scroll:document.documentElement.scrollWidth,client:document.documentElement.clientWidth}));
        if(dimensions.scroll>dimensions.client+1){console.log(await page.evaluate(()=>[...document.querySelectorAll('body *')].filter(el=>el.getBoundingClientRect().right>innerWidth+1 && getComputedStyle(el).position!=='fixed').map(el=>({tag:el.tagName,cls:el.className,right:Math.round(el.getBoundingClientRect().right),width:Math.round(el.getBoundingClientRect().width)})).slice(0,20)));await page.screenshot({path:join(root,'previews','overflow.png'),fullPage:true});}
        assert(dimensions.scroll<=dimensions.client+1,`${concept} overflows at ${width}: ${JSON.stringify(dimensions)}`);
      }
      await page.setViewportSize({width:390,height:844});
      await page.reload();await page.locator('#order-rows tr').first().waitFor();
      await page.evaluate(()=>{document.activeElement.blur();window.scrollTo({top:0,behavior:'instant'});});
      await page.screenshot({path:join(root,'previews',`concept-${concept.slice(0,2)}-mobile-viewport.png`)});
      await page.screenshot({path:join(root,'previews',`concept-${concept.slice(0,2)}-mobile.png`),fullPage:true});
      await page.getByRole('button',{name:'Open navigation',exact:true}).click();
      assert.equal(await page.locator('#sidebar').getAttribute('class'),'sidebar is-open');
      await page.locator('#sidebar [data-nav=Inventory]').click();
      assert.equal(await page.locator('#module-title').innerText(),'Inventory');await page.keyboard.press('Escape');
      assert.equal(await page.locator('#sidebar').evaluate(el=>el.inert),true);
      await page.getByRole('button',{name:'Notifications',exact:true}).click();assert(await page.locator('#notifications').isVisible());await page.keyboard.press('Escape');
      assert.deepEqual(errors,[],`${concept} browser errors`);assert.deepEqual(requests,[],`${concept} unexpected external requests`);
      results.push({concept,result:'passed',widths:[1440,1024,768,390,320],browserErrors:errors.length,externalRequests:requests.length});
      await context.close();console.log(`${concept}: passed desktop, mobile, filters, pagination, selection, CSV, dialogs, navigation, states, and period scope`);
    }
    const page=await browser.newPage({viewport:{width:1440,height:1000}});
    await page.goto(pathToFileURL(join(root,'index.html')).href);
    assert.equal(await page.locator('.open').count(),4);
    await page.locator('img').evaluateAll(async imgs=>{await Promise.all(imgs.map(i=>i.decode()));});
    await page.screenshot({path:join(root,'previews','selector.png'),fullPage:true});
    await page.setViewportSize({width:390,height:844});
    assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
    writeFileSync(join(root,'previews','verification.json'),JSON.stringify({browser:'Chromium',results,selector:'passed'},null,2));
    console.log('Selector previews, links, and mobile layout passed.');
  } finally {await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
