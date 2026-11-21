import { newScratchRun } from '../../src/database/testing/scratch-run';
import { ensureCleanScratchDatabase } from '../../src/database/testing/scratch-database';

export default async function prepareScratchDatabase(): Promise<void> {
  // Always fresh, including after a crash. Old markers are not recovery authority.
  newScratchRun('api-jest');
  await ensureCleanScratchDatabase('api-jest');
}
