import { afterEach, beforeEach, describe, expect, it } from '@jest/globals';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { LocalMediaStorage } from '../../src/providers/media/local/local-media-storage';

/**
 * The local adapter's port contract, proven against a real temp directory:
 * it must refuse what Cloudinary refuses (overwrite), measure dimensions
 * from the bytes it holds, persist across instances (a second adapter over
 * the same root sees the first one's assets — the property `memory` lacks
 * and the reason this adapter exists), and treat destroy as idempotent.
 */

/** A minimal PNG: signature + IHDR carrying the dimensions. The storage
 *  layer reads headers only; pixel decoding is MediaService's job upstream. */
function png(width: number, height: number): Buffer {
  const buffer = Buffer.alloc(33);
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]).copy(buffer, 0);
  buffer.writeUInt32BE(13, 8); // IHDR length
  buffer.write('IHDR', 12, 'ascii');
  buffer.writeUInt32BE(width, 16);
  buffer.writeUInt32BE(height, 20);
  return buffer;
}

describe('LocalMediaStorage', () => {
  let root: string;
  let storage: LocalMediaStorage;

  beforeEach(async () => {
    root = await mkdtemp(join(tmpdir(), 'nest-media-local-'));
    storage = new LocalMediaStorage(root);
  });

  afterEach(async () => {
    await rm(root, { recursive: true, force: true });
  });

  it('stores bytes on disk and reports measured metadata', async () => {
    const bytes = png(800, 600);
    const stored = await storage.upload({
      publicId: 'nest/products/abc/img1',
      format: 'png',
      bytes,
    });

    expect(stored.width).toBe(800);
    expect(stored.height).toBe(600);
    expect(stored.bytes).toBe(bytes.length);
    expect(stored.version).toBeGreaterThan(0);

    const onDisk = await readFile(join(root, 'nest/products/abc/img1.png'));
    expect(onDisk.equals(bytes)).toBe(true);
    await expect(storage.read('nest/products/abc/img1', 'png')).resolves.toEqual(bytes);
  });

  it('refuses a second upload to the same publicId (overwrite is off)', async () => {
    await storage.upload({ publicId: 'nest/products/abc/img1', format: 'png', bytes: png(10, 10) });
    await expect(
      storage.upload({ publicId: 'nest/products/abc/img1', format: 'png', bytes: png(20, 20) }),
    ).rejects.toThrow(/already exists and overwrite is off/);
  });

  it('persists across instances over the same root', async () => {
    await storage.upload({ publicId: 'nest/products/abc/img1', format: 'png', bytes: png(10, 10) });

    const second = new LocalMediaStorage(root);
    await expect(second.list('nest/products')).resolves.toEqual(['nest/products/abc/img1']);
    await expect(second.read('nest/products/abc/img1', 'png')).resolves.toBeDefined();
  });

  it('lists by prefix, sorted, without extensions', async () => {
    await storage.upload({ publicId: 'nest/products/b/2', format: 'png', bytes: png(10, 10) });
    await storage.upload({ publicId: 'nest/products/a/1', format: 'png', bytes: png(10, 10) });
    await storage.upload({ publicId: 'nest/categories/c/1', format: 'png', bytes: png(10, 10) });

    await expect(storage.list('nest/products')).resolves.toEqual([
      'nest/products/a/1',
      'nest/products/b/2',
    ]);
    await expect(storage.list('nest')).resolves.toHaveLength(3);
  });

  it('destroy removes the file and is idempotent', async () => {
    await storage.upload({ publicId: 'nest/products/abc/img1', format: 'png', bytes: png(10, 10) });
    await storage.destroy('nest/products/abc/img1');
    await expect(storage.read('nest/products/abc/img1', 'png')).resolves.toBeUndefined();
    await expect(storage.destroy('nest/products/abc/img1')).resolves.toBeUndefined();
    await expect(storage.destroy('nest/products/never/existed')).resolves.toBeUndefined();
  });

  it('refuses a publicId that would escape the media root', async () => {
    await expect(
      storage.upload({ publicId: '../outside', format: 'png', bytes: png(10, 10) }),
    ).rejects.toThrow(/escapes the media root/);
  });

  it('assigns increasing versions across uploads', async () => {
    const first = await storage.upload({ publicId: 'nest/products/a/1', format: 'png', bytes: png(10, 10) });
    const second = await storage.upload({ publicId: 'nest/products/a/2', format: 'png', bytes: png(10, 10) });
    expect(second.version).toBeGreaterThan(first.version);
  });
});
