import { randomUUID } from 'node:crypto';

import { afterAll, beforeAll, describe, expect, it } from '@jest/globals';
import { INestApplication, ValidationPipe, VersioningType } from '@nestjs/common';
import { getModelToken } from '@nestjs/mongoose';
import { Test } from '@nestjs/testing';
import { getStorageToken, type ThrottlerStorage } from '@nestjs/throttler';
import { Model, Types } from 'mongoose';
import request from 'supertest';
import { AppModule } from '../../src/app.module';
import { validationExceptionFactory } from '../../src/common/pipes/validation-exception.factory';
import { RefreshToken } from '../../src/modules/auth/infrastructure/schemas/refresh-token.schema';
import { AuditLog } from '../../src/modules/audit/infrastructure/schemas/audit-log.schema';
import { Cart } from '../../src/modules/cart/infrastructure/schemas/cart.schema';
import { Category } from '../../src/modules/catalog/infrastructure/schemas/category.schema';
import { Product } from '../../src/modules/catalog/infrastructure/schemas/product.schema';
import { InventoryEvent } from '../../src/modules/inventory/infrastructure/schemas/inventory-event.schema';
import { IdempotencyKeyRecord } from '../../src/modules/orders/infrastructure/schemas/idempotency-key.schema';
import { Order } from '../../src/modules/orders/infrastructure/schemas/order.schema';
import { Role, User, type UserLean } from '../../src/modules/users/infrastructure/schemas/user.schema';

/**
 * ADVERSARIAL backend security audit (2026-11-21, third session).
 *
 * Auth internals (rotation, replay, token validity, rate limits, upload
 * validation) already have dedicated suites — see test/auth/* and
 * test/media/*. This suite attacks the surfaces those suites do not:
 *
 *  - NoSQL operator injection through JSON bodies and query strings
 *  - checkout body injection (payment state / pricing / status fields)
 *  - cross-customer IDOR on orders and addresses
 *  - mass assignment on the profile update
 *  - audit-log tampering routes
 *  - error-envelope leakage (driver errors, stack traces)
 *  - alg=none JWT forgery
 *  - pagination limit abuse
 *
 * Every assertion is about OBSERVED behaviour of the running application.
 */

const RUN_ID = randomUUID().slice(0, 8);
const PASSWORD = 'brass thermionic valve';
const ADDRESS = {
  fullName: 'Mina Kerolles',
  phone: '01012345678',
  street: '12 Sherif Street, Apartment 4',
  city: 'Downtown',
  governorate: 'Cairo',
};

let app: INestApplication;
let users: Model<User>;
let products: Model<Product>;
let orders: Model<Order>;

const createdUserIds: Types.ObjectId[] = [];
const createdProductIds: Types.ObjectId[] = [];
const createdOrderIds: Types.ObjectId[] = [];

interface Account {
  readonly id: Types.ObjectId;
  readonly email: string;
  readonly token: string;
  readonly addressId: string;
}

function http(): request.Agent {
  return request(app.getHttpServer());
}

function bearer(account: Account): [string, string] {
  return ['Authorization', `Bearer ${account.token}`];
}

async function createAccount(label: string, role: Role = Role.CUSTOMER): Promise<Account> {
  const email = `adv-sec-${label}.${RUN_ID}@example.test`;

  await http()
    .post('/api/v1/auth/register')
    .send({ email, password: PASSWORD, fullName: `Adv Sec ${label}` })
    .expect(201);

  await users.updateOne({ email }, { $set: { emailVerifiedAt: new Date(), role } }).exec();
  const created = (await users.findOne({ email }).lean<UserLean>().exec()) as UserLean;
  createdUserIds.push(created._id);

  const login = await http().post('/api/v1/auth/login').send({ email, password: PASSWORD }).expect(200);
  const token = login.body.data.accessToken as string;

  let addressId = '652f1a9b3c4d5e6f7a8b9c0d';
  if (role === Role.CUSTOMER) {
    const response = await http()
      .post('/api/v1/users/me/addresses')
      .set('Authorization', `Bearer ${token}`)
      .send({ label: 'Home', ...ADDRESS })
      .expect(201);
    addressId = response.body.data.id as string;
  }

  return { id: created._id, email, token, addressId };
}

