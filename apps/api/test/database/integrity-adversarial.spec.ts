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
import { Product, type ProductLean } from '../../src/modules/catalog/infrastructure/schemas/product.schema';
import { InventoryEvent } from '../../src/modules/inventory/infrastructure/schemas/inventory-event.schema';
import { IdempotencyKeyRecord } from '../../src/modules/orders/infrastructure/schemas/idempotency-key.schema';
import { Order } from '../../src/modules/orders/infrastructure/schemas/order.schema';
import { Role, User, type UserLean } from '../../src/modules/users/infrastructure/schemas/user.schema';

/**
 * ADVERSARIAL data-integrity audit (2026-11-21, third session).
 *
 * The checkout suite already races customers for limited stock and races
 * one idempotency key against itself. This suite covers the integrity
 * corners that remained:
 *
 *  - the SAME order cancelled twice at the same instant (stock must be
 *    restored exactly once — the sequential case is covered elsewhere)
 *  - two admins creating a product with the same SKU at the same instant
 *    (the unique index must produce one success and one clean refusal,
 *    never a 500 and never two rows)
 *  - checkout against a product deleted after it entered the cart
 *  - a double-submitted checkout carrying two DIFFERENT idempotency keys
 *    (the cart must be consumed atomically: at most one order)
 *
 * All assertions read the persisted database state, not just responses.
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
let inventoryEvents: Model<InventoryEvent>;
let categoryId: Types.ObjectId;

const createdUserIds: Types.ObjectId[] = [];
const createdProductIds: Types.ObjectId[] = [];
const createdOrderIds: Types.ObjectId[] = [];

interface Account {
  readonly id: Types.ObjectId;
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
  const email = `adv-int-${label}.${RUN_ID}@example.test`;

  await http()
    .post('/api/v1/auth/register')
    .send({ email, password: PASSWORD, fullName: `Adv Int ${label}` })
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

  return { id: created._id, token, addressId };
}

async function createProductDirect(stock: number): Promise<Types.ObjectId> {
  const category = await app
    .get<Model<Category>>(getModelToken(Category.name))
    .findOne({ _id: categoryId })
    .lean<{ _id: Types.ObjectId; slug: string; name: { en: string }; path: Types.ObjectId[] }>()
    .exec();
  if (category === null) throw new Error('seed category is missing');

  const tag = randomUUID().slice(0, 6);
  const created = await products.create({
    sku: `AINT-${RUN_ID}-${tag}`.toUpperCase(),
    slug: `aint-${RUN_ID}-${tag}`,
    name: { en: 'Integrity Audit Test Product', ar: null },
    shortDescription: { en: 'Created by the integrity-adversarial suite.', ar: null },
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
    stock: { onHand: stock, lowStockThreshold: 1 },
    images: [],
    specs: [],
    salesCount: 0,
    isActive: true,
    isFeatured: false,
    deletedAt: null,
    weight: null,
  });

  createdProductIds.push(created._id);
  return created._id;
}

async function stockOf(productId: Types.ObjectId): Promise<number> {
  const row = (await products.findById(productId).lean<ProductLean>().exec()) as ProductLean;
  return row.stock.onHand;
}

let customer: Account;
let admin: Account;

async function placeCodOrder(who: Account, productId: Types.ObjectId, key: string = randomUUID()): Promise<request.Response> {
  await http().delete('/api/v1/cart').set(...bearer(who)).expect(200);
  await http()
    .post('/api/v1/cart/items')
    .set(...bearer(who))
    .send({ productId: productId.toHexString(), quantity: 1 })
    .expect(200);
  const response = await http()
    .post('/api/v1/orders')
    .set(...bearer(who))
    .set('Idempotency-Key', key)
    .send({ addressId: who.addressId, paymentMethod: 'COD' });
  if (response.status === 201) createdOrderIds.push(new Types.ObjectId(response.body.data.id));
  return response;
}

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
  inventoryEvents = app.get<Model<InventoryEvent>>(getModelToken(InventoryEvent.name));

  const category = await app
    .get<Model<Category>>(getModelToken(Category.name))
    .findOne({ slug: 'development-boards' })
    .lean<{ _id: Types.ObjectId }>()
    .exec();
  if (category === null) throw new Error('seed category development-boards is missing');
  categoryId = category._id;

  customer = await createAccount('customer');
  admin = await createAccount('admin', Role.ADMIN);
}, 300_000);

afterAll(async () => {
  if (createdOrderIds.length > 0) {
    await inventoryEvents.deleteMany({ 'reference.id': { $in: createdOrderIds } }).exec();
    await orders.deleteMany({ _id: { $in: createdOrderIds } }).exec();
  }
  if (createdOrderIds.length > 0 || createdProductIds.length > 0) {
    // Audit rows key on the ENTITY: orders for order events, products for
    // the API-driven create/delete in this suite.
    await app
      .get<Model<AuditLog>>(getModelToken(AuditLog.name))
      .deleteMany({ 'entity.id': { $in: [...createdOrderIds, ...createdProductIds] } })
      .exec();
  }
  if (createdUserIds.length > 0) {
    // Intent rows for refused mutations carry the ACTOR, not the entity.
    await app
      .get<Model<AuditLog>>(getModelToken(AuditLog.name))
      .deleteMany({ 'actor.id': { $in: createdUserIds } })
      .exec();
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
    await inventoryEvents.deleteMany({ productId: { $in: createdProductIds } }).exec();
    await products.deleteMany({ _id: { $in: createdProductIds } }).exec();
  }
  await app.close();
}, 300_000);

describe('same order, cancelled twice at once', () => {
  it('restores stock exactly once and answers one 200 and one refusal', async () => {
    const productId = await createProductDirect(10);
    const placed = await placeCodOrder(customer, productId);
    expect(placed.status).toBe(201);
    const orderId = placed.body.data.id as string;
    expect(await stockOf(productId)).toBe(9);

    const cancel = (): request.Test =>
      http()
        .post(`/api/v1/orders/${orderId}/cancel`)
        .set(...bearer(customer))
        .send({ reason: 'Duplicate cancellation attempt.' });

    const [first, second] = await Promise.all([cancel(), cancel()]);
    const statuses = [first.status, second.status].sort();
    expect(statuses[0]).toBe(200);
    expect([400, 409]).toContain(statuses[1]);

    // Exactly one restoration: stock back to 10, and the ledger holds a
    // single CANCELLATION movement for this order.
    expect(await stockOf(productId)).toBe(10);
    const restorations = await inventoryEvents
      .countDocuments({ 'reference.id': new Types.ObjectId(orderId), type: 'CANCELLATION' })
      .exec();
    expect(restorations).toBe(1);
  });
});

describe('duplicate SKU created concurrently', () => {
  it('produces exactly one product and one clean refusal — never a 500', async () => {
    const tag = randomUUID().slice(0, 6);
    const body = {
      sku: `DUP-${RUN_ID}-${tag}`.toUpperCase(),
      slug: `dup-${RUN_ID}-${tag}`,
      name: { en: 'Duplicate SKU Probe' },
      categoryId: categoryId.toHexString(),
      basePrice: 15000,
    };

    const create = (): request.Test =>
      http().post('/api/v1/admin/catalog/products').set(...bearer(admin)).send(body);

    const [first, second] = await Promise.all([create(), create()]);
    const statuses = [first.status, second.status].sort();
    expect(statuses[0]).toBe(201);
    expect(statuses[1]).toBeGreaterThanOrEqual(400);
    expect(statuses[1]).toBeLessThan(500);

    for (const response of [first, second]) {
      const id = response.body?.data?.id as string | undefined;
      if (typeof id === 'string') createdProductIds.push(new Types.ObjectId(id));
    }

    const rows = await products.countDocuments({ sku: body.sku }).exec();
    expect(rows).toBe(1);
  });
});

describe('checkout against a product deleted after carting', () => {
  it('refuses the order and moves no stock', async () => {
    const productId = await createProductDirect(5);

    await http()
      .post('/api/v1/cart/items')
      .set(...bearer(customer))
      .send({ productId: productId.toHexString(), quantity: 1 })
      .expect(200);

    await http()
      .delete(`/api/v1/admin/catalog/products/${productId.toHexString()}`)
      .set(...bearer(admin))
      .expect(200);

    const response = await http()
      .post('/api/v1/orders')
      .set(...bearer(customer))
      .set('Idempotency-Key', randomUUID())
      .send({ addressId: customer.addressId, paymentMethod: 'COD' });

    expect(response.status).toBeGreaterThanOrEqual(400);
    expect(response.status).toBeLessThan(500);
    if (response.status === 201) createdOrderIds.push(new Types.ObjectId(response.body.data.id));

    const mine = await orders
      .countDocuments({ userId: customer.id, 'items.productId': productId })
      .exec();
    expect(mine).toBe(0);
    expect(await stockOf(productId)).toBe(5);
  });
});

describe('double-submitted checkout with two different keys', () => {
  it('creates at most one order for one cart', async () => {
    const productId = await createProductDirect(5);

    // The previous test deliberately leaves a deleted product in this
    // cart; start from empty so only the double-submit is under test.
    await http().delete('/api/v1/cart').set(...bearer(customer)).expect(200);
    await http()
      .post('/api/v1/cart/items')
      .set(...bearer(customer))
      .send({ productId: productId.toHexString(), quantity: 1 })
      .expect(200);

    const submit = (key: string): request.Test =>
      http()
        .post('/api/v1/orders')
        .set(...bearer(customer))
        .set('Idempotency-Key', key)
        .send({ addressId: customer.addressId, paymentMethod: 'COD' });

    const [first, second] = await Promise.all([submit(randomUUID()), submit(randomUUID())]);
    for (const response of [first, second]) {
      if (response.status === 201) createdOrderIds.push(new Types.ObjectId(response.body.data.id));
    }

    const successes = [first.status, second.status].filter(s => s === 201);
    expect(successes).toHaveLength(1);

    const mine = await orders
      .countDocuments({ userId: customer.id, 'items.productId': productId })
      .exec();
    expect(mine).toBe(1);
    expect(await stockOf(productId)).toBe(4);
  });
});
