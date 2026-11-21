import { installScratchRun, readScratchRun } from '../../src/database/testing/scratch-run';
import { verifyScratchOwnership } from '../../src/database/testing/scratch-database';

// Jest awaits an exported setup function before evaluating the test's imports.
export default async function setup(): Promise<void> {
  installScratchRun(readScratchRun('api-jest'));
  await verifyScratchOwnership('api-jest');
}