let alice: Account;
let bob: Account;
let admin: Account;
let productId: Types.ObjectId;
let aliceOrderId: string;

beforeAll(async () => {
  const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(getStorageToken())
    .useValue({
      increment: () =>
        Promise.resolve({ totalHits: 1, timeToExpire: 60, isBlocked: false, timeToBlockExpire: 0 }),
    } satisfies ThrottlerStorage)
    .compile();

  app = moduleRef.createNestApplication();
  app.setGlobalPrefix('api');
  app.enableVersioning({ type: VersioningType.URI, defaultVersion: '1' });
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: { enableImplicitConversion: false },
      exceptionFactory: validationExceptionFactory,
    }),
  );
  await app.init();

  users = app.get<Model<User>>(getModelToken(User.name));
  products = app.get<Model<Product>>(getModelToken(Product.name));
  orders = app.get<Model<Order>>(getModelToken(Order.name));

  const category = await app
    .get<Model<Category>>(getModelToken(Category.name))
    .findOne({ slug: 'development-boards' })
    .lean<{ _id: Types.ObjectId; slug: string; name: { en: string }; path: Types.ObjectId[] }>()
    .exec();
  if (category === null) throw new Error('seed category development-boards is missing');

  const created = await products.create({
    sku: `ASEC-TEST-${RUN_ID}`,
    slug: `asec-test-${RUN_ID}`,
    name: { en: 'Security Audit Test Product', ar: null },
    shortDescription: { en: 'Created by the security-adversarial suite.', ar: null },
    description: null,
    category: {
      id: category._id,
      slug: category.slug,
      name: { en: category.name.en, ar: null },
      path: [...category.path, category._id],
    },
    brand: null,
    pricing: { basePrice: 20000, salePrice: null, effectivePrice: 20000, costPrice: 100 },
    currency: 'EGP',
    stock: { onHand: 50, lowStockThreshold: 5 },
    images: [],
    specs: [],
    salesCount: 0,
    isActive: true,
    isFeatured: false,
    deletedAt: null,
    weight: null,
  });
  productId = created._id;
  createdProductIds.push(created._id);

  alice = await createAccount('alice');
  bob = await createAccount('bob');
  admin = await createAccount('admin', Role.ADMIN);

  // Alice places one ordinary COD order for the IDOR probes.
  await http()
    .post('/api/v1/cart/items')
    .set(...bearer(alice))
    .send({ productId: productId.toHexString(), quantity: 1 })
    .expect(200);
  const placed = await http()
    .post('/api/v1/orders')
    .set(...bearer(alice))
    .set('Idempotency-Key', randomUUID())
    .send({ addressId: alice.addressId, paymentMethod: 'COD' })
    .expect(201);
  aliceOrderId = placed.body.data.id as string;
  createdOrderIds.push(new Types.ObjectId(aliceOrderId));
}, 300_000);

afterAll(async () => {
  if (createdOrderIds.length > 0) {
    await app
      .get<Model<AuditLog>>(getModelToken(AuditLog.name))
      .deleteMany({ 'entity.id': { $in: createdOrderIds } })
      .exec();
    await app
      .get<Model<InventoryEvent>>(getModelToken(InventoryEvent.name))
      .deleteMany({ 'reference.id': { $in: createdOrderIds } })
      .exec();
    await orders.deleteMany({ _id: { $in: createdOrderIds } }).exec();
  }
  if (createdUserIds.length > 0) {
    await orders.deleteMany({ userId: { $in: createdUserIds } }).exec();
    await app
      .get<Model<IdempotencyKeyRecord>>(getModelToken(IdempotencyKeyRecord.name))
      .deleteMany({ userId: { $in: createdUserIds } })
      .exec();
    await app
      .get<Model<Cart>>(getModelToken(Cart.name))
      .deleteMany({ userId: { $in: createdUserIds } })
      .exec();
    await app
      .get<Model<RefreshToken>>(getModelToken(RefreshToken.name))
      .deleteMany({ userId: { $in: createdUserIds } })
      .exec();
    await users.deleteMany({ _id: { $in: createdUserIds } }).exec();
  }
  if (createdProductIds.length > 0) {
    await products.deleteMany({ _id: { $in: createdProductIds } }).exec();
  }
  await app.close();
}, 300_000);

