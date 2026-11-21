import { afterEach, beforeEach, describe, expect, it, jest } from '@jest/globals';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { spawn } from 'node:child_process';
import mongoose from 'mongoose';
import { ensureCleanScratchDatabase } from '../../src/database/testing/scratch-database';
import {
  assertOwnedDatabase,
  claimFreshDatabase,
  newScratchRun,
  ownerHash,
  readScratchRun,
  releaseDatabase,
  testServerUri,
  type OwnershipDatabase,
  type ScratchRun,
} from '../../src/database/testing/scratch-run';
import {
  OwnedTestMedia,
  testCloudinaryCredentials,
} from '../../src/database/testing/test-providers';

const SERVER = 'mongodb://127.0.0.1:27019/?replicaSet=nest-test-p0';
const original = { ...process.env };
beforeEach(() => {
  process.env['NEST_TEST_MONGODB_URI'] = SERVER;
});
afterEach(() => {
  process.env = { ...original };
  jest.restoreAllMocks();
});

function fakeDatabase(run: ScratchRun) {
  let marker: Record<string, unknown> | null = null;
  let occupied = false;
  const insertOne = jest.fn(async (doc: Record<string, unknown>) => {
    if (marker) throw new Error('duplicate owner');
    marker = { ...doc };
    occupied = true;
  });
  const updateOne = jest.fn(async () => {
    if (marker) marker['state'] = 'released';
    return { matchedCount: marker ? 1 : 0 };
  });
  const db: OwnershipDatabase = {
    databaseName: run.database,
    command: async () => ({ setName: 'nest-test-p0', isWritablePrimary: true }),
    listCollections: () => ({ toArray: async () => (occupied ? [{}] : []) }),
    collection: () => ({ insertOne, findOne: async () => marker, updateOne }),
  };
  return {
    db,
    insertOne,
    updateOne,
    occupy: () => {
      occupied = true;
    },
    replace: (value: Record<string, unknown>) => {
      marker = value;
      occupied = true;
    },
  };
}

