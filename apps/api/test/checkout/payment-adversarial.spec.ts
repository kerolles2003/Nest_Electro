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
 * ADVERSARIAL payment audit (2026-11-21, third session).
 *
 * This suite does not re-test the happy paths — test/checkout/manual-payment
 * .spec.ts owns those. It attacks the verification workflow the way a
 * hostile or careless actor would, and records what the system ACTUALLY
 * does:
 *
 *  - two admins deciding at the same instant (approve/approve, approve/reject)
 *  - an admin approving their OWN order (segregation of duties)
 *  - a stale ADMIN JWT whose database role was revoked after issue
 *  - resubmission against a cancelled order (a dead round that can never
 *    be decided, because decide() refuses terminal orders)
 *  - a decision attempted on a RETURNED order still PENDING_VERIFICATION
 *  - malformed / negative / fractional / string amounts, and an amount
 *    that omits the shipping fee
 *  - decisions attempted on a COD order, a nonexistent order, a malformed id
 *  - cross-customer resubmission (ownership)
 *  - EVIDENCE: whether fulfilment (confirm → ship → deliver) is possible
 *    while a manual payment is unverified or rejected. This test records
 *    current behaviour; the audit report interprets it.
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
  const email = `adv-pay-${label}.${RUN_ID}@example.test`;

  await http()
    .post('/api/v1/auth/register')
    .send({ email, password: PASSWORD, fullName: `Adv Pay ${label}` })
    .expect(201);

  await users.updateOne({ email }, { $set: { emailVerifiedAt: new Date(), role } }).exec();
  const created = (await users.findOne({ email }).lean<UserLean>().exec()) as UserLean;
  createdUserIds.push(created._id);

  const token = await login(email);

  // The address book refuses staff accounts (403) — only customers get one.
  // Staff accounts in this suite never order, except "boss", who starts as
  // a CUSTOMER and is promoted after ordering.
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
    sku: `APAY-TEST-${RUN_ID}`,
    slug: `apay-test-${RUN_ID}`,
    name: { en: 'Adversarial Payment Test Product', ar: null },
    shortDescription: { en: 'Created by the payment-adversarial suite.', ar: null },
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
let otherCustomer: Account;
let admin: Account;
let admin2: Account;
let productId: Types.ObjectId;

async function placeWalletOrder(who: Account = customer): Promise<string> {
  await http().delete('/api/v1/cart').set(...bearer(who)).expect(200);
  await http()
    .post('/api/v1/cart/items')
    .set(...bearer(who))
    .send({ productId: productId.toHexString(), quantity: 1 })
    .expect(200);

  const response = await http()
    .post('/api/v1/orders')
    .set(...bearer(who))
    .set('Idempotency-Key', randomUUID())
    .send({ addressId: who.addressId, paymentMethod: 'WALLET', transferSender: '01055554444' })
    .expect(201);

  const id = response.body.data.id as string;
  createdOrderIds.push(new Types.ObjectId(id));
  return id;
}

async function orderRow(id: string): Promise<OrderLean> {
  return (await orders.findById(id).lean<OrderLean>().exec()) as OrderLean;
}

function verify(id: string, who: Account, confirmedAmount: unknown): request.Test {
  return http()
    .post(`/api/v1/admin/orders/${id}/payment/verify`)
    .set(...bearer(who))
    .send({ confirmedAmount });
}

