#!/usr/bin/env node
/**
 * Runs the Cloudinary integration suite, and nothing else.
 *
 *   pnpm --filter api test:cloudinary
 *
 * ## Why a script rather than `CLOUDINARY_INTEGRATION=1 jest ...`
 *
 * That form is a shell-ism: it works in bash and is a syntax error in `cmd`,
 * which is what pnpm uses on Windows. The alternative is a `cross-env`
 * dependency added for one line. Six lines of Node cost less and behave the
 * same everywhere.
 *
 * ## Why the suite is opt-in at all
 *
 * It makes real, authenticated calls to the owner's Cloudinary account. Running
 * that from `pnpm test` would upload from every developer's machine on every
 * run, fail wherever there is no network, and bill the owner for CI — the media
 * form of the 225 live email sends F-07 found. The default suite proves the
 * same pipeline against the in-memory adapter; this proves the vendor behind it.
 */
const { spawnSync } = require('node:child_process');
const path = require('node:path');

// No application .env loading: opt-in must name a separate disposable account.
const required = [
  'NEST_TEST_MONGODB_URI',
  'NEST_TEST_CLOUDINARY_CLOUD_NAME',
  'NEST_TEST_CLOUDINARY_API_KEY',
  'NEST_TEST_CLOUDINARY_API_SECRET',
];
if (
  required.some((key) => !process.env[key]) ||
  process.env.NEST_TEST_CLOUDINARY_ACCOUNT !== 'dedicated-disposable-account' ||
  process.env.NEST_TEST_CLOUDINARY_CLOUD_NAME === process.env.CLOUDINARY_CLOUD_NAME
) {
  process.stderr.write(
    'Cloudinary tests blocked: provide an isolated test replica set, separate NEST_TEST_CLOUDINARY_* credentials and dedicated-account attestation. Application credentials are never a fallback.\n',
  );
  process.exit(1);
}

const result = spawnSync(
  process.execPath,
  [
    path.join(__dirname, '..', 'node_modules', 'jest', 'bin', 'jest.js'),
    'test/media/cloudinary-integration',
    // One at a time and no bail: every case cleans up after itself, and a
    // failure part-way through must still let the later cleanup run.
    '--runInBand',
    ...process.argv.slice(2),
  ],
  {
    cwd: path.join(__dirname, '..'),
    stdio: 'inherit',
    env: {
      ...process.env,
      CLOUDINARY_INTEGRATION: '1',
      EMAIL_PROVIDER: 'console',
      MEDIA_PROVIDER: 'memory',
    },
  },
);

process.exit(result.status ?? 1);
