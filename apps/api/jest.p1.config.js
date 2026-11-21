/** P1 regressions without database boot or provider access. */
const base = require('./jest.config');
module.exports = {
  ...base,
  testMatch: ['**/test/p1/*.spec.ts', '**/test/audit/audit-diff.spec.ts'],
  globalSetup: undefined,
  globalTeardown: undefined,
  setupFiles: ['<rootDir>/test/setup/email-isolation.ts'],
};
