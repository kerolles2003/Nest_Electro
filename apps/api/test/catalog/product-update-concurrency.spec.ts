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
import { AuditAction, AuditEntityType } from '../../src/modules/audit/domain/audit-action';
import { AuditLog } from '../../src/modules/audit/infrastructure/schemas/audit-log.schema';
import {
  Category,
  type CategoryLean,
} from '../../src/modules/catalog/infrastructure/schemas/category.schema';
import { Product, type ProductLean } from '../../src/modules/catalog/infrastructure/schemas/product.schema';
import { Role, User, type UserLean } from '../../src/modules/users/infrastructure/schemas/user.schema';

/**
 * Deterministic concurrency proof for the product update (A05/A06).
 *
 * ## Why these tests are deterministic
 *
 * They never rely on winning a timing race. The optimistic-locking token
 * (`expectedUpdatedAt` — the `updatedAt` the editor loaded) makes the
 * interleaving explicit in the requests themselves:
 *
 *   1. Two editors load the same product (same `updatedAt`, V1).
 *   2. Editor A saves with token V1 → succeeds; the product moves to V2.
 *   3. Editor B saves with token V1 → the token is stale BY CONSTRUCTION,
 *      so the refusal is guaranteed, not probabilistic.
 *
 * The parallel test fires both saves at once with the same token. Whichever
 * transaction commits first moves `updatedAt`; the loser's token check or
 * its version-predicated write MUST then fail — exactly one 200 and one
 * 409, in either order. The assertions are on that invariant and on the
 * persisted state afterwards, never on which request won.
 *
 * Everything runs against the real AppModule and the real (scratch)
 * MongoDB replica set — the persistence behaviour itself is what is under
 * test, not a simulation of it.
 */

const RUN_ID = randomUUID().slice(0, 8);
const PASSWORD = 'brass thermionic valve';
const USER_AGENT = `CatalogueConcurrencySuite/1.0 (${RUN_ID})`;

let app: INestApplication;
let users: Model<User>;
let products: Model<Product>;
let categories: Model<Category>;
let auditLogs: Model<AuditLog>;
let refreshTokens: Model<RefreshToken>;

const createdUserIds: Types.ObjectId[] = [];
const createdProductIds: Types.ObjectId[] = [];
const createdCategoryIds: Types.ObjectId[] = [];

interface Account {
  readonly id: Types.ObjectId;
  readonly token: string;
}

let admin: Account;
let secondAdmin: Account;
let category: CategoryLean;

function http(): request.Agent {
  return request(app.getHttpServer());
}

function bearer(account: Account): [string, string] {
  return ['Authorization', `Bearer ${account.token}`];
}

async function createAccount(label: string): Promise<Account> {
  const email = `cat-conc-${label}.${RUN_ID}@example.test`;

  await http()
    .post('/api/v1/auth/register')
    .send({ email, password: PASSWORD, fullName: `Concurrency ${label}` })
    .expect(201);

  await users.updateOne({ email }, { $set: { emailVerifiedAt: new Date(), role: Role.ADMIN } }).exec();

  const created = (await users.findOne({ email }).lean<UserLean>().exec()) as UserLean;
  createdUserIds.push(created._id);

  const login = await http().post('/api/v1/auth/login').send({ email, password: PASSWORD }).expect(200);

  return { id: created._id, token: login.body.data.accessToken as string };
}

async function makeProduct(): Promise<{ id: string; updatedAt: string }> {
  const tag = randomUUID().slice(0, 6);
  const response = await http()
    .post('/api/v1/admin/catalog/products')
    .set(...bearer(admin))
    .set('User-Agent', USER_AGENT)
    .send({
      sku: `CONC-${RUN_ID}-${tag}`.toUpperCase(),
      slug: `conc-${RUN_ID}-${tag}`,
      name: { en: 'Original Name' },
      categoryId: category._id.toHexString(),
      basePrice: 40000,
      isActive: true,
    })
    .expect(201);

  const id = response.body.data.id as string;
  createdProductIds.push(new Types.ObjectId(id));

  return { id, updatedAt: response.body.data.updatedAt as string };
}

function patchAs(account: Account, id: string, body: Record<string, unknown>): request.Test {
  return http()
    .patch(`/api/v1/admin/catalog/products/${id}`)
    .set(...bearer(account))
    .set('User-Agent', USER_AGENT)
    .send(body);
}

