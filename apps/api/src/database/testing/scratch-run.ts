import { createHash, randomBytes } from 'node:crypto';
import { parseScratchSuite, type ScratchSuite } from './scratch-databases';

/** Test-only capability. Never print or persist the capability itself. */
export interface ScratchRun {
  suite: ScratchSuite;
  id: string;
  capability: string;
  parentPid: number;
  expiresAt: number;
  database: string;
}

const KEY = 'NEST_TEST_RUN';
const TTL = 4 * 60 * 60 * 1000;
export const OWNER_COLLECTION = '__test_run_owner';

export function testServerUri(env: NodeJS.ProcessEnv = process.env): string {
  const value = env['NEST_TEST_MONGODB_URI'];
  let uri: URL;
  try {
    uri = new URL(value ?? '');
  } catch {
    throw new Error(
      'Set NEST_TEST_MONGODB_URI to a dedicated local test replica set. No .env fallback is allowed.',
    );
  }
  if (
    uri.protocol !== 'mongodb:' ||
    !['127.0.0.1', 'localhost'].includes(uri.hostname) ||
    uri.username ||
    uri.password ||
    !['', '/'].includes(uri.pathname) ||
    uri.hash ||
    !/^nest-test-[a-z0-9-]+$/.test(uri.searchParams.get('replicaSet') ?? '') ||
    [...uri.searchParams.keys()].some((k) => !['replicaSet', 'directConnection'].includes(k)) ||
    uri.searchParams.getAll('replicaSet').length !== 1
  ) {
    throw new Error(
      'Unsafe test URI: require credential-free loopback, no database path, and a dedicated nest-test-* replica set.',
    );
  }
  return uri.toString();
}

export function newScratchRun(
  suite: ScratchSuite,
  env: NodeJS.ProcessEnv = process.env,
): ScratchRun {
  testServerUri(env); // Refuse before changing any application configuration.
  const id = randomBytes(16).toString('hex');
  const run: ScratchRun = {
    suite,
    id,
    capability: randomBytes(32).toString('hex'),
    parentPid: process.pid,
    expiresAt: Date.now() + TTL,
    database: `nest_test_${suite.replaceAll('-', '_')}_${id}`,
  };
  env[KEY] = JSON.stringify(run);
  installScratchRun(run, env);
  return run;
}

export function readScratchRun(
  suite: ScratchSuite,
  env: NodeJS.ProcessEnv = process.env,
): ScratchRun {
  let run: ScratchRun;
  try {
    run = JSON.parse(env[KEY] ?? '') as ScratchRun;
  } catch {
    throw new Error('No current test-run capability; refusing database access.');
  }
  if (
    !run ||
    parseScratchSuite(run.suite) !== suite ||
    !/^[a-f0-9]{32}$/.test(run.id) ||
    !/^[a-f0-9]{64}$/.test(run.capability) ||
    run.database !== `nest_test_${suite.replaceAll('-', '_')}_${run.id}` ||
    !Number.isSafeInteger(run.parentPid) ||
    run.parentPid < 1 ||
    !Number.isSafeInteger(run.expiresAt) ||
    run.expiresAt <= Date.now() ||
    run.expiresAt > Date.now() + TTL
  ) {
    throw new Error('Invalid, expired or mismatched test-run capability.');
  }
  try {
    process.kill(run.parentPid, 0);
  } catch {
    throw new Error('Test-run owner has exited; crash residue cannot be adopted.');
  }
  testServerUri(env);
  return run;
}

export function installScratchRun(run: ScratchRun, env: NodeJS.ProcessEnv = process.env): void {
  const uri = new URL(testServerUri(env));
  uri.pathname = `/${run.database}`;
  env['MONGODB_URI'] = uri.toString();
  env['MONGODB_DB_NAME'] = run.database;
  env['EMAIL_PROVIDER'] = 'console';
  env['MEDIA_PROVIDER'] = 'memory';
}

/** Browser parent creates once; child processes inherit, never create a replacement. */
export function browserScratchRun(suite: ScratchSuite): ScratchRun {
  const run = process.env[KEY] ? readScratchRun(suite) : newScratchRun(suite);
  installScratchRun(run);
  return run;
}

export function ownerHash(run: ScratchRun): string {
  return createHash('sha256').update(run.capability).digest('hex');
}

export interface OwnershipDatabase {
  databaseName: string;
  listCollections(): { toArray(): Promise<unknown[]> };
  command(command: Record<string, unknown>): Promise<Record<string, unknown>>;
  collection(name: string): {
    insertOne(doc: Record<string, unknown>): Promise<unknown>;
    findOne(filter: Record<string, unknown>): Promise<Record<string, unknown> | null>;
    updateOne(
      filter: Record<string, unknown>,
      update: Record<string, unknown>,
    ): Promise<{ matchedCount: number }>;
  };
}

export async function assertOwnedDatabase(db: OwnershipDatabase, run: ScratchRun): Promise<void> {
  // Revalidate expiry and the live parent on every cleanup/worker entry.
  readScratchRun(run.suite, { ...process.env, [KEY]: JSON.stringify(run) });
  if (db.databaseName !== run.database)
    throw new Error('Connected database is not owned by this test run.');
  const marker = await db.collection(OWNER_COLLECTION).findOne({ _id: 'owner' });
  if (
    !marker ||
    marker['capabilityHash'] !== ownerHash(run) ||
    marker['runId'] !== run.id ||
    marker['expiresAt'] !== run.expiresAt ||
    marker['state'] !== 'active'
  ) {
    throw new Error(
      'Ownership marker absent, stale, released or belongs to another runner. Nothing may be cleaned.',
    );
  }
}

export async function claimFreshDatabase(db: OwnershipDatabase, run: ScratchRun): Promise<void> {
  readScratchRun(run.suite, { ...process.env, [KEY]: JSON.stringify(run) });
  if (db.databaseName !== run.database) throw new Error('Refusing to claim a different database.');
  const hello = await db.command({ hello: 1 });
  if (
    hello['setName'] !== new URL(testServerUri()).searchParams.get('replicaSet') ||
    hello['isWritablePrimary'] !== true
  ) {
    throw new Error('Dedicated writable test replica set required.');
  }
  if ((await db.listCollections().toArray()).length !== 0) {
    throw new Error(
      'Pre-existing database refused, even with an old ownership marker. No reset or reuse.',
    );
  }
  // Unique _id is the atomic claim: two contenders cannot both insert it.
  await db.collection(OWNER_COLLECTION).insertOne({
    _id: 'owner',
    runId: run.id,
    capabilityHash: ownerHash(run),
    expiresAt: run.expiresAt,
    state: 'active',
  });
}

export async function releaseDatabase(db: OwnershipDatabase, run: ScratchRun): Promise<void> {
  await assertOwnedDatabase(db, run);
  const result = await db
    .collection(OWNER_COLLECTION)
    .updateOne(
      { _id: 'owner', capabilityHash: ownerHash(run), state: 'active' },
      { $set: { state: 'released' } },
    );
  if (result.matchedCount !== 1) throw new Error('Test ownership changed during release.');
}
