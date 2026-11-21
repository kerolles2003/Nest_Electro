import { describe, expect, it, jest } from '@jest/globals';
import { Types } from 'mongoose';
import { MediaAssetRepository } from '../../src/modules/media/infrastructure/repositories/media-asset.repository';
import { MediaService } from '../../src/modules/media/application/media.service';
import { ProductImageService } from '../../src/modules/catalog/application/product-image.service';
import { Role } from '../../src/modules/users/infrastructure/schemas/user.schema';

type Row = Record<string, unknown>;
function matches(row: Row, filter: Row): boolean {
  return Object.entries(filter).every(([key, value]) => {
    if (key === '$or') return (value as Row[]).some(item => matches(row, item));
    const actual = row[key];
    if (value && typeof value === 'object' && !(value instanceof Types.ObjectId)) {
      const condition = value as Row;
      if ('$ne' in condition) return actual !== condition.$ne;
      if ('$gt' in condition) return Number(actual) > Number(condition.$gt);
      if ('$exists' in condition) return (actual !== undefined) === condition.$exists;
    }
    return actual === value || (actual instanceof Types.ObjectId && actual.equals(value as Types.ObjectId));
  });
}
type Query = { session(value: unknown): Query; lean(): Query; exec(): Promise<unknown> };
function query(work: () => unknown): Query {
  return { session: () => query(work), lean: () => query(work), exec: async () => work() };
}

// Model-level transaction fixture, with rollback and interleaved external effects.
// This verifies service protocols; live replica-set tests remain a separate gate.
function harness() {
  const id = new Types.ObjectId();
  const actor = { _id: new Types.ObjectId(), role: Role.SUPER_ADMIN, fullName: 'Fixture', email: 'fixture@example.invalid' };
  const context = { actorId: actor._id, forensics: { ip: null, userAgent: null, requestId: 'p1-media' } };
  let product = { _id: id, sku: 'P1', deletedAt: null, imageVersion: 0, images: [] as Row[] };
  let assets: Row[] = ['a', 'b'].map(publicId => ({ _id: new Types.ObjectId(), publicId, refCount: 0, deleting: false, destroyedAt: null, version: 1 }));
  let evidence: unknown[] = [];
  const session = {};
  let tail = Promise.resolve();
  const transactions = { run: (work: (session: object) => Promise<unknown>) => {
    const result = tail.then(async () => {
      const before = { product: { ...product, images: [...product.images] }, assets: assets.map(row => ({ ...row })), evidence: [...evidence] };
      try { return await work(session); } catch (error) { product = before.product; assets = before.assets; evidence = before.evidence; throw error; }
    });
    tail = result.then(() => undefined, () => undefined); return result;
  } };
  function update(row: Row, change: { $set?: Row; $inc?: Row }) {
    Object.assign(row, change.$set);
    for (const [key, amount] of Object.entries(change.$inc ?? {})) row[key] = Number(row[key] ?? 0) + Number(amount);
    return { ...row };
  }
  const assetModel = {
    findOne: (filter: Row) => query(() => { const row = assets.find(row => matches(row, filter)); return row ? { ...row } : null; }),
    findOneAndUpdate: (filter: Row, change: Row) => query(() => { const row = assets.find(row => matches(row, filter)); return row ? update(row, change) : null; }),
    updateOne: (filter: Row, change: Row) => query(() => { const row = assets.find(row => matches(row, filter)); if (row) update(row, change); return { modifiedCount: row ? 1 : 0 }; }),
  };
  const productModel = {
    findById: () => query(() => ({ ...product, images: [...product.images] })),
    findOneAndUpdate: (filter: Row, change: Row, options: { session: unknown }) => query(() => {
      expect(options.session).toBe(session);
      return matches(product, filter) ? update(product, change) : null;
    }),
  };
  const audit = { record: jest.fn(async (input: unknown, value: unknown) => { expect(value).toBe(session); evidence.push(input); }), recordChange: jest.fn(async (input: unknown, value: unknown) => { expect(value).toBe(session); evidence.push(input); }) };
  const users = { findById: async () => actor };
  const destroyed = new Set<string>();
  const storage = { destroy: jest.fn(async (publicId: string) => { destroyed.add(publicId); }) };
  const ledger = new MediaAssetRepository(assetModel as never);
  const media = new MediaService(storage as never, ledger, {} as never, {} as never, transactions as never, audit as never, users as never);
  const images = new ProductImageService(productModel as never, media, ledger, users as never, audit as never, transactions as never);
  const attach = (publicId = 'a') => images.attach(id, publicId, null, context);
  const detach = (publicId = 'a') => images.detach(id, publicId, context);
  const destroy = (publicId = 'a') => media.destroy(publicId, context);
  const arrange = (version: number, ids = ['a', 'b']) => images.arrange(id, ids.map(publicId => ({ publicId })), context, version);
  const assertReferencesSafe = () => { for (const row of product.images) expect(destroyed.has(String(row.publicId))).toBe(false); };
  return { id, context, ledger, media, images, attach, detach, destroy, arrange, assertReferencesSafe, storage, audit, destroyed, transactions,
    product: () => product, assets: () => assets, evidence: () => evidence };
}