describe('P0.4 resource ownership', () => {
  it.each([
    undefined,
    'mongodb://127.0.0.1:27017/development',
    'mongodb://127.0.0.1:27017/?replicaSet=rs0',
    'mongodb+srv://example.test/',
    'mongodb://remote.example.test/?replicaSet=nest-test-p0',
    'mongodb://user:password@127.0.0.1/?replicaSet=nest-test-p0',
    ...['production', 'prod', 'live', 'staging', 'main', 'nest_electronics_scratch_api'].map(
      (name) => `mongodb://127.0.0.1/${name}?replicaSet=nest-test-p0`,
    ),
  ])('refuses unsafe URI case %# without a connection', (value) => {
    const env: NodeJS.ProcessEnv = { MONGODB_URI: SERVER };
    if (value) env['NEST_TEST_MONGODB_URI'] = value;
    expect(() => testServerUri(env)).toThrow();
  });

  it('creates independent identities, forces safe providers and never uses the developer URI', () => {
    process.env['MONGODB_URI'] = 'mongodb://invalid/development';
    process.env['EMAIL_PROVIDER'] = 'resend';
    process.env['MEDIA_PROVIDER'] = 'cloudinary';
    const a = newScratchRun('api-jest');
    const b = newScratchRun('api-jest');
    expect(a.database === b.database).toBe(false);
    expect(a.capability === b.capability).toBe(false);
    expect(process.env['MONGODB_URI']).toContain(b.database);
    expect(process.env['EMAIL_PROVIDER']).toBe('console');
    expect(process.env['MEDIA_PROVIDER']).toBe('memory');
  });

  it.each(['production', 'prod', 'live', 'staging', 'main'])(
    'cannot authorize %s by editing the manifest',
    (database) => {
      const run = newScratchRun('api-jest');
      process.env['NEST_TEST_RUN'] = JSON.stringify({ ...run, database });
      expect(() => readScratchRun('api-jest')).toThrow();
    },
  );

  it('refuses missing capability, wrong suite and expired capability', () => {
    delete process.env['NEST_TEST_RUN'];
    expect(() => readScratchRun('api-jest')).toThrow();
    const run = newScratchRun('api-jest');
    expect(() => readScratchRun('admin-e2e')).toThrow();
    process.env['NEST_TEST_RUN'] = JSON.stringify({
      ...run,
      expiresAt: Date.now() - 1,
    });
    expect(() => readScratchRun('api-jest')).toThrow();
  });

  it('refuses crash residue after the owner process exits', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    await claimFreshDatabase(f.db, run);
    jest.spyOn(process, 'kill').mockImplementation(() => {
      throw new Error('no owner');
    });
    await expect(assertOwnedDatabase(f.db, run)).rejects.toThrow('owner has exited');
    expect(f.updateOne).not.toHaveBeenCalled();
  });

  it('refuses a pre-existing DB before writing, even with a valid-looking old marker', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    f.replace({
      _id: 'owner',
      capabilityHash: ownerHash(run),
      runId: run.id,
      expiresAt: run.expiresAt,
      state: 'active',
    });
    await expect(claimFreshDatabase(f.db, run)).rejects.toThrow('Pre-existing');
    expect(f.insertOne).not.toHaveBeenCalled();
  });

  it('refuses an existing unmarked collection', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    f.occupy();
    await expect(claimFreshDatabase(f.db, run)).rejects.toThrow('Pre-existing');
    expect(f.insertOne).not.toHaveBeenCalled();
  });

  it('requires the dedicated writable replica set before claim', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    f.db.command = async () => ({ setName: 'rs0', isWritablePrimary: true });
    await expect(claimFreshDatabase(f.db, run)).rejects.toThrow('replica set');
    expect(f.insertOne).not.toHaveBeenCalled();
  });

  it('refuses a connection pointed at another database', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    f.db.databaseName = 'production';
    await expect(claimFreshDatabase(f.db, run)).rejects.toThrow();
    await expect(assertOwnedDatabase(f.db, run)).rejects.toThrow();
    expect(f.insertOne).not.toHaveBeenCalled();
  });

  it('only one concurrent claimant succeeds on the same resource', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    const results = await Promise.allSettled([
      claimFreshDatabase(f.db, run),
      claimFreshDatabase(f.db, run),
    ]);
    expect(results.filter((x) => x.status === 'fulfilled')).toHaveLength(1);
    expect(results.filter((x) => x.status === 'rejected')).toHaveLength(1);
  });

  it('two runners cannot release each other; released markers cannot be reused', async () => {
    const a = newScratchRun('api-jest');
    const b = newScratchRun('api-jest');
    const fa = fakeDatabase(a);
    const fb = fakeDatabase(b);
    await Promise.all([claimFreshDatabase(fa.db, a), claimFreshDatabase(fb.db, b)]);
    await expect(releaseDatabase(fa.db, b)).rejects.toThrow();
    expect(fa.updateOne).not.toHaveBeenCalled();
    await releaseDatabase(fa.db, a);
    await expect(assertOwnedDatabase(fa.db, a)).rejects.toThrow('released');
    await assertOwnedDatabase(fb.db, b);
  });

  it('marker without the current capability cannot grant cleanup', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    f.replace({
      _id: 'owner',
      runId: run.id,
      expiresAt: run.expiresAt,
      state: 'active',
    });
    await expect(releaseDatabase(f.db, run)).rejects.toThrow('Ownership marker');
    expect(f.updateOne).not.toHaveBeenCalled();
  });

  it('expired ownership cannot release a resource', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    await claimFreshDatabase(f.db, run);
    jest.spyOn(Date, 'now').mockReturnValue(run.expiresAt + 1);
    await expect(releaseDatabase(f.db, run)).rejects.toThrow('expired');
    expect(f.updateOne).not.toHaveBeenCalled();
  });

  it('preparation refuses a server containing developer data before creating a marker or importing seeds', async () => {
    const run = newScratchRun('api-jest');
    const f = fakeDatabase(run);
    const close = jest.fn(async () => undefined);
    const connection = {
      db: {
        ...f.db,
        admin: () => ({
          listDatabases: async () => ({ databases: [{ name: 'main' }] }),
        }),
      },
      close,
    };
    jest.spyOn(mongoose, 'createConnection').mockReturnValue({
      asPromise: async () => connection,
    } as unknown as mongoose.Connection);
    await expect(ensureCleanScratchDatabase('api-jest')).rejects.toThrow('non-test databases');
    expect(f.insertOne).not.toHaveBeenCalled();
    expect(close).toHaveBeenCalledTimes(1);
  });

  it('independent concurrent processes generate distinct run resources', async () => {
    const script = `
      const fs = require('node:fs'); const ts = require('typescript');
      require.extensions['.ts'] = (m, p) => m._compile(ts.transpileModule(fs.readFileSync(p, 'utf8'), {
        compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2023 }
      }).outputText, p);
      const { newScratchRun } = require('./src/database/testing/scratch-run.ts');
      process.stdout.write(newScratchRun('api-jest').database);
    `;
    const start = () =>
      new Promise<string>((resolveRun, reject) => {
        const child = spawn(process.execPath, ['-e', script], {
          cwd: resolve(__dirname, '../..'),
          env: { ...process.env, NEST_TEST_MONGODB_URI: SERVER },
          stdio: ['ignore', 'pipe', 'pipe'],
        });
        let output = '';
        child.stdout.on('data', (chunk: Buffer) => {
          output += chunk.toString();
        });
        child.on('error', reject);
        child.on('close', (code) =>
          code === 0 ? resolveRun(output) : reject(new Error('Independent test runner failed')),
        );
      });
    const [a, b] = await Promise.all([start(), start()]);
    expect(a).toMatch(/^nest_test_api_jest_[a-f0-9]{32}$/);
    expect(b).toMatch(/^nest_test_api_jest_[a-f0-9]{32}$/);
    expect(a === b).toBe(false);
  });
});

