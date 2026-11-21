const {chromium}=require('../apps/admin/node_modules/@playwright/test');
const fs=require('node:fs');
const base='http://127.0.0.1:3410',out='admin-dashboard-audit/evidence';
const result={fixtureOnly:true,tests:[],errors:[]};
async function control(fault={}){await fetch('http://127.0.0.1:3411/__audit?reset=1&fault='+encodeURIComponent(JSON.stringify(fault)));}
const logs=async()=>(await (await fetch('http://127.0.0.1:3411/__audit')).json()).requests;
function save(){fs.writeFileSync(out+'/adversarial.json',JSON.stringify(result,null,2));}
(async()=>{
 const browser=await chromium.launch({headless:true});
 const ctx=await browser.newContext({viewport:{width:1440,height:900}});
 const cookies=async()=>ctx.addCookies(['nest_admin_at','nest_admin_rt'].map(name=>({name,value:'local-visual-fixture',url:base,httpOnly:true,sameSite:'Lax'})));
 await cookies();const p=await ctx.newPage();p.setDefaultTimeout(6000);p.setDefaultNavigationTimeout(60000);
 p.on('pageerror',e=>result.errors.push({url:p.url(),message:e.message}));
 async function test(name,fn){try{result.tests.push({name,result:await fn()});}catch(e){result.tests.push({name,harnessError:e.message});}save();console.log(name);await control();}
 await control();
 await test('slug wrong basePath',async()=>{
  await p.goto(base+'/admin/products/new',{waitUntil:'networkidle'});
  const response=p.waitForResponse(r=>r.url().includes('/api/check-slug'));
  await p.locator('#product-name-english').fill('Audit العربية <script>test</script>');
  const r=await response;await p.waitForTimeout(300);
  await p.screenshot({path:out+'/slug.png',fullPage:true});
  return {url:r.url(),status:r.status(),text:(await p.locator('body').innerText()).match(/.{0,30}(check|available|unknown).{0,90}/gi)};
 });
 await test('clear customer search',async()=>{
  await p.goto(base+'/admin/customers',{waitUntil:'networkidle'});
  await p.getByRole('textbox',{name:'Search customers by name or phone'}).fill('Salma');
  await p.waitForTimeout(1200);const before=p.url();
  await p.getByRole('button',{name:'Clear',exact:true}).click();await p.waitForTimeout(1400);
  return {before,after:p.url(),input:await p.getByRole('textbox',{name:'Search customers by name or phone'}).inputValue()};
 });
 await test('unauthenticated direct routes',async()=>{
  const c=await browser.newContext();const q=await c.newPage();const checks=[];
  for(const route of require('./evidence/browser.json').pages){const r=await q.goto(base+route,{waitUntil:'networkidle'});checks.push({route,status:r?.status(),final:q.url()});}
  for(const route of ['/admin/api/check-slug?slug=a','/admin/session/renew?next=https://example.test']){const r=await q.goto(base+route);checks.push({route,status:r.status(),final:q.url()});}
  await c.close();return checks;
 });
 await test('customer role denied',async()=>{await control({role:'CUSTOMER'});await p.goto(base+'/admin/products',{waitUntil:'networkidle'});return {url:p.url(),text:(await p.locator('body').innerText()).slice(0,300)};});
 await test('slug route correctly prefixed',async()=>{const r=await ctx.request.get(base+'/admin/api/check-slug?slug=audit-safe');return {status:r.status(),body:await r.text()};});
 await test('redirect hostile next values',async()=>{
  const rows=[];for(const next of ['https://example.test','//example.test','/\\example.test','/%2f%2fexample.test','/orders?q=abc']){const r=await ctx.request.get(base+'/admin/session/renew?next='+encodeURIComponent(next),{maxRedirects:0});rows.push({next,status:r.status(),location:r.headers().location});}return rows;
 });
 for(const status of [400,401,403,404,409,422,429,500])await test('products GET '+status,async()=>{
  await control({match:'/admin/catalog/products',status});await p.goto(base+'/admin/products',{waitUntil:'networkidle'});return {url:p.url(),alerts:await p.getByRole('alert').allTextContents(),text:(await p.locator('main').innerText()).slice(-1000)};
 });
 await test('malformed 200 product response',async()=>{await control({match:'/admin/catalog/products',malformed:true});await p.goto(base+'/admin/products',{waitUntil:'networkidle'});return {text:await p.locator('main').innerText()};});
 await test('identity 429',async()=>{await control({match:'/auth/me',status:429});await p.goto(base+'/admin/products',{waitUntil:'networkidle'});return {url:p.url(),cookies:(await ctx.cookies()).map(c=>c.name),requests:await logs()};});
 await cookies();
 await test('identity unavailable legacy read',async()=>{await control({match:'/auth/me',status:500});await p.goto(base+'/admin/coupons',{waitUntil:'networkidle'});return {text:(await p.locator('main').innerText()).slice(0,1000),requests:await logs()};});
 await test('disconnected API',async()=>{await control({match:'/admin/catalog/products',disconnect:true});await p.goto(base+'/admin/products',{waitUntil:'networkidle'});return {alerts:await p.getByRole('alert').allTextContents()};});
 await test('slow API 5 seconds',async()=>{await control({match:'/admin/catalog/products',delay:5000});const t=Date.now();await p.goto(base+'/admin/products',{waitUntil:'networkidle'});return {ms:Date.now()-t,requests:await logs()};});
 await test('duplicate identity calls and browser payload',async()=>{await control();await p.goto(base+'/admin',{waitUntil:'networkidle'});return {requests:await logs(),resources:await p.evaluate(()=>performance.getEntriesByType('resource').filter(r=>r.name.includes('.js')).map(r=>({url:r.name,transfer:r.transferSize,decoded:r.decodedBodySize}))),navigation:await p.evaluate(()=>performance.getEntriesByType('navigation')[0].toJSON())};});
 await test('coupon malformed native validity',async()=>{
  await p.goto(base+'/admin/coupons',{waitUntil:'networkidle'});await p.getByRole('button',{name:/New Coupon|Create Coupon|Add Coupon/i}).first().click();
  return await p.locator('input').evaluateAll(es=>es.map(e=>({id:e.id,type:e.type,min:e.min,max:e.max,required:e.required,inForm:!!e.form})));
 });
 await test('keyboard mobile menu',async()=>{await p.setViewportSize({width:320,height:700});await p.goto(base+'/admin',{waitUntil:'networkidle'});await p.getByRole('button',{name:/open navigation/i}).click();const inside=await p.getByRole('dialog').evaluate(e=>e.contains(document.activeElement));await p.keyboard.press('Escape');return {inside,closed:await p.getByRole('dialog').count(),focus:await p.evaluate(()=>document.activeElement.outerHTML)};});
 await test('partial JavaScript absent',async()=>{const c=await browser.newContext({javaScriptEnabled:false});await c.addCookies(await ctx.cookies());const q=await c.newPage();await q.goto(base+'/admin/products/new');const forms=await q.locator('form').evaluateAll(es=>es.map(e=>({action:e.getAttribute('action'),method:e.getAttribute('method')})));await c.close();return {forms,interpretation:'Client onSubmit workflow requires hydration; submission not attempted without JS.'};});
 await test('CPU 4x warm dashboard',async()=>{await p.setViewportSize({width:1440,height:900});const cd=await ctx.newCDPSession(p);await cd.send('Emulation.setCPUThrottlingRate',{rate:4});const t=Date.now();await p.goto(base+'/admin',{waitUntil:'networkidle'});await cd.send('Emulation.setCPUThrottlingRate',{rate:1});return {ms:Date.now()-t,devMode:true};});
 await control();await browser.close();save();
})().catch(e=>{result.fatal=e.stack;save();console.error(e);process.exitCode=1});
