const {chromium}=require('../apps/admin/node_modules/@playwright/test'),fs=require('node:fs');
const base='http://127.0.0.1:3410',out='admin-dashboard-audit/evidence';const r={axe:[],tests:[],errors:[]};
async function control(fault={}){await fetch('http://127.0.0.1:3411/__audit?reset=1&fault='+encodeURIComponent(JSON.stringify(fault)));}
function save(){fs.writeFileSync(out+'/supplemental.json',JSON.stringify(r,null,2));}
(async()=>{await control();const b=await chromium.launch();const c=await b.newContext({viewport:{width:1440,height:900}});await c.addCookies(['nest_admin_at','nest_admin_rt'].map(name=>({name,value:'local-visual-fixture',url:base,httpOnly:true})));const p=await c.newPage();p.setDefaultTimeout(6000);p.on('pageerror',e=>r.errors.push({url:p.url(),message:e.message}));
 for(const route of require('./evidence/browser.json').pages){await p.goto(base+route,{waitUntil:'networkidle'});await p.addScriptTag({path:'node_modules/.pnpm/axe-core@4.11.3/node_modules/axe-core/axe.min.js'});const a=await p.evaluate(()=>axe.run(document,{runOnly:{type:'tag',values:['wcag2a','wcag2aa','wcag21aa','wcag22aa']}}));r.axe.push({route,violations:a.violations.map(v=>({id:v.id,impact:v.impact,description:v.description,nodes:v.nodes.map(n=>({html:n.html,target:n.target,summary:n.failureSummary}))})),incomplete:a.incomplete.map(v=>({id:v.id,count:v.nodes.length}))});save();console.log('axe '+route);}
 await p.goto(base+'/admin/customers',{waitUntil:'networkidle'});await p.getByRole('textbox',{name:'Search customers by name or phone'}).fill('Salma');await p.waitForTimeout(700);r.tests.push({name:'unnamed search clear',buttons:await p.locator('button').evaluateAll(es=>es.filter(e=>!e.textContent.trim()&&!e.getAttribute('aria-label')&&!e.getAttribute('title')).map(e=>e.outerHTML))});
 await p.goto(base+'/admin/products/000000000000000000000030/edit',{waitUntil:'networkidle'});
 const sharp=require('../apps/api/node_modules/sharp');const buf=await sharp(require('node:crypto').randomBytes(800*800*3),{raw:{width:800,height:800,channels:3}}).png({compressionLevel:0}).toBuffer();
 const responses=[];p.on('response',res=>{if(res.request().method()==='POST')responses.push({url:res.url(),status:res.status()})});
 await p.locator('input[type=file]').setInputFiles({name:'audit-valid-1.9MB.png',mimeType:'image/png',buffer:buf});await p.waitForTimeout(2500);
 r.tests.push({name:'upload within advertised 5 MB',bytes:buf.length,responses,text:(await p.locator('body').innerText()).slice(-1500),requests:(await(await fetch('http://127.0.0.1:3411/__audit')).json()).requests});await p.screenshot({path:out+'/upload-failure.png',fullPage:true});save();
 await control();await b.close();
})().catch(e=>{r.fatal=e.stack;save();console.error(e);process.exitCode=1});
