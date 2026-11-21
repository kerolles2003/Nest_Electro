// Audit-only fault injection around the existing isolated presentation fixture.
// No database or external service access. Never imported by production code.
const fs = require('node:fs');
const vm = require('node:vm');
let source = fs.readFileSync('docs/admin-redesign/qa-service.cjs', 'utf8');
source = source.replace("let scenario = 'populated';", "let scenario = 'populated'; let fault = {}; let requests = [];");
source = source.replace("const send = (body, status = 200)", `if (path === '/__audit') {
  if (url.searchParams.has('fault')) fault = JSON.parse(url.searchParams.get('fault'));
  if (url.searchParams.has('reset')) requests = [];
  res.setHeader('Content-Type', 'application/json'); res.end(JSON.stringify({fault,requests})); return;
}
requests.push({path,method:req.method,query:url.search});
if (fault.match && path.includes(fault.match)) {
  if (fault.delay) await new Promise(r=>setTimeout(r,fault.delay));
  if (fault.disconnect) { req.socket.destroy(); return; }
  if (fault.status) { res.writeHead(fault.status,{'Content-Type':'application/json'}); res.end(JSON.stringify({error:{code:fault.code || 'AUDIT_FAILURE',message:'Controlled audit failure'}})); return; }
  if (fault.malformed) { res.writeHead(200,{'Content-Type':'application/json'}); res.end('{broken'); return; }
}
const send = (body, status = 200)`);
source = source.replace("{ ...actor, fullName: actor.name", "{ ...actor, role: fault.role || actor.role, fullName: actor.name");
source = source.replace('JSON.stringify(body)', `JSON.stringify(fault.large && /\\/catalog\\/(categories|brands)$/.test(path) && Array.isArray(body?.data) ? {...body,data:Array.from({length:fault.large},(_,i)=>({...body.data[0],id:String(1000+i).padStart(24,'0'),slug:'audit-'+i,parentId:null,name:{en:('Audit العربية 😀 <script>safe</script> '+i+' ').repeat(fault.long?10:1),ar:null}}))} : body)`);
vm.runInNewContext(source, {require,console,setTimeout,URL}, {filename:'audit-fixture.cjs'});