function reject(id: string, who: Account): request.Test {
  return http()
    .post(`/api/v1/admin/orders/${id}/payment/reject`)
    .set(...bearer(who))
    .send({ reason: 'Transfer does not match this order.' });
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
  otherCustomer = await createAccount('other');
  admin = await createAccount('admin', Role.ADMIN);
  admin2 = await createAccount('admin2', Role.SUPER_ADMIN);
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

describe('concurrent decisions', () => {
  it('two admins approving at once: exactly one wins, one audit row, PAID once', async () => {
    const id = await placeWalletOrder();
    const total = (await orderRow(id)).pricing.grandTotal;

    const [first, second] = await Promise.all([
      verify(id, admin, total),
      verify(id, admin2, total),
    ]);

    const statuses = [first.status, second.status].sort();
    expect(statuses).toEqual([200, 409]);

    const row = await orderRow(id);
    expect(row.payment.status).toBe('PAID');

    const decisions = await auditLogs
      .find({ 'entity.id': new Types.ObjectId(id), action: 'ORDER_PAYMENT_CHANGED' })
      .lean()
      .exec();
    const succeeded = decisions.filter(
      d => (d as { metadata?: { outcome?: string } }).metadata?.outcome === 'succeeded',
    );
    expect(succeeded).toHaveLength(1);
  });

  it('approve and reject racing: exactly one decision survives', async () => {
    const id = await placeWalletOrder();
    const total = (await orderRow(id)).pricing.grandTotal;

    const [approval, rejection] = await Promise.all([verify(id, admin, total), reject(id, admin2)]);

    const statuses = [approval.status, rejection.status].sort();
    expect(statuses).toEqual([200, 409]);

    const row = await orderRow(id);
    expect(['PAID', 'VERIFICATION_REJECTED']).toContain(row.payment.status);
    // The recorded decider must be the admin whose request returned 200.
    const winner = approval.status === 200 ? admin : admin2;
    expect(row.payment.verification?.decidedBy).toBe(winner.id.toHexString());
  });
});

describe('segregation of duties and stale authority', () => {
  it('an admin cannot approve a payment on their OWN order', async () => {
    // The boss starts as a customer so they can place the order, and is
    // promoted afterwards — the same account owns the order and holds the
    // ADMIN role when it decides.
    const boss = await createAccount('boss');
    const id = await placeWalletOrder(boss);
    const total = (await orderRow(id)).pricing.grandTotal;

    await users.updateOne({ _id: boss.id }, { $set: { role: Role.ADMIN } }).exec();
    boss.token = await login(boss.email);

    const response = await verify(id, boss, total);
    expect(response.status).toBe(403);

    const row = await orderRow(id);
    expect(row.payment.status).toBe('PENDING_VERIFICATION');
  });

  it('a token issued as ADMIN stops working for decisions once the DB role is revoked', async () => {
    const id = await placeWalletOrder();
    const total = (await orderRow(id)).pricing.grandTotal;

    // admin2's current token carries the SUPER_ADMIN claim; revoke in the DB.
    await users.updateOne({ _id: admin2.id }, { $set: { role: Role.CUSTOMER } }).exec();
    try {
      const response = await verify(id, admin2, total);
      expect(response.status).toBe(403);
      expect((await orderRow(id)).payment.status).toBe('PENDING_VERIFICATION');
    } finally {
      await users.updateOne({ _id: admin2.id }, { $set: { role: Role.SUPER_ADMIN } }).exec();
    }
  });
});

describe('terminal and returned orders', () => {
  it('resubmission is refused on a CANCELLED order (no undead verification round)', async () => {
    const id = await placeWalletOrder();
    await reject(id, admin).expect(200);

    await http()
      .post(`/api/v1/orders/${id}/cancel`)
      .set(...bearer(customer))
      .send({ reason: 'Changed my mind about this order.' })
      .expect(200);
    expect((await orderRow(id)).status).toBe('CANCELLED');

    const response = await http()
      .post(`/api/v1/orders/${id}/payment/resubmit`)
      .set(...bearer(customer))
      .send({ transferSender: '01066667777' });
    // Refused with the same STATE validation decide() uses for terminal
    // orders — before the fix this returned 200 and reopened the round.
    expect(response.status).toBe(400);

    const row = await orderRow(id);
    expect(row.payment.status).toBe('VERIFICATION_REJECTED');
  });

  it('a decision is refused on a RETURNED order still PENDING_VERIFICATION', async () => {
    const id = await placeWalletOrder();
    const total = (await orderRow(id)).pricing.grandTotal;

    // Walk the order to RETURNED without any payment decision.
    await http().post(`/api/v1/admin/orders/${id}/confirm`).set(...bearer(admin)).send({}).expect(200);
    await http()
      .post(`/api/v1/admin/orders/${id}/ship`)
      .set(...bearer(admin))
      .send({ carrier: 'Aramex', trackingNumber: 'ARX-987654321' })
      .expect(200);
    await http()
      .post(`/api/v1/admin/orders/${id}/delivery-failed`)
      .set(...bearer(admin))
      .send({ reason: 'Customer refused the parcel.' })
      .expect(200);
    await http()
      .post(`/api/v1/admin/orders/${id}/return`)
      .set(...bearer(admin))
      .send({ reason: 'Parcel came back to the warehouse.' })
      .expect(200);
    expect((await orderRow(id)).status).toBe('RETURNED');

    const response = await verify(id, admin, total);
    expect(response.status).toBe(400);
    expect((await orderRow(id)).payment.status).toBe('PENDING_VERIFICATION');
  });
});

describe('amount handling', () => {
  it('refuses negative, fractional, string, missing and off-by-one amounts', async () => {
    const id = await placeWalletOrder();
    const total = (await orderRow(id)).pricing.grandTotal;

    await verify(id, admin, -1).expect(400);
    await verify(id, admin, 1.5).expect(400);
    await verify(id, admin, String(total)).expect(400);
    await http()
      .post(`/api/v1/admin/orders/${id}/payment/verify`)
      .set(...bearer(admin))
      .send({})
      .expect(400);
    await verify(id, admin, total - 1).expect(400);
    await verify(id, admin, total + 1).expect(400);

    expect((await orderRow(id)).payment.status).toBe('PENDING_VERIFICATION');
  });

  it('refuses an amount that omits the shipping fee', async () => {
    const id = await placeWalletOrder();
    const pricing = (await orderRow(id)).pricing;
    // If the seed ships free there is nothing to omit; the off-by-one case
    // above still pins exactness. Only assert when a fee exists.
    if (pricing.shippingFee > 0) {
      await verify(id, admin, pricing.grandTotal - pricing.shippingFee).expect(400);
      expect((await orderRow(id)).payment.status).toBe('PENDING_VERIFICATION');
    }
  });
});

describe('endpoint misuse', () => {
  it('refuses decisions on a COD order, a nonexistent order, and a malformed id', async () => {
    await http().delete('/api/v1/cart').set(...bearer(customer)).expect(200);
    await http()
      .post('/api/v1/cart/items')
      .set(...bearer(customer))
      .send({ productId: productId.toHexString(), quantity: 1 })
      .expect(200);
    const cod = await http()
      .post('/api/v1/orders')
      .set(...bearer(customer))
      .set('Idempotency-Key', randomUUID())
      .send({ addressId: customer.addressId, paymentMethod: 'COD' })
      .expect(201);
    const codId = cod.body.data.id as string;
    createdOrderIds.push(new Types.ObjectId(codId));
    const codTotal = (await orderRow(codId)).pricing.grandTotal;

    await verify(codId, admin, codTotal).expect(400);
    await verify(new Types.ObjectId().toHexString(), admin, 100).expect(404);
    await verify('not-an-object-id', admin, 100).expect(400);
  });

  it('refuses unauthenticated and customer callers, and cross-customer resubmission', async () => {
    const id = await placeWalletOrder();
    const total = (await orderRow(id)).pricing.grandTotal;

    await http()
      .post(`/api/v1/admin/orders/${id}/payment/verify`)
      .send({ confirmedAmount: total })
      .expect(401);
    await verify(id, customer, total).expect(403);
    await reject(id, customer).expect(403);

    await reject(id, admin).expect(200);
    const response = await http()
      .post(`/api/v1/orders/${id}/payment/resubmit`)
      .set(...bearer(otherCustomer))
      .send({ transferSender: '01066667777' });
    expect(response.status).toBe(404);
  });
});

describe('EVIDENCE: fulfilment does not wait for verification', () => {
  it('an unverified — even rejected — manual order can be confirmed, shipped and delivered', async () => {
    const id = await placeWalletOrder();

    await reject(id, admin).expect(200);
    expect((await orderRow(id)).payment.status).toBe('VERIFICATION_REJECTED');

    await http().post(`/api/v1/admin/orders/${id}/confirm`).set(...bearer(admin)).send({}).expect(200);
    await http()
      .post(`/api/v1/admin/orders/${id}/ship`)
      .set(...bearer(admin))
      .send({ carrier: 'Aramex', trackingNumber: 'ARX-111222333' })
      .expect(200);
    await http().post(`/api/v1/admin/orders/${id}/deliver`).set(...bearer(admin)).send({}).expect(200);

    const row = await orderRow(id);
    // The goods are with the customer; the money was never verified. This
    // is recorded as audit evidence for an owner decision on fulfilment
    // gating — the lifecycle deliberately separates delivery from payment
    // for manual methods (ADR-ORDER-002), and this suite does not change
    // business rules.
    expect(row.status).toBe('DELIVERED');
    expect(row.payment.status).toBe('VERIFICATION_REJECTED');
  });
});
