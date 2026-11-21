/** Legacy-name classification only. Ownership is exclusively enforced by scratch-run.ts. */

export const SCRATCH_SUITES = ['api-jest', 'storefront-e2e', 'admin-e2e'] as const;

export type ScratchSuite = (typeof SCRATCH_SUITES)[number];

export const SCRATCH_DATABASES: Readonly<Record<ScratchSuite, string>> = {
  'api-jest': 'nest_electronics_scratch_api',
  'storefront-e2e': 'nest_electronics_scratch_storefront',
  'admin-e2e': 'nest_electronics_scratch_admin',
};

export class NotAScratchDatabaseError extends Error {
  constructor(readonly database: string) {
    super(
      [
        `Refusing to touch the database "${database}": it is not a scratch database.`,
        '',
        'Legacy names (classification only; none may be dropped or reused):',
        ...Object.entries(SCRATCH_DATABASES).map(
          ([suite, name]) => `  ${name.padEnd(34)} ${suite}`,
        ),
        '',
        'The database name comes from MONGODB_DB_NAME, falling back to whatever is',
        'in MONGODB_URI. Seeing this almost always means MONGODB_DB_NAME was not set',
        'and the command must refuse a development database.',
      ].join('\n'),
    );
    this.name = 'NotAScratchDatabaseError';
  }
}

export function isAScratchDatabase(database: string): boolean {
  return Object.values(SCRATCH_DATABASES).includes(database);
}

export function scratchSuiteOf(database: string): ScratchSuite | null {
  return SCRATCH_SUITES.find((suite) => SCRATCH_DATABASES[suite] === database) ?? null;
}

export function assertIsAScratchDatabase(database: string): void {
  if (!isAScratchDatabase(database)) throw new NotAScratchDatabaseError(database);
}

export function parseScratchSuite(value: string | undefined): ScratchSuite {
  const suite = SCRATCH_SUITES.find((candidate) => candidate === value);

  if (suite === undefined) {
    throw new Error(
      `--suite must be one of ${SCRATCH_SUITES.join(', ')}` +
        (value === undefined ? ' (it was not given)' : `, not "${value}"`),
    );
  }

  return suite;
}