describe('NoSQL operator injection', () => {
  it('refuses object-shaped credentials at login instead of evaluating them', async () => {
    const response = await http()
      .post('/api/v1/auth/login')
      .send({ email: { $gt: '' }, password: { $gt: '' } });
    expect(response.status).toBe(400);

    const response2 = await http()
      .post('/api/v1/auth/login')
      .send({ email: alice.email, password: { $ne: 'wrong' } });
    expect(response2.status).toBe(400);
  });

  it('refuses an object-shaped productId in the cart', async () => {
    const response = await http()
      .post('/api/v1/cart/items')
      .set(...bearer(bob))
      .send({ productId: { $gt: '' }, quantity: 1 });
    expect(response.status).toBe(400);
  });

  it('does not honour query-string operators on the catalogue', async () => {
    // If brand[$ne]=<nothing-real> were evaluated as an operator, it would
    // match almost every product. Neutralised, it matches none (or 400s).
    const response = await http().get('/api/v1/products?brand[$ne]=no-such-brand-zzz');
    expect([200, 400]).toContain(response.status);
    if (response.status === 200) {
      expect(response.body.data.items).toHaveLength(0);
    }

    const response2 = await http().get('/api/v1/products?q[$where]=sleep(1000)');
    expect(response2.status).not.toBe(500);

    const response3 = await http().get('/api/v1/products?category[$gt]=');
    expect(response3.status).not.toBe(500);
  });
});

describe('checkout body injection', () => {
  it('refuses orders carrying payment, pricing or status fields', async () => {
    await http()
      .post('/api/v1/cart/items')
      .set(...bearer(bob))
      .send({ productId: productId.toHexString(), quantity: 1 })
      .expect(200);

    for (const injected of [
      { payment: { status: 'PAID' } },
      { status: 'DELIVERED' },
      { pricing: { grandTotal: 1 } },
      { grandTotal: 1 },
    ]) {
      const response = await http()
        .post('/api/v1/orders')
        .set(...bearer(bob))
        .set('Idempotency-Key', randomUUID())
        .send({ addressId: bob.addressId, paymentMethod: 'COD', ...injected });
      expect(response.status).toBe(400);
    }

    const bobOrders = await orders.countDocuments({ userId: bob.id }).exec();
    expect(bobOrders).toBe(0);
  });

  it("refuses checkout with another customer's address", async () => {
    const response = await http()
      .post('/api/v1/orders')
      .set(...bearer(bob))
      .set('Idempotency-Key', randomUUID())
      .send({ addressId: alice.addressId, paymentMethod: 'COD' });
    expect([400, 404]).toContain(response.status);

    const bobOrders = await orders.countDocuments({ userId: bob.id }).exec();
    expect(bobOrders).toBe(0);
  });
});

describe('cross-customer IDOR', () => {
  it("hides another customer's order identically to a nonexistent one", async () => {
    const foreign = await http().get(`/api/v1/orders/${aliceOrderId}`).set(...bearer(bob));
    const missing = await http()
      .get(`/api/v1/orders/${new Types.ObjectId().toHexString()}`)
      .set(...bearer(bob));
    expect(foreign.status).toBe(404);
    expect(missing.status).toBe(404);
    expect(foreign.body.error?.code).toBe(missing.body.error?.code);
  });

  it("refuses to cancel another customer's order", async () => {
    const response = await http()
      .post(`/api/v1/orders/${aliceOrderId}/cancel`)
      .set(...bearer(bob))
      .send({ reason: 'Trying to cancel an order that is not mine.' });
    expect(response.status).toBe(404);

    const row = await orders.findById(aliceOrderId).lean().exec();
    expect(row?.status).toBe('PLACED');
  });

  it("refuses a customer on the admin order view", async () => {
    const response = await http().get(`/api/v1/admin/orders/${aliceOrderId}`).set(...bearer(bob));
    expect(response.status).toBe(403);
  });
});

