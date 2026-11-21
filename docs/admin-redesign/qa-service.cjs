/* Isolated presentation fixtures. Never imported by the app or a production server.
 * Run: node docs/admin-redesign/qa-service.cjs
 * Bind only to loopback. No database, credentials, uploads, or external requests.
 */
const http = require('node:http');
const now = new Date().toISOString();
const id = (n) => String(n).padStart(24, '0');
const money = (amount) => ({ amount, currency: 'EGP', formatted: `${(amount / 100).toFixed(2)} EGP` });
const localized = (en) => ({ en, ar: null });
const actor = { id: id(1), role: 'SUPER_ADMIN', name: 'Visual QA Operator', email: 'visual@example.test' };
const categories = ['Development boards', 'Sensors & modules', 'Tools & accessories'].map((name, i) => ({ id: id(10 + i), name: localized(name), slug: `category-${i}`, description: localized('Components for your next project.'), parentId: null, path: [], depth: 0, sortOrder: i, isActive: true, productCount: 3, deletedAt: null, createdAt: now, updatedAt: now }));
const brands = ['Arduino', 'Espressif', 'Waveshare'].map((name, i) => ({ ...categories[i], id: id(20 + i), name: localized(name), slug: name.toLowerCase(), website: null }));
const products = ['Arduino Uno R3 development board', 'ESP32 Wi-Fi and Bluetooth module', 'Digital temperature & humidity sensor', 'Breadboard jumper wire set', 'Precision soldering station', 'USB-C development board'].map((name, i) => ({
  id: id(30 + i), imageVersion: 0, sku: `QA-${100 + i}`, slug: `product-${i}`, name: localized(name), shortDescription: localized('A reliable component for prototyping and everyday projects.'), description: localized('Designed for makers, students and engineers.'), category: categories[i % 3], brand: brands[i % 3], pricing: { basePrice: 32500 + i * 1000, salePrice: null, effectivePrice: 32500 + i * 1000, costPrice: 15000 }, currency: 'EGP', stock: { onHand: i === 0 ? 3 : 24, lowStockThreshold: 5 }, images: [], specs: [{ key: 'voltage', label: 'Operating voltage', value: '3.3', unit: 'V', filterable: true, sortOrder: 0 }], ratingAverage: 4.5, ratingCount: 12, salesCount: 18, isActive: i !== 5, isFeatured: i === 0, deletedAt: null, seoTitle: null, seoDescription: null, weight: 100, dimensions: { length: 60, width: 40, height: 15 }, createdAt: now, updatedAt: now,
}));
const statuses = ['PLACED', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'DELIVERY_FAILED', 'CANCELLED', 'RETURNED'];
const orders = statuses.map((status, i) => ({ id: id(50 + i), orderNumber: `NE-QA-${1001 + i}`, status, payment: { method: 'COD', status: status === 'DELIVERED' ? 'PAID' : 'PENDING', collectedAt: null }, pricing: { itemsSubtotal: money(32500), discountTotal: money(0), shippingFee: money(5000), shippingPriced: true, grandTotal: money(37500), vatInclusive: true, vatRateBps: 1400 }, itemCount: 1, totalQuantity: 1, previewImagePublicId: null, placedAt: now,
  customer: { fullName: 'Visual QA Customer', email: 'customer@example.test', phone: '01000000000' }, items: [{ productId: products[0].id, sku: products[0].sku, slug: products[0].slug, name: products[0].name.en, brandName: 'Arduino', imagePublicId: null, unitPrice: money(32500), quantity: 1, lineTotal: money(32500) }], currency: 'EGP', shippingAddress: { fullName: 'Visual QA Customer', phone: '01000000000', street: '12 Example Street', city: 'Cairo', governorate: 'Cairo', postalCode: null }, customerNote: 'Presentation fixture for local QA only.', cancellation: null, shipment: null, allowedTransitions: status === 'PLACED' ? [{ to: 'CONFIRMED', action: 'confirm', requires: [] }] : [], statusHistory: [{ from: null, to: 'PLACED', actor, note: null, at: now }],
}));
const customers = Array.from({ length: 4 }, (_, i) => ({ id: id(80 + i), email: `customer${i}@example.test`, fullName: ['Salma Hassan', 'Omar Adel', 'Mariam Nabil', 'Youssef Ali'][i], phone: '01000000000', role: 'CUSTOMER', emailVerifiedAt: now, createdAt: now, orderCount: 3 + i, totalSpent: 120000, formattedTotalSpent: '1200.00 EGP', lastOrderAt: now }));
const logs = ['ORDER_CONFIRMED', 'PRODUCT_UPDATED', 'INVENTORY_ADJUSTED', 'CATEGORY_CREATED'].map((action, i) => ({ id: id(90 + i), action, actor, entity: { type: i === 0 ? 'order' : 'product', id: id(30), label: i === 0 ? orders[0].orderNumber : products[i].name.en }, changes: { before: { isActive: false }, after: { isActive: true } }, metadata: null, ip: '127.0.0.1', userAgent: null, requestId: `qa-${i}`, createdAt: now }));
const rates = ['Cairo', 'Giza', 'Alexandria', 'Aswan'].map((governorate, i) => ({ governorate, fee: 5000 + i * 1000, formattedFee: money(5000 + i * 1000).formatted, updatedAt: now }));
const coupons = [{ id: id(110), code: 'QA-WELCOME', type: 'percentage', value: 10, min_order: 100, max_discount: 50, usage_limit: 100, used_count: 12, starts_at: now, expires_at: null, is_active: true }];
const reviews = [{ id: id(120), rating: 4, title: 'Useful for a first project', comment: 'A local presentation fixture.', body: 'A local presentation fixture.', moderation_status: 'pending', is_verified_purchase: true, created_at: now, product: { name_en: products[0].name.en, slug: products[0].slug }, profiles: { full_name: 'Visual QA Customer', avatar_url: null } }];
let scenario = 'populated';
const envelope = (data) => ({ data });
function paged(data, url) {
  const list = scenario === 'empty' ? [] : data;
  const limit = Number(url.searchParams.get('limit') || 20), page = Number(url.searchParams.get('page') || 1);
  return { data: list.slice((page - 1) * limit, page * limit), meta: { page, limit, total: list.length, totalPages: Math.max(1, Math.ceil(list.length / limit)), hasNext: false, hasPrevious: page > 1 } };
}
http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://127.0.0.1:3411');
  const path = url.pathname.replace(/^\/api\/v1/, '');
  const send = (body, status = 200) => { res.writeHead(status, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' }); res.end(JSON.stringify(body)); };
  if (path === '/__qa/scenario') { scenario = url.searchParams.get('value') || 'populated'; return send({ scenario }); }
  if (path === '/auth/login' || path === '/auth/refresh') return send(envelope({ accessToken: 'local-visual-fixture', refreshToken: 'local-visual-fixture', expiresIn: 900, tokenType: 'Bearer' }));
  if (path === '/auth/logout') return send(null);
  if (path === '/auth/me') return send(envelope({ ...actor, fullName: actor.name, phone: null, emailVerifiedAt: now, lastLoginAt: now, createdAt: now }));
  if (scenario === 'error') return send({ error: { code: 'SERVICE_UNAVAILABLE', message: 'The local QA service is simulating an unavailable response.' } }, path.startsWith('/rest/v1/') ? 400 : 503);
  if (path.startsWith('/rest/v1/')) {
    const data = scenario === 'empty' ? [] : path.endsWith('/coupons') ? coupons : reviews;
    res.setHeader('Content-Range', `0-${Math.max(0, data.length - 1)}/${data.length}`);
    return send(data);
  }
  if (req.method !== 'GET') return send({ error: { code: 'QA_READ_ONLY', message: 'Visual QA fixtures are read-only. No changes were saved.' } }, 409);
  if (path === '/admin/dashboard/stats') {
    const key = url.searchParams.get('window') || '30d';
    return send(envelope({ window: { key, days: key === 'all' ? null : parseInt(key), label: key === 'all' ? 'All time' : `Last ${parseInt(key)} days`, since: null }, revenue: { delivered: money(scenario === 'empty' ? 0 : 18450000), deliveredCount: scenario === 'empty' ? 0 : 126, pipeline: money(3150000), pipelineCount: 24 }, orders: { total: orders.length, byStatus: statuses.map(status => ({ status, count: 1 })) }, products: { total: products.length, lowStockCount: 1, outOfStockCount: 0, lowStock: scenario === 'empty' ? [] : [{ id: products[0].id, name: products[0].name.en, slug: products[0].slug, sku: products[0].sku, onHand: 3, lowStockThreshold: 5 }] }, customers: { total: customers.length, newThisWeek: 2, withOrdersCount: 3 } }));
  }
  if (path === '/admin/orders/stats') return send(envelope({ byStatus: statuses.map((status, i) => ({ status, count: scenario === 'empty' ? 0 : [12, 8, 24, 126, 3, 4, 2][i] })), total: scenario === 'empty' ? 0 : 179 }));
  if (path === '/admin/orders') return send(paged(orders.filter(o => !url.searchParams.getAll('status').length || url.searchParams.getAll('status').includes(o.status)), url));
  if (path.startsWith('/admin/orders/')) return send(envelope(orders.find(o => path.endsWith(o.id)) || orders[0]));
  if (path === '/admin/catalog/slug-availability') return send(envelope({ slug: url.searchParams.get('slug'), available: true, suggestion: null }));
  if (path === '/admin/catalog/categories') return send(envelope(scenario === 'empty' ? [] : categories));
  if (path === '/admin/catalog/brands') return send(envelope(scenario === 'empty' ? [] : brands));
  if (path === '/admin/catalog/products') { const state = url.searchParams.get('state'); return send(paged(products.filter(p => state === 'draft' ? !p.isActive : state === 'published' ? p.isActive : state === 'deleted' ? p.deletedAt : true), url)); }
  if (path.startsWith('/admin/catalog/products/')) return send(envelope(products.find(p => path.endsWith(p.id)) || products[0]));
  if (path === '/admin/customers') return send(paged(customers, url));
  if (path === '/admin/audit-logs/actions') return send(envelope(logs.map(l => l.action)));
  if (path === '/admin/audit-logs') return send(paged(logs, url));
  if (path === '/admin/inventory') return send(paged(products.map(p => ({ productId: p.id, sku: p.sku, slug: p.slug, name: p.name.en, onHand: p.stock.onHand, lowStockThreshold: 5, state: p.stock.onHand < 5 ? 'LOW_STOCK' : 'IN_STOCK', isActive: p.isActive, categoryName: p.category.name.en, costPrice: p.pricing.costPrice })), url));
  if (path.endsWith('/events')) return send(paged([{ type: 'RESTOCK', quantityDelta: 24, balanceBefore: 0, balanceAfter: 24, reason: 'Local QA receipt', referenceId: null, actorName: actor.name, createdAt: now }], url));
  if (path === '/admin/inventory/reconciliation') return send(envelope({ checked: products.length, discrepancies: [] }));
  if (path === '/admin/shipping-rates') return send(envelope(scenario === 'empty' ? [] : rates));
  return send({ error: { code: 'NOT_FOUND', message: `Fixture missing: ${path}` } }, 404);
}).listen(3411, '127.0.0.1', () => console.log('Read-only visual fixtures: http://127.0.0.1:3411'));
