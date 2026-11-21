// Execute unchanged action modules with explicit in-memory dependencies.
// This proves action branching/normalization, not database behavior.
const ts=require('../node_modules/typescript'),fs=require('node:fs'),vm=require('node:vm');
const rows=[];let calls=[],deny=false;
function load(file){
 const exp={};const query=new Proxy({}, {get:(_,key)=>key==='then'?(resolve)=>Promise.resolve(resolve({error:null,data:null,count:0})): (...args)=>{calls.push({method:key,args});return query;}});
 const mockApi=new Proxy({}, {get:(_,key)=>async(...args)=>{calls.push({api:key,args});return {data:{id:'000000000000000000000030'}};}});
 const req=n=>{
  if(n==='zod')return require('../apps/admin/node_modules/zod');
  if(n==='@/lib/api/identity')return {requireAdminActor:async()=>{if(deny)throw Error('DENIED');return {id:'000000000000000000000001'};}};
  if(n==='@/lib/supabase')return {createClient:async()=>({from:(table)=>{calls.push({table});return query;}})};
  if(n==='@/lib/audit/log-action')return {logAdminAction:async()=>{}};
  if(n==='@/lib/logger')return {logger:{info(){},warn(){},error(){}}};
  if(n==='next/cache')return {revalidatePath(){},refresh(){}};
  if(n==='@/lib/api/endpoints')return mockApi;
  if(n==='@/lib/api/client')return {tryApi:async f=>({ok:true,data:await f()})};
  if(n==='@/lib/api/errors')return {operatorMessage:()=>''};
  throw Error('Unexpected import '+n);
 };
 vm.runInNewContext(ts.transpileModule(fs.readFileSync(file,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText,{exports:exp,require:req,console,FormData,Number,Date});return exp;
}
(async()=>{
 const coupon=load('apps/admin/src/actions/coupon.actions.ts'),review=load('apps/admin/src/actions/review.actions.ts'),product=load('apps/admin/src/actions/product.actions.ts');
 for(const value of ['', ' ', 'abc','12oops','-1','101','1e309','12.34']){
  calls=[];const fd=new FormData();Object.entries({id:'nonexistent',code:'AUDIT',type:'percentage',value,is_active:'true',starts_at:'not-a-date',expires_at:'yesterday',usage_limit:'1.9'}).forEach(([k,v])=>fd.set(k,v));
  const result=await coupon.updateCouponAction(fd);rows.push({test:'coupon validation',value,result,calls});
 }
 for(const [name,fn] of [['delete nonexistent coupon',()=>coupon.deleteCouponAction('not-an-id')],['delete nonexistent review',()=>review.deleteReviewAction('not-an-id')],['moderate nonexistent review',()=>{const fd=new FormData();fd.set('reviewId','00000000-0000-4000-8000-000000000001');fd.set('status','approved');return review.updateReviewStatusAction(fd)}]]){calls=[];rows.push({test:name,result:await fn(),calls});}
 const input={sku:'AUDIT',slug:'audit',nameEn:'Audit',nameAr:'',shortDescriptionEn:'',shortDescriptionAr:'',descriptionEn:'',descriptionAr:'',categoryId:'000000000000000000000010',brandId:'',basePrice:'',salePrice:'',costPrice:'',weight:'',length:'',width:'',height:'',seoTitle:'',seoDescription:'',isFeatured:false,specs:[]};
 for(const value of ['', 'abc','12oops','1e309','12.345']){calls=[];rows.push({test:'product price normalization',value,result:await product.createProductAction({...input,basePrice:value}),calls});}
 deny=true;calls=[];try{await coupon.deleteCouponAction('x')}catch(e){rows.push({test:'actor refusal before data access',error:e.message,calls})}
 fs.writeFileSync('admin-dashboard-audit/evidence/action-probes.json',JSON.stringify({mockedDependencies:true,rows},null,2));console.log(rows.map(r=>({test:r.test,value:r.value,result:r.result,error:r.error})));
})().catch(e=>{console.error(e);process.exitCode=1});
