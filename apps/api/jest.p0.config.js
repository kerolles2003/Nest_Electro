/** P0 safety unit tests only: no application boot, database or provider access. */
const base = require('./jest.config');
module.exports = {
  ...base,
  testMatch: ['**/test/database/scratch-run.spec.ts', '**/test/setup/email-isolation.spec.ts'],
  globalSetup: undefined,
  globalTeardown: undefined,
  setupFiles: ['<rootDir>/test/setup/email-isolation.ts'],
};