describe('mass assignment on profile update', () => {
  it('refuses role and verification fields and leaves the account untouched', async () => {
    for (const injected of [{ role: 'SUPER_ADMIN' }, { emailVerifiedAt: new Date().toISOString() }, { email: 'new@example.test' }]) {
      const response = await http().patch('/api/v1/users/me').set(...bearer(bob)).send(injected);
      expect(response.status).toBe(400);
    }

    const row = (await users.findById(bob.id).lean<UserLean>().exec()) as UserLean;
    expect(row.role).toBe(Role.CUSTOMER);
    expect(row.email).toBe(bob.email);
  });
});

describe('audit log integrity surface', () => {
  it('exposes no mutation route for audit records, even to an admin', async () => {
    const someLog = await app
      .get<Model<AuditLog>>(getModelToken(AuditLog.name))
      .findOne()
      .lean<{ _id: Types.ObjectId }>()
      .exec();
    const target = someLog?._id.toHexString() ?? new Types.ObjectId().toHexString();

    const del = await http().delete(`/api/v1/admin/audit-logs/${target}`).set(...bearer(admin));
    expect(del.status).toBe(404);

    const patch = await http()
      .patch(`/api/v1/admin/audit-logs/${target}`)
      .set(...bearer(admin))
      .send({ action: 'ORDER_CREATED' });
    expect(patch.status).toBe(404);
  });

  it('refuses customers reading the audit trail', async () => {
    const response = await http().get('/api/v1/admin/audit-logs').set(...bearer(bob));
    expect(response.status).toBe(403);
  });
});

describe('token forgery', () => {
  it('rejects an alg=none token claiming SUPER_ADMIN', async () => {
    const encode = (value: unknown): string =>
      Buffer.from(JSON.stringify(value)).toString('base64url');
    const forged =
      `${encode({ alg: 'none', typ: 'JWT' })}.` +
      `${encode({ sub: bob.id.toHexString(), role: 'SUPER_ADMIN', exp: 9999999999 })}.`;

    const response = await http().get('/api/v1/auth/me').set('Authorization', `Bearer ${forged}`);
    expect(response.status).toBe(401);

    const adminResponse = await http()
      .get('/api/v1/admin/orders')
      .set('Authorization', `Bearer ${forged}`);
    expect(adminResponse.status).toBe(401);
  });
});

describe('error envelope hygiene', () => {
  const LEAK = /CastError|MongoServerError|node_modules|\.ts:\d+|at [A-Z][A-Za-z]+ \(|stack/i;

  it('never leaks driver errors or stack traces', async () => {
    const badId = await http().get('/api/v1/orders/not-an-id').set(...bearer(alice));
    expect(badId.status).toBe(400);
    expect(JSON.stringify(badId.body)).not.toMatch(LEAK);

    const missingProduct = await http().get('/api/v1/products/definitely-not-a-product-zzz');
    expect(missingProduct.status).toBe(404);
    expect(JSON.stringify(missingProduct.body)).not.toMatch(LEAK);

    const malformed = await http()
      .post('/api/v1/auth/login')
      .set('Content-Type', 'application/json')
      .send('{"email": ');
    expect(malformed.status).toBe(400);
    expect(JSON.stringify(malformed.body)).not.toMatch(LEAK);
  });
});

describe('pagination abuse', () => {
  it('caps the catalogue page size at the documented maximum', async () => {
    const response = await http().get('/api/v1/products?limit=100000');
    if (response.status === 200) {
      expect(response.body.data.meta.limit).toBeLessThanOrEqual(100);
    } else {
      expect(response.status).toBe(400);
    }

    const negative = await http().get('/api/v1/products?limit=-5');
    expect([200, 400]).toContain(negative.status);
    expect(negative.status).not.toBe(500);
  });
});
