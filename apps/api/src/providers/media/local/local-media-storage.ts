import { Injectable, Logger } from '@nestjs/common';
import { mkdir, readFile, readdir, unlink, writeFile } from 'node:fs/promises';
import { dirname, join, resolve, sep } from 'node:path';
import {
  MediaStoragePort,
  type MediaUploadRequest,
  type StoredMediaAsset,
} from '../../../modules/media/application/ports/media-storage.port';
import { readDimensions } from '../memory/in-memory-media-storage';

/**
 * The disk-persistent development adapter for the media port.
 *
 * Authority: docs/architecture/PROVIDER-ARCHITECTURE.md §4 — adapters are
 * first-class implementations of the port, not mocks. This one exists
 * because of a gap the two older adapters leave open:
 *
 *   · `memory` runs the full pipeline but its bytes die with the process,
 *     so a catalogue imported through it references assets that no longer
 *     exist — the catalogue import tool refuses `--images` on it outright.
 *   · `cloudinary` is the production provider (D-4), but the account is an
 *     owner deliverable that has not arrived.
 *
 * A catalogue that must survive restarts and be LOOKED at — in the admin,
 * on the storefront — needs a store that persists and can be served. This
 * adapter is that store for development and self-hosted evaluation: same
 * port contract, same refusals (`overwrite: false`, dimensions measured
 * from the bytes it holds, idempotent destroy), bytes on local disk under
 * a configured root. The env schema refuses it in production for the same
 * reason D-4 names Cloudinary there: one host's disk is not a CDN.
 *
 * ## Layout on disk
 *
 * `<root>/<publicId>.<format>` — the publicId IS the path, so `list()` is a
 * directory walk and no index file exists to disagree with the ledger. The
 * ledger (MediaAsset) remains the authority for metadata; this adapter is
 * asked, never told, exactly like the other two.
 */
@Injectable()
export class LocalMediaStorage extends MediaStoragePort {
  private readonly logger = new Logger(LocalMediaStorage.name);
  private readonly root: string;

  /** Same monotonic version counter as the memory adapter, for the same reason. */
  private nextVersion = Math.floor(Date.now() / 1000);

  constructor(rootDir: string) {
    super();
    this.root = resolve(rootDir);
  }

  /** The on-disk path for one asset. Contained under the root by construction. */
  private pathFor(publicId: string, format: string): string {
    const path = resolve(join(this.root, `${publicId}.${format}`));
    if (!path.startsWith(this.root + sep)) {
      // publicIds are generated server-side from a strict alphabet, so this
      // cannot fire on a real upload — it exists so a future caller passing
      // an unvalidated id gets a refusal instead of a path outside the root.
      throw new Error(`publicId escapes the media root: ${publicId}`);
    }
    return path;
  }

  async upload(request: MediaUploadRequest): Promise<StoredMediaAsset> {
    const path = this.pathFor(request.publicId, request.format);

    // Mirrors `overwrite: false`, like the memory adapter: refuse what the
    // real provider refuses, so behaviour cannot drift between machines.
    try {
      await readFile(path);
      throw new Error(`${request.publicId} already exists and overwrite is off`);
    } catch (error) {
      if (error instanceof Error && error.message.includes('already exists')) throw error;
      // ENOENT is the expected path — the asset is new. Anything else
      // (permissions, a directory in the way) surfaces as-is.
      if ((error as NodeJS.ErrnoException).code !== 'ENOENT') throw error;
    }

    const dimensions = readDimensions(request.bytes, request.format);

    const stored: StoredMediaAsset = {
      publicId: request.publicId,
      version: (this.nextVersion += 1),
      format: request.format,
      width: dimensions.width,
      height: dimensions.height,
      bytes: request.bytes.length,
    };

    await mkdir(dirname(path), { recursive: true });
    await writeFile(path, request.bytes);

    this.logger.log(
      `[local] stored ${request.publicId}  ${String(stored.width)}x${String(stored.height)}  ` +
        `${String(stored.bytes)} bytes at ${path}`,
    );

    return stored;
  }

  /** Idempotent, per the port contract: "already gone" is success. */
  async destroy(publicId: string): Promise<void> {
    for (const format of ['webp', 'png', 'jpeg', 'jpg']) {
      try {
        await unlink(this.pathFor(publicId, format));
      } catch (error) {
        if ((error as NodeJS.ErrnoException).code !== 'ENOENT') throw error;
      }
    }
  }

  async list(prefix: string): Promise<readonly string[]> {
    const found: string[] = [];
    const walk = async (dir: string): Promise<void> => {
      let entries;
      try {
        entries = await readdir(dir, { withFileTypes: true });
      } catch (error) {
        if ((error as NodeJS.ErrnoException).code === 'ENOENT') return;
        throw error;
      }
      for (const entry of entries) {
        const full = join(dir, entry.name);
        if (entry.isDirectory()) {
          await walk(full);
        } else if (entry.isFile()) {
          const relative = full.slice(this.root.length + 1);
          const publicId = relative.replace(/\.(webp|png|jpe?g)$/, '');
          if (publicId.startsWith(prefix)) found.push(publicId.split(sep).join('/'));
        }
      }
    };
    await walk(this.root);
    return found.sort();
  }

  /** Delivery-facing: the exact bytes stored for one asset, in one format. */
  async read(publicId: string, format: string): Promise<Buffer | undefined> {
    try {
      return await readFile(this.pathFor(publicId, format));
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code === 'ENOENT') return undefined;
      throw error;
    }
  }
}
