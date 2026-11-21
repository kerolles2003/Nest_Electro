// Local fixtures only. No network, production storage, authentication, or API calls.
const orders = [
  [1048,'Ahmed Hassan','Cairo',3,1850,'Placed','Pending','2026-10-07','10:48'],
  [1047,'Nour Mostafa','Giza',2,725,'Confirmed','Pending','2026-10-07','10:35'],
  [1046,'Omar Youssef','Alexandria',5,3200,'Shipped','Pending','2026-10-07','10:24'],
  [1045,'Farida Adel','Mansoura',1,450,'Confirmed','Pending','2026-10-07','10:16'],
  [1044,'Youssef Nabil','Cairo',4,1640,'Delivery failed','Pending','2026-10-06','16:42'],
  [1043,'Salma Ibrahim','Tanta',2,980,'Placed','Pending','2026-10-06','15:10'],
  [1042,'Karim Emad','Giza',3,2450,'Delivered','Paid','2026-10-06','14:28'],
  [1041,'Hana Tarek','Cairo',1,350,'Delivered','Paid','2026-10-05','12:30'],
  [1040,'Ali Mahmoud','Aswan',6,4100,'Shipped','Pending','2026-10-05','11:40'],
  [1039,'Mariam Samir','Cairo',2,850,'Cancelled','Pending','2026-10-04','09:50'],
  [1038,'Seif Sherif','Zagazig',3,1275,'Returned','Pending','2026-10-03','13:25'],
  [1037,'Dina Ashraf','Giza',2,675,'Delivered','Paid','2026-10-02','08:40'],
].map(([id,name,city,items,total,status,payment,date,time])=>({id,name,city,items,total,status,payment,date,time}));
const $ = (selector) => document.querySelector(selector);
const $$ = (selector) => [...document.querySelectorAll(selector)];
const money = (value) => value.toLocaleString('en-GB',{minimumFractionDigits:2,maximumFractionDigits:2});
const esc = (value) => String(value).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const badge = (status) => `<span class="chip ${['Delivered','Paid'].includes(status)?'success':['Placed','Pending'].includes(status)?'warning':['Delivery failed','Cancelled','Returned'].includes(status)?'danger':'info'}">${esc(status)}</span>`;
let page = 1, pageSize = CONCEPT.theme==='professional'?7:5, selected = new Set(), visible = [], toastTimer;
function filteredOrders() {
  const query = $('#order-search').value.toLowerCase().trim();
  const status = $('#status-filter').value;
  const payment = $('#payment-filter').value;
  let result = orders.filter(o=>(`NE-${o.id} ${o.name} ${o.city}`.toLowerCase().includes(query))&&(status==='All statuses'||o.status===status)&&(payment==='All payments'||o.payment===payment)&&(!$('#date-from').value||o.date>=$('#date-from').value)&&(!$('#date-to').value||o.date<=$('#date-to').value));
  const sort = $('#sort').value;
  return result.sort((a,b)=>sort==='high'?b.total-a.total:sort==='low'?a.total-b.total:sort==='oldest'?a.id-b.id:b.id-a.id);
}
function render() {
  const filtered = filteredOrders();
  const status = $('#status-filter').value;
  const pages = Math.max(1,Math.ceil(filtered.length/pageSize));
  page=Math.min(page,pages);
  visible=filtered.slice((page-1)*pageSize,page*pageSize);
  $('#order-rows').innerHTML=visible.map(o=>`<tr><td><input type="checkbox" data-select="${o.id}" aria-label="Select order NE-${o.id}" ${selected.has(o.id)?'checked':''}></td><td><button class="row-action" data-order="${o.id}"><strong>NE-${o.id}</strong></button><small>${o.date.slice(8)} Oct · ${o.time}</small></td><td><strong>${o.name}</strong><small>${o.city}</small></td><td>${o.items} items</td><td class="number">${money(o.total)}</td><td>${badge(o.status)}</td><td>${badge(o.payment)}</td><td><button class="row-action" data-order="${o.id}" aria-label="View order NE-${o.id}">View ↗</button></td></tr>`).join('');
  $('#table-empty').hidden=filtered.length!==0;
  $('.table-scroll').hidden=filtered.length===0;
  $('#page-description').textContent=filtered.length?`${(page-1)*pageSize+1}–${Math.min(page*pageSize,filtered.length)} of ${filtered.length} sample orders`:'0 sample orders';
  $('#page-number').textContent=`${page} / ${pages}`;
  $('#previous-page').disabled=page<=1;$('#next-page').disabled=page>=pages;
  $$('.table-tabs button').forEach(b=>{const active=b.dataset.status===(status==='All statuses'?'All':status);b.classList.toggle('selected',active);b.setAttribute('aria-pressed',String(active));});
  updateSelection();
}
function updateSelection(){
  $('#selection-label').textContent=selected.size?`${selected.size} order${selected.size===1?'':'s'} selected`:'No orders selected';
  $('#bulk-export').disabled=selected.size===0;
  const count=visible.filter(o=>selected.has(o.id)).length;
  $('#select-all').checked=visible.length>0&&count===visible.length;
  $('#select-all').indeterminate=count>0&&count<visible.length;
}
function reset(){['#order-search','#global-search','#date-from','#date-to'].forEach(s=>$(s).value='');$('#status-filter').value='All statuses';$('#payment-filter').value='All payments';$('#sort').value='newest';page=1;selected.clear();render();}
function toast(message){clearTimeout(toastTimer);$('#toast').textContent=message;$('#toast').hidden=false;toastTimer=setTimeout(()=>$('#toast').hidden=true,4500);}
function csvExport(list){
  const data=[['Order','Customer','City','Items','Total EGP','Order status','Payment','Placed on'],...list.map(o=>[`NE-${o.id}`,o.name,o.city,o.items,o.total,o.status,o.payment,o.date])].map(row=>row.map(v=>'"'+String(v).replaceAll('"','""')+'"').join(',')).join('\r\n');
  const a=document.createElement('a');a.href=URL.createObjectURL(new Blob([data],{type:'text/csv;charset=utf-8'}));a.download='nest-sample-orders.csv';a.click();setTimeout(()=>URL.revokeObjectURL(a.href),1000);toast(`${list.length} sample orders exported.`);
}
function openDialog(selector){closePopups();$(selector).showModal();}
function closePopups(){ $$('.popup').forEach(p=>p.hidden=true);$$('[data-toggle]').forEach(b=>b.setAttribute('aria-expanded','false')); }
function detailMarkup(o){return `<div class="detail-number">NE-${o.id}</div><p>${o.name} · ${o.city}</p>${badge(o.status)} <span class="chip">Sample record</span><dl><div><dt>Order total</dt><dd>EGP ${money(o.total)}</dd></div><div><dt>Items</dt><dd>${o.items} line items</dd></div><div><dt>Payment method</dt><dd>Cash on delivery</dd></div><div><dt>Payment status</dt><dd>${badge(o.payment)}</dd></div><div><dt>Placed on</dt><dd>${o.date} · ${o.time}</dd></div></dl><h3>Activity timeline</h3><ol class="timeline"><li><span class="timeline-icon">✓</span><div><strong>Order placed</strong><p>${o.date} · ${o.time} · ${o.name}</p></div></li><li><span class="timeline-icon">${o.status==='Placed'?'○':'✓'}</span><div><strong>${o.status==='Placed'?'Awaiting confirmation':o.status}</strong><p>${o.payment==='Paid'?'Cash collected on delivery':o.status==='Delivery failed'?'Customer unavailable. Review before re-dispatch.':'Payment is collected when the order is delivered.'}</p></div></li></ol><div class="dialog-actions"><button data-close>Close</button><button class="primary" data-action="copy-order" data-id="${o.id}">Copy order number</button></div>`;}
function showOrder(id){const o=orders.find(o=>o.id===Number(id));$('#detail-title').textContent='Order details';$('#detail-content').innerHTML=detailMarkup(o);if($('#inline-detail'))$('#inline-detail').innerHTML=detailMarkup(o).replace(/<div class="dialog-actions">[\s\S]*$/,'')+`<button class="primary" data-order="${o.id}">Open full detail →</button>`;openDialog('#detail-modal');}
const modules = {
  Products: {text:'Sample catalog · 248 products. Product creation produces an unpublished draft; stock is managed separately.',rows:[['Arduino Uno R3','ARD-UNO-R3 · EGP 650.00'],['ESP32 DevKit V1','ESP32-DEV-01 · EGP 350.00'],['HC-SR04 Ultrasonic Sensor','SNS-HCSR04 · EGP 85.00'],['Breadboard 830 points','BRD-830 · EGP 95.00']]},
  Categories:{text:'Catalog categories keep components easy to find.',rows:[['Development boards','62 products'],['Sensors & modules','89 products'],['Tools & accessories','57 products'],['Power & connectivity','40 products']]},
  Brands:{text:'Sample brand directory for the electronics catalog.',rows:[['Arduino','36 products'],['Espressif','24 products'],['Waveshare','18 products'],['UNI-T','12 products']]},
  Inventory:{text:'Sample stock snapshot. Inventory adjustments require a movement type and a reason.',rows:[['ESP32 DevKit V1','8 on hand · Low stock'],['Arduino Uno R3','64 on hand · In stock'],['HC-SR04 Ultrasonic Sensor','120 on hand · In stock'],['Breadboard 830 points','46 on hand · In stock']]},
  Customers:{text:'Sample customer directory · names are illustrative.',rows:[['Ahmed Hassan','Cairo · 4 orders'],['Nour Mostafa','Giza · 2 orders'],['Omar Youssef','Alexandria · 7 orders'],['Farida Adel','Mansoura · 1 order']]},
  Reviews:{text:'Sample moderation queue. These entries demonstrate hierarchy and review states.',rows:[['Arduino Uno R3','★★★★★ · Approved'],['ESP32 DevKit V1','★★★★☆ · Pending'],['HC-SR04 sensor','★★★★★ · Approved']]},
  Coupons:{text:'Sample promotion overview.',rows:[['BUILD10','10% off · Active'],['LABWELCOME','EGP 100 off · Draft'],['SUMMER26','15% off · Expired']]},
  'Audit log':{text:'Sample audit trail · 7 October 2026.',rows:[['10:42 · Order delivered','NE-1042 · Salma Adel'],['10:28 · Inventory restocked','ARD-UNO-R3 · Mina Khalil'],['10:16 · Order confirmed','NE-1045 · Salma Adel']]},
  Settings:{text:'Workspace settings preview. Production settings are never read or changed.',rows:[['Store','Nest Electronics'],['Currency','Egyptian pound · EGP'],['Timezone','Africa/Cairo'],['Payment method','Cash on delivery'],['Shipping','Rates by governorate']]},
};
function navigate(name){
  closePopups();setSidebar(false);
  if(name==='Dashboard'){window.scrollTo({top:0,behavior:'smooth'});return;}
  if(name==='Orders'){reset();$('#orders').scrollIntoView({behavior:'smooth',block:'start'});$('#order-search').focus({preventScroll:true});return;}
  const m=modules[name];if(!m)return;
  $('#module-title').textContent=name;$('#module-content').innerHTML=`<p>${m.text}</p><ul class="module-list">${m.rows.map(([title,caption])=>`<li><strong>${title}</strong><small>${caption}</small></li>`).join('')}</ul><div class="dialog-actions">${name==='Products'?'<button class="primary" data-action="new-product">New sample product</button>':''}<button data-close>Close preview</button></div>`;openDialog('#module-modal');
}
function setSidebar(open){$('#sidebar').classList.toggle('is-open',open);$('.sidebar-shade').hidden=!open;$('.mobile-menu').setAttribute('aria-expanded',String(open));$('.mobile-menu').setAttribute('aria-label',open?'Close navigation':'Open navigation');if(matchMedia('(max-width:760px)').matches){$('#sidebar').inert=!open;$('.app-shell').inert=open;}else{$('#sidebar').inert=false;$('.app-shell').inert=false;}if(open)$('.nav-item').focus();else $('.app-shell').inert=false;}
document.addEventListener('click',e=>{
  const b=e.target.closest('button');
  if(!e.target.closest('.popup-wrap'))closePopups();
  if(!b)return;
  if(b.hasAttribute('data-close')){b.closest('dialog')?.close();return;}
  if(b.dataset.toggle){const p=$('#'+b.dataset.toggle),open=p.hidden;closePopups();p.hidden=!open;b.setAttribute('aria-expanded',String(open));return;}
  if(b.dataset.nav){navigate(b.dataset.nav);return;}
  if(b.dataset.order){showOrder(b.dataset.order);return;}
  if(b.dataset.status){$('#status-filter').value=b.dataset.status==='All'?'All statuses':b.dataset.status;page=1;render();return;}
  switch(b.dataset.action){
    case 'menu':{const open=!$('#sidebar').classList.contains('is-open');setSidebar(open);if(!open)$('.mobile-menu').focus();break;}
    case 'manage':navigate('Orders');$('#status-filter').value='Placed';render();break;
    case 'export':csvExport(filteredOrders());break;
    case 'export-selected':csvExport(orders.filter(o=>selected.has(o.id)));break;
    case 'filters':$('#advanced-filters').hidden=!$('#advanced-filters').hidden;b.setAttribute('aria-expanded',String(!$('#advanced-filters').hidden));break;
    case 'reset':reset();break;
    case 'new-product':$$('dialog[open]').forEach(d=>d.close());openDialog('#product-modal');break;
    case 'toast':toast('Sample notification: Order NE-1048 is ready for review.');break;
    case 'read-notifications':$('#notifications').innerHTML='<h3>Notifications</h3><p>You’re all caught up. No unread sample notifications.</p>';toast('All sample notifications marked as read.');break;
    case 'profile':$('#module-title').textContent='Your profile';$('#module-content').innerHTML='<p>This is an illustrative account used across all four concepts.</p><dl><div><dt>Name</dt><dd>Mina Khalil</dd></div><div><dt>Role</dt><dd>Store administrator</dd></div><div><dt>Workspace</dt><dd>Nest Electronics</dd></div></dl><div class="dialog-actions"><button data-close>Close</button></div>';openDialog('#module-modal');break;
    case 'retry':b.disabled=true;b.textContent='Retrying…';setTimeout(()=>{$('#error-content').innerHTML='<h3>Inventory loaded</h3><p>ESP32 DevKit V1 · 8 units available in this sample snapshot.</p>';b.textContent='Loaded';toast('Sample inventory loaded successfully.');},800);break;
    case 'loading':b.disabled=true;$('.skeleton-wrap').innerHTML='<div class="skeleton short"></div><div class="skeleton"></div><div class="skeleton"></div>';$('.skeleton-wrap').setAttribute('aria-label','Loading sample inventory');b.textContent='Loading…';setTimeout(()=>{$('.skeleton-wrap').innerHTML='<strong>Arduino Uno R3</strong><span class="positive">64 units available</span>';$('.skeleton-wrap').setAttribute('aria-label','Sample inventory loaded');b.textContent='Replay loading';b.disabled=false;},1300);break;
    case 'copy-order':{const value=`NE-${b.dataset.id}`;if(navigator.clipboard?.writeText)navigator.clipboard.writeText(value).then(()=>toast(`${value} copied.`)).catch(()=>toast(`Order number: ${value}`));else toast(`Order number: ${value}`);break;}
  }
  if(b.id==='previous-page'){page--;render();}if(b.id==='next-page'){page++;render();}
});
document.addEventListener('change',e=>{if(e.target.dataset.select){const id=Number(e.target.dataset.select);e.target.checked?selected.add(id):selected.delete(id);updateSelection();}if(e.target.id==='select-all'){visible.forEach(o=>e.target.checked?selected.add(o.id):selected.delete(o.id));render();}});
['#order-search','#status-filter','#sort','#date-from','#date-to','#payment-filter'].forEach(s=>$(s).addEventListener(s==='#order-search'?'input':'change',()=>{page=1;render();}));
$('#global-search').addEventListener('input',e=>{$('#order-search').value=e.target.value;page=1;render();});
$('#global-search').addEventListener('keydown',e=>{if(e.key==='Enter')$('#orders').scrollIntoView({behavior:'smooth'});});
$('#product-form').addEventListener('submit',e=>{e.preventDefault();const form=new FormData(e.target);const name=String(form.get('name')).trim();if(!name){e.target.elements.name.setCustomValidity('Enter a product name.');e.target.elements.name.reportValidity();return;}modules.Products.rows.unshift([name,`${form.get('sku')} · EGP ${money(Number(form.get('price')))} · Draft`]);$('#product-modal').close();e.target.reset();toast(`Sample draft created: ${name}.`);});
$('#product-form').elements.name.addEventListener('input',e=>e.target.setCustomValidity(''));
$('#period').addEventListener('change',e=>{const ninety=e.target.value==='90';$('#chart-total').textContent=ninety?'EGP 792,480':'EGP 284,650';$('#chart-growth').innerHTML=`↗ ${ninety?'9.4':'12.8'}% <span class="muted">vs. previous period</span>`;$('.chart-period').textContent=ninety?'· Last 90 days':'· Last 30 days';$('.kpi-0 .kpi-value').innerHTML=`${ninety?'792,480':'284,650'}<span class="currency">EGP</span>`;$('.kpi-0 .kpi-bottom').innerHTML=`<span>EGP · last ${ninety?'90':'30'} days</span><span class="positive">+${ninety?'9.4':'12.8'}%</span>`;$('#chart-title').textContent=`Delivered revenue over the last ${ninety?'90':'30'} days`;$('#chart-desc').textContent=`Illustrative trend totaling EGP ${ninety?'792,480':'284,650'}, up ${ninety?'9.4':'12.8'} percent.`;const labels=ninety?['10 Jul','28 Jul','15 Aug','02 Sep','20 Sep','07 Oct']:['08 Sep','14 Sep','20 Sep','26 Sep','02 Oct','07 Oct'];$$('.x-label').forEach((l,i)=>l.textContent=labels[i]);const axis=ninety?['45k','30k','15k','0k']:['15k','10k','5k','0k'];$$('.chart-label:not(.x-label)').forEach((l,i)=>l.textContent=axis[i]);if($('#trend-line'))$('#trend-line').style.strokeDasharray=ninety?'4 2':'none';toast('Revenue period updated. Operational queues remain unbounded.');});
document.addEventListener('keydown',e=>{if(e.key==='/'&&!['INPUT','TEXTAREA','SELECT'].includes(document.activeElement.tagName)&&!$('dialog[open]')){e.preventDefault();$('#global-search').focus();}if(e.key==='Escape'){closePopups();if($('#sidebar').classList.contains('is-open')){setSidebar(false);$('.mobile-menu').focus();}}if(e.key==='Tab'&&$('#sidebar').classList.contains('is-open')&&matchMedia('(max-width:760px)').matches){const focusable=$$('#sidebar a,#sidebar button');const first=focusable[0],last=focusable.at(-1);if(e.shiftKey&&document.activeElement===first){e.preventDefault();last.focus();}else if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first.focus();}}});
$$('dialog').forEach(d=>d.addEventListener('click',e=>{if(e.target===d){const r=d.getBoundingClientRect();if(e.clientX<r.left||e.clientX>r.right||e.clientY<r.top||e.clientY>r.bottom)d.close();}}));
const mobileQuery=matchMedia('(max-width:760px)');mobileQuery.addEventListener('change',()=>setSidebar(false));setSidebar(false);
$('#advanced-filters').hidden=CONCEPT.theme!=='professional';$('[data-action="filters"]').setAttribute('aria-expanded',String(!$('#advanced-filters').hidden));
render();