async function persisted(id: string): Promise<ProductLean> {
  return products.findById(new Types.ObjectId(id)).lean<ProductLean>().exec() as Promise<ProductLean>;
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
  categories = app.get<Model<Category>>(getModelToken(Category.name));
  auditLogs = app.get<Model<AuditLog>>(getModelToken(AuditLog.name));
  refreshTokens = app.get<Model<RefreshToken>>(getModelToken(RefreshToken.name));

  admin = await createAccount('operator-a');
  secondAdmin = await createAccount('operator-b');

  const made = await categories.create({
    slug: `conc-cat-${RUN_ID}`,
    name: { en: 'Instruments', ar: null },
    parentId: null,
    path: [],
    depth: 0,
  });
  createdCategoryIds.push(made._id);
  category = made.toObject<CategoryLean>();
}, 120_000);

afterAll(async () => {
  if (createdProductIds.length > 0) {
    await auditLogs.deleteMany({ 'entity.id': { $in: createdProductIds } }).exec();
    await products.deleteMany({ _id: { $in: createdProductIds } }).exec();
  }
  if (createdCategoryIds.length > 0) {
    await categories.deleteMany({ _id: { $in: createdCategoryIds } }).exec();
  }
  if (createdUserIds.length > 0) {
    await auditLogs.deleteMany({ 'actor.id': { $in: createdUserIds } }).exec();
    await refreshTokens.deleteMany({ userId: { $in: createdUserIds } }).exec();
    await users.deleteMany({ _id: { $in: createdUserIds } }).exec();
  }
  await app.close();
});

describe('optimistic locking on PATCH /admin/catalog/products/:id', () => {
  it('rejects a stale token with 409 and leaves the winner’s state untouched', async () => {
    const product = await makeProduct();

    // Editor A saves against the version both editors loaded.
    const winner = await patchAs(admin, product.id, {
      name: { en: 'Winner Name' },
      basePrice: 41000,
      expectedUpdatedAt: product.updatedAt,
    }).expect(200);
    const winnerUpdatedAt = winner.body.data.updatedAt as string;
    expect(winnerUpdatedAt).not.toBe(product.updatedAt);

    // Editor B saves against the SAME (now stale) version.
    const loser = await patchAs(secondAdmin, product.id, {
      name: { en: 'Loser Name' },
      basePrice: 42000,
      expectedUpdatedAt: product.updatedAt,
    });
    expect(loser.status).toBe(409);
    expect(loser.body.error.code).toBe('CONCURRENT_MODIFICATION');

    // The persisted product is EXACTLY the winner's state: no field of the
    // loser's payload leaked in, and the version did not move again.
    const after = await persisted(product.id);
    expect(after.name.en).toBe('Winner Name');
    expect(after.pricing.basePrice).toBe(41000);
    expect(after.updatedAt.toISOString()).toBe(winnerUpdatedAt);

    // And the audit trail holds exactly one SUCCEEDED update — the loser
    // left an intent row (outcome 'requested'), never a success row.
    const rows = await auditLogs
      .find({
        'entity.type': AuditEntityType.PRODUCT,
        'entity.id': new Types.ObjectId(product.id),
        action: { $in: [AuditAction.PRODUCT_UPDATED, AuditAction.PRODUCT_PRICE_CHANGED] },
        'metadata.outcome': 'succeeded',
      })
      .lean()
      .exec();
    expect(rows).toHaveLength(1);
  });

  it('lets exactly one of two simultaneous same-token saves win', async () => {
    const product = await makeProduct();

    const [a, b] = await Promise.all([
      patchAs(admin, product.id, { name: { en: 'Parallel A' }, expectedUpdatedAt: product.updatedAt }),
      patchAs(secondAdmin, product.id, {
        name: { en: 'Parallel B' },
        expectedUpdatedAt: product.updatedAt,
      }),
    ]);

    const statuses = [a.status, b.status].sort();
    expect(statuses).toEqual([200, 409]);

    const winnerName = a.status === 200 ? 'Parallel A' : 'Parallel B';
    const after = await persisted(product.id);
    expect(after.name.en).toBe(winnerName);
  });

  it('still accepts an update with no token, and one with the current token', async () => {
    const product = await makeProduct();

    const noToken = await patchAs(admin, product.id, { name: { en: 'No Token' } }).expect(200);

    await patchAs(admin, product.id, {
      name: { en: 'Current Token' },
      expectedUpdatedAt: noToken.body.data.updatedAt as string,
    }).expect(200);

    const after = await persisted(product.id);
    expect(after.name.en).toBe('Current Token');
  });

  it('rejects a malformed token as a validation error, not a conflict', async () => {
    const product = await makeProduct();

    const response = await patchAs(admin, product.id, { expectedUpdatedAt: 'not-a-date' });
    expect(response.status).toBe(400);
  });
});
