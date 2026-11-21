import mongoose, { type Connection } from 'mongoose';
import {
  describeDrift,
  observeScratchDatabase,
  readBaseline,
  seedFingerprint,
  writeBaseline,
} from './scratch-baseline';
import type { ScratchSuite } from './scratch-databases';
import {
  assertOwnedDatabase,
  claimFreshDatabase,
  installScratchRun,
  readScratchRun,
  releaseDatabase,
  testServerUri,
  type ScratchRun,
} from './scratch-run';

export class ScratchResidueError extends Error {
  constructor(
    readonly suite: ScratchSuite,
    readonly database: string,
    readonly drift: readonly string[],
  ) {
    super(
      'Test run left residue: ' +
        drift.join('; ') +
        '. Retained for inspection; never automatically reset or adopted.',
    );
  }
}

export function useScratchDatabase(suite: ScratchSuite): string {
  const run = readScratchRun(suite);
  installScratchRun(run);
  return run.database;
}

export interface ScratchPreparation {
  readonly database: string;
  readonly rebuilt: boolean;
  readonly reasons: readonly string[];
}

async function rawConnection(run: ScratchRun): Promise<Connection> {
  return mongoose
    .createConnection(testServerUri(), {
      dbName: run.database,
      autoIndex: false,
      autoCreate: false,
      serverSelectionTimeoutMS: 5000,
    })
    .asPromise();
}

/** Claim a FRESH resource before importing AppModule, seeds or index synchronisation. */
export async function ensureCleanScratchDatabase(suite: ScratchSuite): Promise<ScratchPreparation> {
  const run = readScratchRun(suite);
  installScratchRun(run);
  const connection = await rawConnection(run);
  try {
    if (!connection.db) throw new Error('No connected test database.');
    const databases = await connection.db.admin().listDatabases({ nameOnly: true });
    if (
      databases.databases.some(
        (d) =>
          !['admin', 'local', 'config'].includes(d.name) &&
          !/^nest_test_(api_jest|storefront_e2e|admin_e2e)_[a-f0-9]{32}$/.test(d.name),
      )
    ) {
      throw new Error(
        'Test server contains non-test databases; shared/developer instances are forbidden.',
      );
    }
    await claimFreshDatabase(connection.db, run);
    await assertOwnedDatabase(connection.db, run);
    const { syncDeclaredIndexes } = await import('../sync-indexes');
    const { seedDevelopmentCatalogue } = await import('../seed/seed');
    const { seedShippingRates } = await import('../seed/shipping-seed');
    const { seedDevelopmentAdmin } = await import('../seed/dev-admin.seed');
    await syncDeclaredIndexes();
    await seedDevelopmentCatalogue();
    await seedShippingRates();
    await seedDevelopmentAdmin();
    await writeBaseline(connection, {
      suite,
      seedFingerprint: seedFingerprint(),
      preparedAt: new Date().toISOString(),
      ...(await observeScratchDatabase(connection)),
    });
    return {
      database: run.database,
      rebuilt: true,
      reasons: ['fresh run-owned resource; no database was dropped'],
    };
  } finally {
    await connection.close();
  }
}

/** Worker startup and cleanup both require the same unexpired, live-owner capability. */
export async function verifyScratchOwnership(suite: ScratchSuite): Promise<void> {
  const run = readScratchRun(suite);
  installScratchRun(run);
  const connection = await rawConnection(run);
  try {
    if (!connection.db) throw new Error('No connected test database.');
    await assertOwnedDatabase(connection.db, run);
  } finally {
    await connection.close();
  }
}

export async function assertScratchDatabaseIsClean(suite: ScratchSuite): Promise<void> {
  const run = readScratchRun(suite);
  installScratchRun(run);
  const connection = await rawConnection(run);
  try {
    if (!connection.db) throw new Error('No connected test database.');
    await assertOwnedDatabase(connection.db, run);
    const drift = describeDrift(
      await readBaseline(connection),
      await observeScratchDatabase(connection),
    );
    await releaseDatabase(connection.db, run);
    if (drift.length) throw new ScratchResidueError(suite, run.database, drift);
  } finally {
    await connection.close();
  }
}
