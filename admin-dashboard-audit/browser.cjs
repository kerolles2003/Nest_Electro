const {chromium}=require('../apps/admin/node_modules/@playwright/test');
const fs=require('node:fs');
const out='admin-dashboard-audit/evidence';
const base='http://127.0.0.1:3410';
const widths=[320,375,390,414,768,1024,1280,1440,1920];
const pages=fs.readdirSync('apps/admin/src/app',{recursive:true}).filter(p=>/page\.tsx$/.test(p)).map(p=>'/admin/'+p.replaceAll('\\','/').replace(/\(dashboard\)\//,'').replace(/\/?page\.tsx$/,'').replace('[id]/edit','000000000000000000000030/edit').replace('[id]','000000000000000000000050')).map(p=>p.replace(/\/$/,''));
const report={fixtureOnly:true,pages,widths,checks:[],errors:[],network:[],tests:[]};
async function control(fault={}) {await fetch('http://127.0.0.1:3411/__audit?fault='+encodeURIComponent(JSON.stringify(fault))+'&reset=1');}
function save(){fs.writeFileSync(out+'/browser.json',JSON.stringify(report,null,2));}
(async()=>{
 const browser=await chromium.launch({headless:true});
 const ctx=await browser.newContext({viewport:{width:1440,height:900}});
 await ctx.addCookies(['nest_admin_at','nest_admin_rt'].map(name=>({name,value:'local-visual-fixture',url:base,httpOnly:true,sameSite:'Lax'})));
 const p=await ctx.newPage(); p.setDefaultNavigationTimeout(90000);
 p.on('pageerror',e=>report.errors.push({url:p.url(),message:e.message}));
 p.on('console',m=>{if(['error','warning'].includes(m.type()))report.errors.push({url:p.url(),type:m.type(),message:m.text()});});
 p.on('response',r=>{if(r.status()>=400)report.network.push({url:r.url(),status:r.status()});});
 await control();
 for(const route of [...pages,'/admin/not-a-real-route']){
  const t=Date.now();const response=await p.goto(base+route,{waitUntil:'networkidle'});
  for(const width of widths){
   await p.setViewportSize({width,height:900});await p.evaluate(()=>new Promise(r=>requestAnimationFrame(()=>requestAnimationFrame(r))));
   const m=await p.evaluate(()=>({width:innerWidth,scrollWidth:document.documentElement.scrollWidth,h1:document.querySelector('h1')?.textContent,unlabeled:[...document.querySelectorAll('input:not([type=hidden]),select,textarea')].filter(e=>e.getClientRects().length&&!e.labels?.length&&!e.getAttribute('aria-label')&&!e.getAttribute('aria-labelledby')).map(e=>e.outerHTML.slice(0,180)),smallTargets:[...document.querySelectorAll('button,a,input,select')].filter(e=>{const r=e.getBoundingClientRect();return r.width>0&&r.height>0&&(r.width<24||r.height<24)}).map(e=>({text:e.textContent?.trim().slice(0,55),label:e.getAttribute('aria-label'),w:e.getBoundingClientRect().width,h:e.getBoundingClientRect().height})),brokenImages:[...document.images].filter(i=>i.complete&&i.naturalWidth===0).map(i=>i.src)}));
   report.checks.push({route,status:response.status(),...m});
   if([320,1440].includes(width))await p.screenshot({path:out+'/'+route.replaceAll('/','_')+'-'+width+'.png',fullPage:true});
  }
  console.log(route+' complete');report.tests.push({test:'direct route load',route,ms:Date.now()-t});save();
 }
 await p.goto(base+'/admin/products/new',{waitUntil:'networkidle'});
 await p.locator('#product-name-english').fill('Audit العربية <script>test</script>');
 await p.waitForTimeout(800);
 report.tests.push({test:'slug check',requests:report.network.filter(x=>x.url.includes('check-slug')),text:(await p.locator('body').innerText()).slice(-1500)});save();
 await browser.close();
})().catch(e=>{report.fatal=e.stack;save();console.error(e);process.exitCode=1});
