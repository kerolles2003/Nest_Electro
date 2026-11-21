import { describe, expect, it, jest } from '@jest/globals';
import { Types } from 'mongoose';
import { ImportRunner } from '../../src/database/import/import-runner';
import { ProductImageService } from '../../src/modules/catalog/application/product-image.service';
import { writeProductImages } from '../../src/modules/catalog/application/write-product-images';
import { Role } from '../../src/modules/users/infrastructure/schemas/user.schema';

type Row = Record<string, unknown>;
function harness(version: number | undefined = 0) {
  const id = new Types.ObjectId();
  let product: { _id: Types.ObjectId; sku: string; deletedAt: Date | null; imageVersion: number | undefined; images: Row[] } = { _id: id, sku: 'FIXTURE', deletedAt: null, imageVersion: version, images: [] };
  const session = {};
  const query = (work: () => unknown): { lean(): unknown; session(): unknown; exec(): Promise<unknown> } => ({ lean: () => query(work), session: () => query(work), exec: async () => work() });
  const products = {
    findOne: () => query(() => ({ ...product, images: [...product.images] })),
    updateOne: () => query(() => ({ matchedCount: 1 })),
    findById: () => query(() => ({ ...product, images: [...product.images] })),
    findOneAndUpdate: (filter: { $or: Row[] }, update: { $set: { images: Row[] }; $inc: { imageVersion: number } }, options: { session: unknown }) => query(() => {
      expect(options.session).toBe(session);
      const matches = filter.$or.some(v => typeof v.imageVersion === 'object' ? product.imageVersion === undefined : v.imageVersion === product.imageVersion);
      if (!matches || product.deletedAt !== null) return null;
      product = { ...product, ...update.$set, imageVersion: (product.imageVersion ?? 0) + update.$inc.imageVersion };
      return { ...product };
    }),
  };
  let tail = Promise.resolve();
  const transactions = { run: (work: (s: object) => Promise<unknown>) => {
    const result = tail.then(async () => {
      const before = { ...product, images: [...product.images] };
      try { return await work(session); } catch (error) { product = before; throw error; }
    }); tail = result.then(() => undefined, () => undefined); return result;
  } };
  let finish!: () => void; let started!: () => void;
  const uploading = new Promise<void>(resolve => { started = resolve; });
  const upload = new Promise<void>(resolve => { finish = resolve; });
  const importer = {
    importFor: async () => { started(); await upload; return { images: [{ publicId: 'imported', isPrimary: true, sortOrder: 0 }], result: { uploaded: 1, skipped: 0, failures: [] } }; },
    retainAll: jest.fn(async (_ids: string[], s: unknown) => { expect(s).toBe(session); }),
    rollback: jest.fn(async () => undefined),
  };
  const runner = new ImportRunner({ products, categories: {}, brands: {} } as never, { importer, transactions } as never);
  const actor = { _id: new Types.ObjectId(), role: Role.SUPER_ADMIN };
  const service = new ProductImageService(products as never, {} as never, {} as never, { findById: async () => actor } as never,
    { recordChange: async () => undefined } as never, transactions as never);
  const arrange = (expected: number) => service.arrange(id, product.images.map(i => ({ publicId: String(i.publicId) })),
    { actorId: actor._id, forensics: { ip: null, userAgent: null, requestId: 'synthetic-import' } }, expected);
  // Exercise the real importer transaction; only database/provider adapters are fakes.
  const run = () => runner['importImages'](id, [...product.images] as { publicId: string }[],
    { mapped: { imagePaths: ['synthetic.jpg'] }, mappedFields: new Set(['imagePaths']), dryRun: false }, product.imageVersion ?? 0);
  const upsert = () => runner['upsert']({ line: 2, key: 'FIXTURE', upsertKey: 'sku', dryRun: false,
    mapped: { sku: 'FIXTURE', name: 'Fixture', basePrice: 1000, onHand: 1, imagePaths: ['synthetic.jpg'] },
    mappedFields: new Set(['sku', 'name', 'basePrice', 'onHand', 'imagePaths']),
    category: { id: new Types.ObjectId(), slug: 'fixture', name: 'Fixture', path: [] }, brand: null });
  const replace = () => transactions.run(s => writeProductImages(products as never, id, [{ publicId: 'admin-image' }], product.imageVersion ?? 0, s as never));
  return { run, upsert, uploading, finish, arrange, replace, importer, product: () => product };
}

describe('import image arrangement CAS', () => {
  it('the row upsert forwards its observed nonzero version to image import', async () => {
    const h = harness(7); const result = h.upsert(); h.finish(); await result;
    expect(h.product().imageVersion).toBe(8); expect(h.importer.retainAll).toHaveBeenCalledTimes(1);
  });
  it.each([0, 7])('uses observed version %s and advances once on success', async version => {
    const h = harness(version); const result = h.run(); h.finish(); await result;
    expect(h.product().imageVersion).toBe(version + 1);
    expect(h.product().images[0]?.publicId).toBe('imported');
    expect(h.importer.retainAll).toHaveBeenCalledTimes(1);
  });
  it('supports legacy missing version as zero', async () => {
    const h = harness(); h.product().imageVersion = undefined;
    const result = h.run(); h.finish(); await result; expect(h.product().imageVersion).toBe(1);
  });
  it('reorder during upload wins; stale import cannot overwrite or retain', async () => {
    const h = harness(); const result = h.run(); await h.uploading;
    await h.arrange(0); h.finish(); await expect(result).rejects.toBeDefined();
    expect(h.product().images).toEqual([]); expect(h.product().imageVersion).toBe(1);
    expect(h.importer.retainAll).not.toHaveBeenCalled(); expect(h.importer.rollback).toHaveBeenCalledTimes(1);
  });
  it('preserves a newer populated arrangement committed while upload was pending', async () => {
    const h = harness(); const result = h.run(); await h.uploading;
    await h.replace(); h.finish(); await expect(result).rejects.toBeDefined();
    expect(h.product().images).toEqual([{ publicId: 'admin-image' }]);
    expect(h.product().imageVersion).toBe(1); expect(h.importer.retainAll).not.toHaveBeenCalled();
  });
  it('completed import makes the pre-import reorder stale', async () => {
    const h = harness(); const result = h.run(); h.finish(); await result;
    await expect(h.arrange(0)).rejects.toBeDefined();
    expect(h.product().images[0]?.publicId).toBe('imported'); expect(h.product().imageVersion).toBe(1);
  });
  it('two concurrent imports cannot both commit the same version', async () => {
    const h = harness(); const results = Promise.allSettled([h.run(), h.run()]); h.finish();
    expect((await results).filter(r => r.status === 'fulfilled')).toHaveLength(1);
    expect(h.product().imageVersion).toBe(1); expect(h.importer.retainAll).toHaveBeenCalledTimes(1);
  });
  it('reference-retain failure rolls back descriptors and version', async () => {
    const h = harness(4); h.importer.retainAll.mockRejectedValueOnce(new Error('retain failed'));
    const result = h.run(); h.finish(); await expect(result).rejects.toThrow('retain failed');
    expect(h.product().images).toEqual([]); expect(h.product().imageVersion).toBe(4);
    expect(h.importer.rollback).toHaveBeenCalledTimes(1);
  });
});
