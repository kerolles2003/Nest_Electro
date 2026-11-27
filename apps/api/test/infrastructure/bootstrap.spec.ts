import { afterAll, beforeAll, describe, expect, it } from '@jest/globals';
import { INestApplication, VersioningType } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { getStorageToken, type ThrottlerStorage } from '@nestjs/throttler';
import request from 'supertest';
import { AppModule } from '../../src/app.module';
import { TransactionService } from '../../src/database/transaction.service';
import { ShippingRatesAdminService } from '../../src/modules/fulfilment/application/shipping-rates-admin.service';
import { MediaService } from '../../src/modules/media/application/media.service';
import { CustomersAdminService } from '../../src/modules/users/application/customers-admin.service';

/**
 * A01 regression — the composed application must actually boot.
 *
 * ## The failure this exists to end
 *
 * `CustomersAdminService`, `ShippingRatesAdminService` and `MediaService`
 * each inject `TransactionService`, but `UsersModule`, `FulfilmentModule`
 * and `MediaModule` never imported `DatabaseModule`, which is the module
 * that provides and exports it. Nest therefore failed during
 * `NestFactory.create` with `UnknownDependenciesException` — the API could
 * not start at all, while `tsc --noEmit` passed, because dependency
 * injection is a runtime graph, not a type.
 *
 * Suites that compile `AppModule` would have caught this, but the main CI
 * workflow only runs on `main` pushes and pull requests, so this branch
 * accumulated the defect ungated. This spec is deliberately the smallest
 * possible full-graph compile: it exists so the bootstrap claim — "the
 * application starts" — is tested by name, cheaply, and cannot be lost
 * inside a larger suite's setup failure.
 */
let app: INestApplication;

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
  await app.init();
});

afterAll(async () => {
  await app.close();
});

describe('application bootstrap (A01)', () => {
  it('compiles the full AppModule graph and initialises', () => {
    expect(app).toBeDefined();
  });

  it('resolves TransactionService', () => {
    expect(app.get(TransactionService)).toBeInstanceOf(TransactionService);
  });

  it('resolves every service that injects TransactionService', () => {
    expect(app.get(CustomersAdminService)).toBeInstanceOf(CustomersAdminService);
    expect(app.get(ShippingRatesAdminService)).toBeInstanceOf(ShippingRatesAdminService);
    expect(app.get(MediaService)).toBeInstanceOf(MediaService);
  });

  it('answers the health endpoint', async () => {
    // Liveness, not readiness: 200 even when the database is unhappy,
    // matching the contract index-health.spec.ts pins for this route.
    const response = await request(app.getHttpServer()).get('/api/v1/health');
    expect(response.status).toBe(200);
  });
});