describe('P0.4 provider isolation', () => {
  it.each(['https://api.stripe.com/v1/charges', 'https://api.cloudinary.com/', 'https://provider.example.test/'])('blocks external fetch case %# before network access', url => {
    expect(() => fetch(url)).toThrow('P0 guard');
  });
  it('requires separate, explicitly attested Cloudinary test credentials', () => {
    expect(() => testCloudinaryCredentials({ CLOUDINARY_INTEGRATION: '1' })).toThrow();
    const env = {
      CLOUDINARY_INTEGRATION: '1',
      NEST_TEST_CLOUDINARY_ACCOUNT: 'dedicated-disposable-account',
      NEST_TEST_CLOUDINARY_CLOUD_NAME: 'unit-fixture',
      NEST_TEST_CLOUDINARY_API_KEY: 'fake',
      NEST_TEST_CLOUDINARY_API_SECRET: 'fake',
    };
    expect(() => testCloudinaryCredentials(env)).not.toThrow();
    expect(() =>
      testCloudinaryCredentials({
        ...env,
        CLOUDINARY_CLOUD_NAME: 'unit-fixture',
      }),
    ).toThrow();
  });
  it('never adopts remote-listed media or another runner prefix for cleanup', () => {
    const a = new OwnedTestMedia('dev-test/a');
    const b = new OwnedTestMedia('dev-test/b');
    a.record('dev-test/a/created');
    b.record('dev-test/b/created');
    expect(() => a.assertCreated('dev-test/a/pre-existing')).toThrow();
    expect(() => a.assertCreated('dev-test/b/created')).toThrow();
    expect(() => a.record('nest/shared')).toThrow();
    expect(() => a.assertCreated('dev-test/a/created')).not.toThrow();
  });
});

describe('P0.4 entry-point wiring', () => {
  const root = resolve(__dirname, '../../../..');
  const source = (path: string) => readFileSync(resolve(root, path), 'utf8');
  it.each(['admin', 'storefront'])(
    '%s cleanup checks ownership before any business write',
    (app) => {
      const s = source(`apps/${app}/e2e/global-teardown.ts`);
      expect(s).toContain("require('./dist/database/testing/scratch-run')");
      expect(s.indexOf('await assertOwnedDatabase(')).toBeLessThan(s.indexOf('.deleteMany('));
      expect(s).not.toContain('function readUri()');
      expect(s).not.toContain("['.env.local', '.env']");
    },
  );
  it('no harness or index-health test retains database drop', () => {
    for (const path of [
      'apps/api/src/database/testing/scratch-database.ts',
      'apps/api/test/infrastructure/index-health.spec.ts',
    ]) {
      expect(source(path)).not.toMatch(/await\s+\w+\.dropDatabase\(/);
    }
  });
  it('browser servers cannot reuse an existing developer process', () => {
    for (const path of [
      'apps/admin/playwright.shared.ts',
      'apps/storefront/playwright.config.ts',
    ]) {
      expect(source(path)).not.toMatch(/reuseExistingServer:\s*(?!false)\S/);
      expect(source(path)).toContain("MEDIA_PROVIDER: 'memory'");
      expect(source(path)).toContain('NEST_TEST_RUN:');
    }
  });
});