describe('media deletion fence and arrangement version', () => {
  it.each(['attach-first', 'delete-first'])('attach/delete race: %s', async order => {
    const h = harness();
    const results = await Promise.allSettled(order === 'attach-first' ? [h.attach(), h.destroy()] : [h.destroy(), h.attach()]);
    expect(results.filter(row => row.status === 'fulfilled')).toHaveLength(1); h.assertReferencesSafe();
  });
  it('remove/cleanup leaves no live dangling reference', async () => {
    const h = harness(); await h.attach();
    await Promise.allSettled([h.detach(), h.destroy()]); h.assertReferencesSafe();
    expect(h.product().images).toHaveLength(0);
  });
  it('replacement/cleanup never destroys the replacement', async () => {
    const h = harness(); await h.attach();
    await h.detach();
    await Promise.allSettled([h.attach('b'), h.destroy()]); h.assertReferencesSafe();
    expect(h.product().images[0]?.publicId).toBe('b');
  });
  it('keeps a deletion fence across provider failure and retry', async () => {
    const h = harness(); h.storage.destroy.mockRejectedValueOnce(new Error('provider unavailable'));
    await expect(h.destroy()).rejects.toThrow('provider unavailable');
    await expect(h.attach()).rejects.toBeDefined(); expect(h.product().images).toHaveLength(0);
    await h.destroy(); await h.destroy();
    expect(h.storage.destroy).toHaveBeenCalledTimes(2);
    expect(h.evidence()).toHaveLength(2); h.assertReferencesSafe();
  });
  it('does not call the provider when intent auditing fails', async () => {
    const h = harness(); h.audit.record.mockRejectedValueOnce(new Error('audit unavailable'));
    await expect(h.destroy()).rejects.toThrow('audit unavailable');
    expect(h.storage.destroy).not.toHaveBeenCalled(); expect(h.assets()[0]?.deleting).toBe(false);
  });
  it('recovers provider success followed by failed durable finalization', async () => {
    const h = harness();
    h.storage.destroy.mockImplementationOnce(async publicId => {
      h.destroyed.add(publicId);
      h.audit.record.mockRejectedValueOnce(new Error('finalization unavailable'));
    });
    await expect(h.destroy()).rejects.toThrow('finalization unavailable');
    expect(h.assets()[0]?.deleting).toBe(true); expect(h.assets()[0]?.destroyedAt).toBeNull();
    await expect(h.attach()).rejects.toBeDefined();
    await h.destroy(); expect(h.evidence()).toHaveLength(2); h.assertReferencesSafe();
  });
  it('concurrent repeated cleanup records only one intent and one completion', async () => {
    const h = harness(); await Promise.all([h.destroy(), h.destroy()]);
    expect(h.evidence()).toHaveLength(2); h.assertReferencesSafe();
  });
  it('rolls back a failed attachment and then safely cleans the orphan', async () => {
    const h = harness(); h.audit.record.mockRejectedValueOnce(new Error('audit unavailable'));
    await expect(h.attach()).rejects.toThrow('audit unavailable');
    expect(h.product().images).toHaveLength(0); expect(h.assets()[0]?.refCount).toBe(0);
    await h.destroy(); h.assertReferencesSafe();
  });
  it('normal reorder increments version and stale replay changes nothing', async () => {
    const h = harness(); await h.attach(); await h.attach('b');
    await h.arrange(2, ['b', 'a']); expect(h.product().imageVersion).toBe(3);
    await expect(h.arrange(2)).rejects.toBeDefined();
    expect(h.product().images.map(row => row.publicId)).toEqual(['b', 'a']);
    expect(h.product().imageVersion).toBe(3);
  });
  it('concurrent reorders have one winner', async () => {
    const h = harness(); await h.attach(); await h.attach('b');
    const result = await Promise.allSettled([h.arrange(2), h.arrange(2, ['b', 'a'])]);
    expect(result.filter(row => row.status === 'fulfilled')).toHaveLength(1); expect(h.product().imageVersion).toBe(3);
  });
  it('removal invalidates an in-flight reorder', async () => {
    const h = harness(); await h.attach(); await h.attach('b');
    const result = await Promise.allSettled([h.detach(), h.arrange(2)]);
    expect(result[1]?.status).toBe('rejected'); expect(h.product().images).toHaveLength(1);
  });
  it('replacement invalidates the old arrangement even if the asset is reattached', async () => {
    const h = harness(); await h.attach(); await h.attach('b'); await h.detach(); await h.attach();
    await expect(h.arrange(2)).rejects.toBeDefined(); expect(h.product().imageVersion).toBe(4);
  });
  it('stale failure creates no successful audit record', async () => {
    const h = harness(); await h.attach(); const before = h.evidence().length;
    await expect(h.arrange(0, ['a'])).rejects.toBeDefined(); expect(h.evidence()).toHaveLength(before);
  });
});
