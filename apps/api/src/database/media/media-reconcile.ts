import { stat } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { getModelToken } from '@nestjs/mongoose';
import type { Model } from 'mongoose';
import { AppModule } from '../../app.module';
import { mediaConfig, type MediaConfig } from '../../config/media.config';
import {
  reconcileMedia,
  renderMediaReconciliation,
} from '../../modules/media/application/media-reconciliation';
import {
  MediaAsset,
  type MediaAssetLean,
} from '../../modules/media/infrastructure/schemas/media-asset.schema';
import { LocalMediaStorage } from '../../providers/media/local/local-media-storage';

/**
 * The media reconciliation report.
 *
 *   pnpm --filter api media:reconcile
 *
 * ## What it is for
 *
 * The ledger is the authority for what may be served; the local disk is
 * where the bytes live. The two drift apart on any machine where catalogues
 * are rebuilt or imports re-run: each upload writes a fresh file, and the
 * superseded copies stay behind — unreachable (the delivery controller
 * refuses a publicId with no live ledger row) but still consuming disk.
 * Session 8's audit found 84 such files; development rebuilds since then
 * have added more.
 *
 * ## Why it can only report
 *
 * Deleting files is destructive and belongs to the owner. This tool writes
 * NOTHING — not to disk, not to the database. It prints the exact publicIds
 * in each gap (files with no live ledger row; live rows with no file) so
 * the deletion decision, when it is made, is made from a list rather than
 * an estimate. The second gap is the urgent one: those are broken images.
 *
 * ## Scope
 *
 * Local adapter only. Under Cloudinary the provider owns the bytes and its
 * own console is the reconciliation surface, so the tool refuses rather
 * than printing a report about a disk that is not the store.
 */

const logger = new Logger('MediaReconcile');

async function main(): Promise<void> {
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['log', 'warn', 'error'],
  });

  try {
    const media = app.get<MediaConfig>(mediaConfig.KEY);
    if (media.provider !== 'local') {
      logger.error(
        `refusing to reconcile: MEDIA_PROVIDER=${media.provider}. This report compares the ` +
          'local disk against the ledger and is meaningless for any other provider.',
      );
      process.exitCode = 1;
      return;
    }

    const assets = app.get<Model<MediaAsset>>(getModelToken(MediaAsset.name));
    const liveRows = await assets
      .find({ destroyedAt: null })
      .select({ publicId: 1, format: 1 })
      .lean<Pick<MediaAssetLean, 'publicId' | 'format'>[]>()
      .exec();

    const storage = new LocalMediaStorage(media.localDir);
    const diskPublicIds = await storage.list('');

    const report = reconcileMedia(
      diskPublicIds,
      liveRows.map((row) => row.publicId),
    );

    // Size the on-disk-only set: bytes are the number the deletion decision
    // turns on. A file that vanishes mid-report is skipped, not fatal.
    let orphanBytes = 0;
    for (const publicId of report.onDiskOnly) {
      for (const format of ['webp', 'png', 'jpg', 'jpeg']) {
        try {
          const info = await stat(resolve(join(media.localDir, `${publicId}.${format}`)));
          orphanBytes += info.size;
          break;
        } catch {
          // Not this format — try the next, exactly as the adapter's destroy does.
        }
      }
    }

    logger.log(`\n${renderMediaReconciliation(report, orphanBytes)}`);
    if (report.inLedgerOnly.length > 0) {
      // A live row with no file is a broken image in production terms: the
      // report succeeding silently would bury the one finding that matters.
      process.exitCode = 1;
    }
  } finally {
    await app.close();
  }
}

main().catch((error: unknown) => {
  logger.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
