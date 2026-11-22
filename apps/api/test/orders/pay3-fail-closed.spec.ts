import { randomUUID } from 'node:crypto';

// Same owner-configured manual payment values as the manual-payment suite:
// configuration is validated at ConfigModule import, so these must be set
// before the application module is compiled.
process.env.MANUAL_PAYMENT_WALLET_NUMBER = '01099998888';
process.env.MANUAL_PAYMENT_INSTAPAY_ADDRESS = 'nest@instapay.test';
process.env.MANUAL_PAYMENT_WHATSAPP_NUMBER = '201099998888';

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
import { Order, type OrderLean } from '../../src/modules/orders/infrastructure/schemas/order.schema';
import { Role, User, type UserLean } from '../../src/modules/users/infrastructure/schemas/user.schema';

/**
 * PAY-3 gate, FAIL-CLOSED (independent-review remediation, 2026-11-22).
 *
 * The gate in OrderLifecycleService must never interpret missing,
 * null, or unrecognized payment data as COD (or as anything else
 * benign). Corrupt and pre-schema states are constructed with direct
 * native-driver writes — no API path can create them, which is the
 * point: the gate is the last line of defence for data the API did
 * not write. Every refusal asserts BOTH the HTTP response (422 +
 * PAYMENT_REQUIRED_BEFORE_FULFILMENT) and the persisted state
 * (unchanged — no silent repair, no partial transition).
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
let auditLogs: Model<AuditLog>;

const createdUserIds: Types.ObjectId[] = [];
const createdProductIds: Types.ObjectId[] = [];
const createdOrderIds: Types.ObjectId[] = [];

interface Account {
  readonly id: Types.ObjectId;
  readonly email: string;
  token: string;
  addressId: string;
}

function http(): request.Agent {
  return request(app.getHttpServer());
}

function bearer(account: Account): [string, string] {
  return ['Authorization', `Bearer ${account.token}`];
}

async function login(email: string): Promise<string> {
  const response = await http().post('/api/v1/auth/login').send({ email, password: PASSWORD }).expect(200);
  return response.body.data.accessToken as string;
}

async function createAccount(label: string, role: Role = Role.CUSTOMER): Promise<Account> {
  const email = `pay3fc-${label}.${RUN_ID}@example.test`;

  await http()
    .post('/api/v1/auth/register')
    .send({ email, password: PASSWORD, fullName: `Pay3fc ${label}` })
    .expect(201);

  await users.updateOne({ email }, { $set: { emailVerifiedAt: new Date(), role } }).exec();
  const created = (await users.findOne({ email }).lean<UserLean>().exec()) as UserLean;
  createdUserIds.push(created._id);

  const token = await login(email);

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

async function createProduct(): Promise<Types.ObjectId> {
  const category = await app
    .get<Model<Category>>(getModelToken(Category.name))
    .findOne({ slug: 'development-boards' })
    .lean<{ _id: Types.ObjectId; slug: string; name: { en: string }; path: Types.ObjectId[] }>()
    .exec();
  if (category === null) throw new Error('seed category development-boards is missing');

  const created = await products.create({
    sku: `PAY3FC-TEST-${RUN_ID}`,
    slug: `pay3fc-test-${RUN_ID}`,
    name: { en: 'PAY-3 Fail-Closed Test Product', ar: null },
    shortDescription: { en: 'Created by the pay3-fail-closed suite.', ar: null },
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

  createdProductIds.push(created._id);
  return created._id;
}

let customer: Account;
let admin: Account;
let productId: Types.ObjectId;

async function placeOrder(paymentMethod?: 'WALLET' | 'INSTAPAY'): Promise<{ id: string; grandTotal: number }> {
  await http().delete('/api/v1/cart').set(...bearer(customer)).expect(200);
  await http()
    .post('/api/v1/cart/items')
    .set(...bearer(customer))
    .send({ productId: productId.toHexString(), quantity: 1 })
    .expect(200);

  const response = await http()
    .post('/api/v1/orders')
    .set(...bearer(customer))
    .set('Idempotency-Key', randomUUID())
    .send({
      addressId: customer.addressId,
      ...(paymentMethod !== undefined
        ? { paymentMethod, transferSender: '01055554444' }
        : {}),
    })
    .expect(201);

  const id = response.body.data.id as string;
  createdOrderIds.push(new Types.ObjectId(id));
  const row = await orderRow(id);
  return { id, grandTotal: row.pricing.grandTotal };
}

async function orderRow(id: string): Promise<OrderLean> {
  return (await orders.findById(id).lean<OrderLean>().exec()) as OrderLean;
}

/**
 * Writes corruption the API would never produce, through the native
 * driver so no Mongoose casting or validation can "repair" it.
 */
