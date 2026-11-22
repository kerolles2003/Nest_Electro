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
 * PAY-3 fulfilment gate (owner decision, 2026-11-21).
 *
 * The rule under test, enforced in OrderLifecycleService:
 *
 *  - A Wallet/InstaPay order MUST NOT enter fulfilment (CONFIRMED or
 *    SHIPPED, including a re-dispatch after a failed delivery) until its
 *    payment is PAID, and PAID is reachable only through the authorized
 *    manual verification workflow.
 *  - COD orders are NOT gated: they fulfil unpaid and become PAID only
 *    when cash collection is confirmed at DELIVERED.
 *
 * Scenarios map 1:1 to the remediation brief: pending blocked, rejected
 * blocked, PAID passes, COD passes unpaid, shipping does not pay COD,
 * delivery pays COD, a verify/confirm race cannot bypass the gate,
 * alternate paths (direct ship, retry-shipment on pre-gate data) cannot
 * bypass it, unauthorized actors cannot bypass it, and the valid walks
 * still work end to end.
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
  const email = `pay3-${label}.${RUN_ID}@example.test`;

  await http()
    .post('/api/v1/auth/register')
    .send({ email, password: PASSWORD, fullName: `Pay3 ${label}` })
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
    sku: `PAY3-TEST-${RUN_ID}`,
    slug: `pay3-test-${RUN_ID}`,
    name: { en: 'PAY-3 Gate Test Product', ar: null },
    shortDescription: { en: 'Created by the pay3-fulfilment-gate suite.', ar: null },
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
  // The API renders money as a Money object; the amount the verification
  // must match is the stored integer on the order row.
  const row = await orderRow(id);
  return { id, grandTotal: row.pricing.grandTotal };
}

async function orderRow(id: string): Promise<OrderLean> {
  return (await orders.findById(id).lean<OrderLean>().exec()) as OrderLean;
}

function staff(id: string, action: string, who: Account = admin): request.Test {
  return http().post(`/api/v1/admin/orders/${id}/${action}`).set(...bearer(who));
}

function ship(id: string, who: Account = admin): request.Test {
  return staff(id, 'ship', who).send({ carrier: 'Aramex', trackingNumber: 'ARX-111222333' });
}

