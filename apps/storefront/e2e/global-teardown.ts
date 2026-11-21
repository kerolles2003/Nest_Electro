import { execFileSync } from 'node:child_process';
import { resolve } from 'node:path';
import { SCRATCH_DATABASE, SCRATCH_SUITE } from './origin';

/**
 * Removes everything the browser journey created.
 *
 * The journey registers a real account and places a real order, so without
 * this every run would leave residue in whatever database it pointed at. The
 * repository's standing rule for suites that touch a shared development
 * database is that they clean up after themselves by tracked identity — never
 * by `dropDatabase`, never by a broad `deleteMany({})`, and never by touching
 * seeded catalogue data.
 *
 * ## Why this shells out instead of importing a driver
 *
 * The storefront has no MongoDB dependency and should not acquire one to
 * support a test. `apps/api` already has Mongoose, so the cleanup runs there,
 * as a string handed to `node`. TypeScript never sees a Mongoose type, so
 * `tsc --noEmit` in this workspace stays honest about what this app depends on.
 *
 * ## Fails loudly
 *
 * A teardown that swallows its own errors is how residue accumulates unnoticed
 * for weeks. If cleanup cannot run, the run fails and says so.
 */

/**
 * The namespace this suite owns.
 *
 * Prefix matching is safe only inside the freshly claimed run database.
 * Previous runs are never adopted or cleaned.
 */
export const E2E_EMAIL_PREFIX = 'e2e-journey';

/**
 * Runs inside `apps/api`, where Mongoose resolves.
 *
 * Uses only the explicit test URI and current run capability inherited from
 * this process, and never prints it — it is a credential.
 */
const CLEANUP = `
const mongoose = require('mongoose');
const { readScratchRun, testServerUri, assertOwnedDatabase } = require('./dist/database/testing/scratch-run');

(async () => {
  const run = readScratchRun('storefront-e2e');
  await mongoose.connect(testServerUri(), { dbName: run.database, autoCreate: false, autoIndex: false });
  await assertOwnedDatabase(mongoose.connection.db, run);
  const db = mongoose.connection.db;

  const pattern = new RegExp('^' + process.env.E2E_EMAIL_PREFIX + '\\\\.');
  const users = await db.collection('users')
    .find({ email: pattern }, { projection: { _id: 1 } }).toArray();
  const ids = users.map((u) => u._id);

  let orders = 0;
  let restocked = 0;

  if (ids.length > 0) {
    const placed = await db.collection('orders')
      .find({ userId: { $in: ids } }, { projection: { idempotencyKey: 1 } }).toArray();
    const orderIds = placed.map((o) => o._id);

    // RESTORE THE CATALOGUE FIRST.
    //
    // Placing an order really does decrement a seeded product: '$inc' of
    // { 'stock.onHand': -q, salesCount: +q }. Deleting the order does NOT put
    // that back, so a teardown that only removed documents would quietly drain
    // stock from the shared development catalogue one run at a time, until a
    // product the journey depends on went out of stock and the suite started
    // failing for a reason nobody could see.
    //
    // The inventory EVENTS are the authority for what moved — reversing them
    // is exact, and stays correct if an order is ever partially fulfilled.
    const events = await db.collection('inventoryEvents')
      .find({ 'reference.id': { $in: orderIds } }).toArray();

    for (const event of events) {
      const delta = event.quantityDelta;
      if (typeof delta !== 'number' || delta === 0) continue;

      await db.collection('products').updateOne(
        { _id: event.productId },
        { $inc: { 'stock.onHand': -delta, salesCount: delta } },
      );
      restocked += 1;
    }

    await db.collection('inventoryEvents').deleteMany({ 'reference.id': { $in: orderIds } });

    orders = (await db.collection('orders').deleteMany({ userId: { $in: ids } })).deletedCount;
    await db.collection('carts').deleteMany({ userId: { $in: ids } });
    await db.collection('refreshTokens').deleteMany({ userId: { $in: ids } });
    await db.collection('idempotencyKeys').deleteMany({
      key: { $in: placed.map((o) => o.idempotencyKey).filter(Boolean) },
    });
    await db.collection('users').deleteMany({ _id: { $in: ids } });
  }

  // Counts only. No email address, no id, no connection string.
  console.log(
    'e2e teardown: removed ' + ids.length + ' user(s), ' + orders + ' order(s), ' +
      'reversed ' + restocked + ' stock movement(s)',
  );
  await mongoose.disconnect();
})().catch((error) => {
  console.error('e2e teardown FAILED:', error.message);
  process.exit(1);
});
`;

export default function globalTeardown(): void {
  const api = resolve(__dirname, '../../api');
  const env = { ...process.env, E2E_EMAIL_PREFIX, MONGODB_DB_NAME: SCRATCH_DATABASE };

  execFileSync(process.execPath, ['-e', CLEANUP], { cwd: api, env, stdio: 'inherit' });

  /**
   * And then PROVE it.
   *
   * The cleanup above reports what it removed, which says nothing about what
   * it missed — and what it missed is the entire failure mode. This compares
   * the database against the state preparation recorded before the run: every
   * collection's document count, and every product's stock, per SKU. Anything
   * left over fails the run and is named.
   *
   * It runs from `dist`, which the Playwright web server built before it
   * started the API.
   */
  execFileSync(
    process.execPath,
    [
      'dist/database/testing/scratch-database.cli.js',
      '--suite',
      SCRATCH_SUITE,
      '--assert-clean',
    ],
    { cwd: api, env, stdio: 'inherit' },
  );
}