async function corrupt(id: string, update: Record<string, unknown>): Promise<void> {
  await orders.collection.updateOne({ _id: new Types.ObjectId(id) }, update);
}

function staff(id: string, action: string): request.Test {
  return http().post(`/api/v1/admin/orders/${id}/${action}`).set(...bearer(admin));
}

function ship(id: string): request.Test {
  return staff(id, 'ship').send({ carrier: 'Aramex', trackingNumber: 'ARX-111222333' });
}

async function expectGateRefusal(call: request.Test): Promise<void> {
  const refused = await call;
  expect(refused.status).toBe(422);
  expect(refused.body.error.code).toBe('PAYMENT_REQUIRED_BEFORE_FULFILMENT');
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
  auditLogs = app.get<Model<AuditLog>>(getModelToken(AuditLog.name));

  productId = await createProduct();
  customer = await createAccount('customer');
  admin = await createAccount('admin', Role.ADMIN);
}, 300_000);

afterAll(async () => {
  if (createdOrderIds.length > 0) {
    await auditLogs.deleteMany({ 'entity.id': { $in: createdOrderIds } }).exec();
    await app
      .get<Model<InventoryEvent>>(getModelToken(InventoryEvent.name))
      .deleteMany({ 'reference.id': { $in: createdOrderIds } })
      .exec();
    await orders.deleteMany({ _id: { $in: createdOrderIds } }).exec();
  }
  if (createdUserIds.length > 0) {
    await auditLogs.deleteMany({ 'actor.id': { $in: createdUserIds } }).exec();
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

describe('missing or null payment data fails closed', () => {
  it('payment === undefined (subdocument absent): confirm refused, order untouched', async () => {
    const { id } = await placeOrder('WALLET');
    await corrupt(id, { $unset: { payment: '' } });
    expect((await orderRow(id)).payment).toBeUndefined();

    await expectGateRefusal(staff(id, 'confirm').send({}));

    const row = await orderRow(id);
    expect(row.status).toBe('PLACED');
    // No silent repair: the corrupt data is exactly as it was.
    expect(row.payment).toBeUndefined();
  });

  it('payment === null: confirm refused, order untouched', async () => {
    const { id } = await placeOrder('WALLET');
    await corrupt(id, { $set: { payment: null } });
    expect((await orderRow(id)).payment).toBeNull();

    await expectGateRefusal(staff(id, 'confirm').send({}));

    const row = await orderRow(id);
    expect(row.status).toBe('PLACED');
    expect(row.payment).toBeNull();
  });
});

describe('malformed payment fields fail closed', () => {
  it('payment.method === undefined: confirm refused', async () => {
    const { id } = await placeOrder('WALLET');
    await corrupt(id, { $unset: { 'payment.method': '' } });

    await expectGateRefusal(staff(id, 'confirm').send({}));
    expect((await orderRow(id)).status).toBe('PLACED');
  });

  it('unknown payment method (CARD): confirm refused — never read as COD', async () => {
    const { id } = await placeOrder('WALLET');
    await corrupt(id, { $set: { 'payment.method': 'CARD' } });

    await expectGateRefusal(staff(id, 'confirm').send({}));

    const row = await orderRow(id);
    expect(row.status).toBe('PLACED');
    expect(row.payment.method as string).toBe('CARD');
  });

  it('missing payment status: confirm refused', async () => {
    const { id } = await placeOrder('WALLET');
    await corrupt(id, { $unset: { 'payment.status': '' } });

    await expectGateRefusal(staff(id, 'confirm').send({}));
    expect((await orderRow(id)).status).toBe('PLACED');
  });

  it('unknown payment status: confirm refused', async () => {
    const { id } = await placeOrder('WALLET');
    await corrupt(id, { $set: { 'payment.status': 'PARTIALLY_PAID' } });

    await expectGateRefusal(staff(id, 'confirm').send({}));
    expect((await orderRow(id)).status).toBe('PLACED');
  });

  it('unknown method also blocks SHIPPED (via a CONFIRMED pre-gate state)', async () => {
    const { id } = await placeOrder();
    await staff(id, 'confirm').send({}).expect(200);
    await corrupt(id, { $set: { 'payment.method': 'BARTER' } });

    await expectGateRefusal(ship(id));
    expect((await orderRow(id)).status).toBe('CONFIRMED');
  });
});

describe('delivery with invalid payment data', () => {
  async function shippedCodOrder(): Promise<string> {
    const { id } = await placeOrder();
    await staff(id, 'confirm').send({}).expect(200);
    await ship(id).expect(200);
    expect((await orderRow(id)).status).toBe('SHIPPED');
    return id;
  }

  it('delivery attempt with a missing payment object: refused, never auto-paid, no 500', async () => {
    const id = await shippedCodOrder();
    await corrupt(id, { $unset: { payment: '' } });

    await expectGateRefusal(staff(id, 'deliver').send({}));

    const row = await orderRow(id);
    expect(row.status).toBe('SHIPPED');
    expect(row.payment).toBeUndefined();
  });

  it('delivery attempt with an unknown payment method: refused, payment NOT marked PAID', async () => {
    const id = await shippedCodOrder();
    await corrupt(id, { $set: { 'payment.method': 'CARD' } });

    await expectGateRefusal(staff(id, 'deliver').send({}));

    const row = await orderRow(id);
    expect(row.status).toBe('SHIPPED');
    expect(row.payment.method as string).toBe('CARD');
    expect(row.payment.status).toBe('PENDING');
  });
});

describe('controls: valid data behaves exactly as before', () => {
  it('explicit COD: confirm, ship, deliver — PAID with collectedAt only at delivery', async () => {
    const { id } = await placeOrder();

    await staff(id, 'confirm').send({}).expect(200);
    await ship(id).expect(200);
    expect((await orderRow(id)).payment.status).toBe('PENDING');

    await staff(id, 'deliver').send({}).expect(200);

    const row = await orderRow(id);
    expect(row.status).toBe('DELIVERED');
    expect(row.payment.status).toBe('PAID');
    expect(row.payment.collectedAt).not.toBeNull();
  });

  it('legacy unpaid manual order (DELIVERY_FAILED + VERIFICATION_REJECTED): retry-shipment refused', async () => {
    const { id } = await placeOrder('WALLET');
    await http()
      .post(`/api/v1/admin/orders/${id}/payment/reject`)
      .set(...bearer(admin))
      .send({ reason: 'Transfer does not match this order.' })
      .expect(200);
    await corrupt(id, { $set: { status: 'DELIVERY_FAILED' } });

    await expectGateRefusal(staff(id, 'retry-shipment').send({}));
    expect((await orderRow(id)).status).toBe('DELIVERY_FAILED');
  });

  it('delivery attempt with payment === null: refused, still SHIPPED, no 500', async () => {
    const { id, grandTotal } = await placeOrder('WALLET');
    await http()
      .post(`/api/v1/admin/orders/${id}/payment/verify`)
      .set(...bearer(admin))
      .send({ confirmedAmount: grandTotal })
      .expect(200);
    await staff(id, 'confirm').send({}).expect(200);
    await ship(id).expect(200);

    await corrupt(id, { $set: { payment: null } });
    await expectGateRefusal(staff(id, 'deliver').send({}));

    const row = await orderRow(id);
    expect(row.status).toBe('SHIPPED');
    expect(row.payment).toBeNull();
  });

  it('a gate refusal writes nothing: no history entry, no audit row, order untouched', async () => {
    const { id } = await placeOrder();
    await corrupt(id, { $unset: { payment: '' } });

    const before = await orderRow(id);
    const historyBefore = before.statusHistory?.length ?? 0;
    // Count the lifecycle's own success records specifically: the admin
    // mutation INTENT rows the middleware writes for every attempt are a
    // separate, by-design trail and are not what this test measures.
    const auditsBefore = await auditLogs
      .countDocuments({ 'entity.id': new Types.ObjectId(id), action: 'ORDER_STATUS_CHANGED' })
      .exec();

    await expectGateRefusal(staff(id, 'confirm').send({}));

    const after = await orderRow(id);
    expect(after.status).toBe('PLACED');
    expect(after.statusHistory?.length ?? 0).toBe(historyBefore);
    // updatedAt is bumped by every real write; equality proves the
    // refusal left the document byte-identical in every field that a
    // transition would have touched.
    expect(new Date(after.updatedAt).getTime()).toBe(new Date(before.updatedAt).getTime());
    const auditsAfter = await auditLogs
      .countDocuments({ 'entity.id': new Types.ObjectId(id), action: 'ORDER_STATUS_CHANGED' })
      .exec();
    expect(auditsAfter).toBe(auditsBefore);
  });

  it('verified manual order still delivers as PAID (delivery adds nothing)', async () => {
    const { id, grandTotal } = await placeOrder('INSTAPAY');
    await http()
      .post(`/api/v1/admin/orders/${id}/payment/verify`)
      .set(...bearer(admin))
      .send({ confirmedAmount: grandTotal })
      .expect(200);

    await staff(id, 'confirm').send({}).expect(200);
    await ship(id).expect(200);
    await staff(id, 'deliver').send({}).expect(200);

    const row = await orderRow(id);
    expect(row.status).toBe('DELIVERED');
    expect(row.payment.status).toBe('PAID');
  });
});