async function verifyPaid(id: string, grandTotal: number): Promise<void> {
  await http()
    .post(`/api/v1/admin/orders/${id}/payment/verify`)
    .set(...bearer(admin))
    .send({ confirmedAmount: grandTotal })
    .expect(200);
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

describe('manual transfers are blocked until PAID', () => {
  it('1. a WALLET order in PENDING_VERIFICATION cannot be confirmed (the first fulfilment step)', async () => {
    const { id } = await placeOrder('WALLET');
    expect((await orderRow(id)).payment.status).toBe('PENDING_VERIFICATION');

    const refused = await staff(id, 'confirm').send({});
    expect(refused.status).toBe(422);
    expect(refused.body.error.code).toBe('PAYMENT_REQUIRED_BEFORE_FULFILMENT');

    expect((await orderRow(id)).status).toBe('PLACED');
  });

  it('2. an INSTAPAY order whose payment was REJECTED cannot be confirmed or shipped', async () => {
    const { id } = await placeOrder('INSTAPAY');

    await http()
      .post(`/api/v1/admin/orders/${id}/payment/reject`)
      .set(...bearer(admin))
      .send({ reason: 'Transfer does not match this order.' })
      .expect(200);
    expect((await orderRow(id)).payment.status).toBe('VERIFICATION_REJECTED');

    const refused = await staff(id, 'confirm').send({});
    expect(refused.status).toBe(422);
    expect(refused.body.error.code).toBe('PAYMENT_REQUIRED_BEFORE_FULFILMENT');
    expect((await orderRow(id)).status).toBe('PLACED');
  });

  it('3. a WALLET order that reached PAID through verification confirms and ships normally', async () => {
    const { id, grandTotal } = await placeOrder('WALLET');
    await verifyPaid(id, grandTotal);
    expect((await orderRow(id)).payment.status).toBe('PAID');

    await staff(id, 'confirm').send({}).expect(200);
    await ship(id).expect(200);

    const row = await orderRow(id);
    expect(row.status).toBe('SHIPPED');
    expect(row.payment.status).toBe('PAID');
  });
});

describe('COD is not gated', () => {
  it('4+5. an unpaid COD order confirms and ships, and shipping does NOT pay it', async () => {
    const { id } = await placeOrder();
    expect((await orderRow(id)).payment.status).toBe('PENDING');

    await staff(id, 'confirm').send({}).expect(200);
    expect((await orderRow(id)).payment.status).toBe('PENDING');

    await ship(id).expect(200);

    const row = await orderRow(id);
    expect(row.status).toBe('SHIPPED');
    expect(row.payment.status).toBe('PENDING');
  });

  it('6. COD becomes PAID only at DELIVERED (the cash-collection confirmation)', async () => {
    const { id } = await placeOrder();

    await staff(id, 'confirm').send({}).expect(200);
    await ship(id).expect(200);
    await staff(id, 'deliver').send({}).expect(200);

    const row = await orderRow(id);
    expect(row.status).toBe('DELIVERED');
    expect(row.payment.status).toBe('PAID');
  });
});

describe('races and alternate paths', () => {
  it('7. a verify/confirm race can never leave an order in fulfilment while unpaid', async () => {
    const { id, grandTotal } = await placeOrder('WALLET');

    const [verifyRes, confirmRes] = await Promise.all([
      http()
        .post(`/api/v1/admin/orders/${id}/payment/verify`)
        .set(...bearer(admin))
        .send({ confirmedAmount: grandTotal }),
      staff(id, 'confirm').send({}),
    ]);

    expect(verifyRes.status).toBe(200);

    const row = await orderRow(id);
    // The invariant, whichever request committed first: the order may
    // only be inside fulfilment if the payment is PAID. A confirm that
    // read the pre-verification snapshot is refused (422); a confirm
    // that read the committed PAID state succeeds (200).
    if (row.status === 'CONFIRMED') {
      expect(confirmRes.status).toBe(200);
      expect(row.payment.status).toBe('PAID');
    } else {
      expect(row.status).toBe('PLACED');
      expect(confirmRes.status).toBe(422);
      expect(row.payment.status).toBe('PAID');
    }
  });

  it('8a. a direct ship attempt from PLACED is refused by the state graph, gate or no gate', async () => {
    const { id } = await placeOrder('WALLET');

    const refused = await ship(id);
    expect(refused.status).toBe(409);
    expect(refused.body.error.code).toBe('INVALID_STATE_TRANSITION');
    expect((await orderRow(id)).status).toBe('PLACED');
  });

  it('8b. retry-shipment cannot bypass the gate for pre-gate data (DELIVERY_FAILED while unpaid)', async () => {
    const { id } = await placeOrder('WALLET');

    // Simulate an order that entered fulfilment BEFORE the gate existed:
    // shipped, delivery failed, payment never verified. No API path can
    // create this state any more; only a direct write can, which is
    // exactly why the gate must also cover the re-dispatch edge.
    await orders
      .updateOne({ _id: new Types.ObjectId(id) }, { $set: { status: 'DELIVERY_FAILED' } })
      .exec();

    const refused = await staff(id, 'retry-shipment').send({});
    expect(refused.status).toBe(422);
    expect(refused.body.error.code).toBe('PAYMENT_REQUIRED_BEFORE_FULFILMENT');
    expect((await orderRow(id)).status).toBe('DELIVERY_FAILED');
  });

  it('9. a customer cannot drive fulfilment actions at all (403), and anonymous callers get 401', async () => {
    const { id, grandTotal } = await placeOrder('WALLET');
    await verifyPaid(id, grandTotal);

    const asCustomer = await staff(id, 'confirm', customer).send({});
    expect(asCustomer.status).toBe(403);

    const anonymous = await http().post(`/api/v1/admin/orders/${id}/confirm`).send({});
    expect(anonymous.status).toBe(401);

    expect((await orderRow(id)).status).toBe('PLACED');
  });
});

describe('valid behaviour remains intact', () => {
  it('10. a PAID wallet order walks the full cycle, including delivery-failed and retry-shipment', async () => {
    const { id, grandTotal } = await placeOrder('WALLET');
    await verifyPaid(id, grandTotal);

    await staff(id, 'confirm').send({}).expect(200);
    await ship(id).expect(200);
    await staff(id, 'delivery-failed').send({ reason: 'Customer unavailable' }).expect(200);
    await staff(id, 'retry-shipment').send({}).expect(200);
    await staff(id, 'deliver').send({}).expect(200);

    const row = await orderRow(id);
    expect(row.status).toBe('DELIVERED');
    expect(row.payment.status).toBe('PAID');
  });
});
