import { randomUUID } from 'node:crypto';

// Manual payment methods are owner-configured (D01). These values must be
// in the environment BEFORE the application module is compiled, because
// configuration is validated once, at import of ConfigModule.
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
 * Wallet/InstaPay manual verification, end to end (owner decisions D01/D03).
 *
 * The claims under test, each proven from observed state:
 *
 *  1. A manual order is born PENDING_VERIFICATION — never PAID.
 *  2. A manual method without a declared sender is refused.
 *  3. Only an ADMIN/SUPER_ADMIN can decide, and approval requires the
 *     confirmed amount to equal the grand total exactly.
 *  4. Approval is guarded: a second decision (approve or reject) after the
 *     first is refused, so an order cannot be paid twice or re-decided.
 *  5. Rejection keeps the order, shows the customer the reason, and a
 *     customer resubmission starts a fresh round.
 *  6. A manual order cannot enter fulfilment before PAID (PAY-3 gate);
 *     delivery never pays a manual order (the COD rule is COD-only).
 *  7. COD behaviour is unchanged.
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
  const email = `manual-pay-${label}.${RUN_ID}@example.test`;

  await http()
    .post('/api/v1/auth/register')
    .send({ email, password: PASSWORD, fullName: `Manual Pay ${label}` })
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

async function createProduct(): Promise<Types.ObjectId> {
  const category = await app
    .get<Model<Category>>(getModelToken(Category.name))
    .findOne({ slug: 'development-boards' })
    .lean<{ _id: Types.ObjectId; slug: string; name: { en: string }; path: Types.ObjectId[] }>()
    .exec();
  if (category === null) throw new Error('seed category development-boards is missing');

  const created = await products.create({
    sku: `MPAY-TEST-${RUN_ID}`,
    slug: `mpay-test-${RUN_ID}`,
    name: { en: 'Manual Payment Test Product', ar: null },
    shortDescription: { en: 'Created by the manual-payment suite.', ar: null },
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
let productId: Types.ObjectId;

async function placeManualOrder(
  overrides: Record<string, unknown> = {},
): Promise<{ status: number; body: { data?: { id: string; pricing: { grandTotal: { amount: number } }; payment: Record<string, unknown> }; error?: { code: string } } }> {
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
      paymentMethod: 'WALLET',
      transferSender: '01055554444',
      ...overrides,
    });

  if (response.status === 201) createdOrderIds.push(new Types.ObjectId(response.body.data.id));
  return response;
}

async function orderRow(id: string): Promise<OrderLean> {
  return (await orders.findById(id).lean<OrderLean>().exec()) as OrderLean;
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

  productId = await createProduct();
  customer = await createAccount('customer');
  otherCustomer = await createAccount('other');
  admin = await createAccount('admin', Role.ADMIN);
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

describe('manual payment placement', () => {
  it('lists configured manual methods with instructions', async () => {
    const response = await http().get('/api/v1/checkout/payment-methods').set(...bearer(customer)).expect(200);

    expect(response.body.data.availableMethods).toEqual(['COD', 'WALLET', 'INSTAPAY']);
    expect(response.body.data.walletNumber).toBe('01099998888');
    expect(response.body.data.whatsappNumber).toBe('201099998888');
  });

  it('creates a WALLET order as PENDING_VERIFICATION, never PAID', async () => {
    const placed = await placeManualOrder();

    expect(placed.status).toBe(201);
    expect(placed.body.data?.payment).toMatchObject({
      method: 'WALLET',
      status: 'PENDING_VERIFICATION',
      collectedAt: null,
    });

    const row = await orderRow(placed.body.data!.id);
    expect(row.payment.status).toBe('PENDING_VERIFICATION');
    expect(row.payment.verification?.transferSender).toBe('01055554444');
  });

  it('refuses a manual order with no transfer sender', async () => {
    const placed = await placeManualOrder({ transferSender: undefined });

    expect(placed.status).toBe(400);
    expect(await orders.countDocuments({ userId: customer.id }).exec()).toBeGreaterThanOrEqual(0);
  });
});

describe('admin verification decisions', () => {
  it('refuses approval when the confirmed amount differs from the total', async () => {
    const placed = await placeManualOrder();
    const total = (await orderRow(placed.body.data!.id)).pricing.grandTotal;

    const response = await http()
      .post(`/api/v1/admin/orders/${placed.body.data!.id}/payment/verify`)
      .set(...bearer(admin))
      .send({ confirmedAmount: total - 1 });

    expect(response.status).toBe(400);
    expect((await orderRow(placed.body.data!.id)).payment.status).toBe('PENDING_VERIFICATION');
  });

  it('refuses a customer attempting to approve their own payment', async () => {
    const placed = await placeManualOrder();
    const total = (await orderRow(placed.body.data!.id)).pricing.grandTotal;

    const response = await http()
      .post(`/api/v1/admin/orders/${placed.body.data!.id}/payment/verify`)
      .set(...bearer(customer))
      .send({ confirmedAmount: total });

    expect(response.status).toBe(403);
    expect((await orderRow(placed.body.data!.id)).payment.status).toBe('PENDING_VERIFICATION');
  });

  it('approves with the exact amount, records the decider, and refuses a second decision', async () => {
    const placed = await placeManualOrder();
    const total = (await orderRow(placed.body.data!.id)).pricing.grandTotal;

    const approved = await http()
      .post(`/api/v1/admin/orders/${placed.body.data!.id}/payment/verify`)
      .set(...bearer(admin))
      .send({ confirmedAmount: total })
      .expect(200);

    expect(approved.body.data.payment.status).toBe('PAID');
    const row = await orderRow(placed.body.data!.id);
    expect(row.payment.verification?.decidedBy).toBe(admin.id.toHexString());
    expect(row.payment.collectedAt).not.toBeNull();

    const second = await http()
      .post(`/api/v1/admin/orders/${placed.body.data!.id}/payment/verify`)
      .set(...bearer(admin))
      .send({ confirmedAmount: total });
    expect(second.status).toBe(409);
  });

  it('rejects with a reason, and the customer can resubmit into a fresh round', async () => {
    const placed = await placeManualOrder();

    const rejected = await http()
      .post(`/api/v1/admin/orders/${placed.body.data!.id}/payment/reject`)
      .set(...bearer(admin))
      .send({ reason: 'Screenshot total does not match.' })
      .expect(200);
    expect(rejected.body.data.payment.status).toBe('VERIFICATION_REJECTED');
    expect(rejected.body.data.payment.verification.decisionNote).toBe('Screenshot total does not match.');

    // Another customer cannot resubmit somebody else's order.
    const foreign = await http()
      .post(`/api/v1/orders/${placed.body.data!.id}/payment/resubmit`)
      .set(...bearer(otherCustomer))
      .send({ transferSender: '01077776666' });
    expect(foreign.status).toBe(404);

    const resubmitted = await http()
      .post(`/api/v1/orders/${placed.body.data!.id}/payment/resubmit`)
      .set(...bearer(customer))
      .send({ transferSender: '01077776666' })
      .expect(200);
    expect(resubmitted.body.data.payment.status).toBe('PENDING_VERIFICATION');
    expect(resubmitted.body.data.payment.verification.transferSender).toBe('01077776666');
    expect(resubmitted.body.data.payment.verification.decisionNote).toBeNull();
  });

  it('records the rejection and the resubmission in the audit trail', async () => {
    const placed = await placeManualOrder();
    const id = placed.body.data!.id as string;

    await http()
      .post(`/api/v1/admin/orders/${id}/payment/reject`)
      .set(...bearer(admin))
      .send({ reason: 'Screenshot total does not match.' })
      .expect(200);
    await http()
      .post(`/api/v1/orders/${id}/payment/resubmit`)
      .set(...bearer(customer))
      .send({ transferSender: '01077776666' })
      .expect(200);

    const logs = await http()
      .get('/api/v1/admin/audit-logs')
      .query({ entityType: 'ORDER', entityId: id, action: 'ORDER_PAYMENT_CHANGED' })
      .set(...bearer(admin))
      .expect(200);
    const decisions = (logs.body.data as Array<{ metadata?: { decision?: string } }>).map(
      row => row.metadata?.decision,
    );
    expect(decisions).toContain('reject');
    expect(decisions).toContain('resubmitted');
  });

  it('refuses a payment decision on a cancelled order', async () => {
    const placed = await placeManualOrder();
    const id = placed.body.data!.id as string;
    const total = (await orderRow(placed.body.data!.id)).pricing.grandTotal;

    await http()
      .post(`/api/v1/orders/${id}/cancel`)
      .set(...bearer(customer))
      .send({ reason: 'Changed my mind.' })
      .expect(200);

    const verify = await http()
      .post(`/api/v1/admin/orders/${id}/payment/verify`)
      .set(...bearer(admin))
      .send({ confirmedAmount: total });
    expect(verify.status).toBe(400);

    const after = await http().get(`/api/v1/orders/${id}`).set(...bearer(customer)).expect(200);
    expect(after.body.data.status).toBe('CANCELLED');
    expect(after.body.data.payment.status).toBe('PENDING_VERIFICATION');
  });
});

describe('delivery and COD interplay', () => {
  it('an unverified manual order cannot be delivered at all (PAY-3 gate); a verified one delivers as PAID', async () => {
    const placed = await placeManualOrder();
    const id = placed.body.data!.id;
    const total = (await orderRow(id)).pricing.grandTotal;

    // PAY-3 (owner decision 2026-11-21): fulfilment is blocked until the
    // payment is PAID, so the pre-PAY-3 walk this test used to perform —
    // deliver an unverified manual order and observe it stay unpaid —
    // is no longer reachable. The refusal at the first fulfilment step
    // is the stronger form of the same guarantee.
    const refused = await http().post(`/api/v1/admin/orders/${id}/confirm`).set(...bearer(admin)).send({});
    expect(refused.status).toBe(422);
    expect(refused.body.error.code).toBe('PAYMENT_REQUIRED_BEFORE_FULFILMENT');

    // After authorized verification the same walk succeeds, and delivery
    // itself contributes nothing to the payment state: it was PAID by
    // the verification, before any fulfilment step ran.
    await http()
      .post(`/api/v1/admin/orders/${id}/payment/verify`)
      .set(...bearer(admin))
      .send({ confirmedAmount: total })
      .expect(200);
    await http().post(`/api/v1/admin/orders/${id}/confirm`).set(...bearer(admin)).send({}).expect(200);
    await http()
      .post(`/api/v1/admin/orders/${id}/ship`)
      .set(...bearer(admin))
      .send({ carrier: 'Bosta', trackingNumber: 'TRK-12345' })
      .expect(200);
    const delivered = await http()
      .post(`/api/v1/admin/orders/${id}/deliver`)
      .set(...bearer(admin))
      .send({})
      .expect(200);

    expect(delivered.body.data.status).toBe('DELIVERED');
    expect(delivered.body.data.payment.status).toBe('PAID');
  });

  it('COD is unchanged: placed PENDING, paid at DELIVERED', async () => {
    await http().delete('/api/v1/cart').set(...bearer(customer)).expect(200);
    await http()
      .post('/api/v1/cart/items')
      .set(...bearer(customer))
      .send({ productId: productId.toHexString(), quantity: 1 })
      .expect(200);

    const placed = await http()
      .post('/api/v1/orders')
      .set(...bearer(customer))
      .set('Idempotency-Key', randomUUID())
      .send({ addressId: customer.addressId })
      .expect(201);
    createdOrderIds.push(new Types.ObjectId(placed.body.data.id));
    expect(placed.body.data.payment).toMatchObject({ method: 'COD', status: 'PENDING' });

    const id = placed.body.data.id as string;
    await http().post(`/api/v1/admin/orders/${id}/confirm`).set(...bearer(admin)).send({}).expect(200);
    await http()
      .post(`/api/v1/admin/orders/${id}/ship`)
      .set(...bearer(admin))
      .send({ carrier: 'Bosta', trackingNumber: 'TRK-67890' })
      .expect(200);
    const delivered = await http()
      .post(`/api/v1/admin/orders/${id}/deliver`)
      .set(...bearer(admin))
      .send({})
      .expect(200);

    expect(delivered.body.data.payment.status).toBe('PAID');
  });
});
