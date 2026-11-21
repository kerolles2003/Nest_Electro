// Real compiled ProductAdminService, deterministic in-memory repository doubles.
require('../apps/api/node_modules/reflect-metadata');
const {ProductAdminService}=require('../apps/api/dist/modules/catalog/application/product-admin.service');
const {Types}=require('../apps/api/node_modules/mongoose');const fs=require('node:fs');
const id=new Types.ObjectId('000000000000000000000030');
const original={_id:id,sku:'AUDIT',slug:'audit',name:{en:'Audit',ar:null},category:{id,slug:'category'},brand:null,pricing:{basePrice:10000,salePrice:null,effectivePrice:10000,costPrice:3000},specs:[],deletedAt:null};
let stored={...original},filters=[];
const service=Object.create(ProductAdminService.prototype);
service.resolveActor=async()=>({_id:id,role:'ADMIN',fullName:'Audit',email:'audit@example.test'});
service.findById=async()=>({...original,pricing:{...original.pricing}});
service.audit={recordIntent:async()=>'audit-op',recordChange:async()=>{}};
service.recount=async()=>{};
service.products={findOneAndUpdate:(filter,update)=>{filters.push(filter);return {lean(){return this},exec:async()=>{stored={...stored,...update.$set};return stored;}}}};
(async()=>{
 await service.update(id,{basePrice:15000},{actorId:id,forensics:{}});
 const afterFirst={...stored.pricing};
 await service.update(id,{costPrice:4000},{actorId:id,forensics:{}});
 const race={test:'Two requests read original, second cost-only write overwrites first price',afterFirst,afterSecond:stored.pricing,filters,mockedDatabase:true};
 stored={...original};service.recount=async()=>{throw Error('controlled recount failure')};
 let error;try{await service.update(id,{basePrice:20000},{actorId:id,forensics:{}})}catch(e){error=e.message}
 const partial={test:'Failure after persisted product update',error,persistedPricing:stored.pricing,mockedDatabase:true};
 fs.writeFileSync('admin-dashboard-audit/evidence/service-probes.json',JSON.stringify({race,partial},null,2));console.log({race,partial});
})().catch(e=>{console.error(e);process.exitCode=1});
