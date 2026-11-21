import { describe, expect, it, jest } from '@jest/globals';
import { Types } from 'mongoose';
import { BrandAdminService } from '../../src/modules/catalog/application/brand-admin.service';
import { CategoryAdminService } from '../../src/modules/catalog/application/category-admin.service';
import { Role } from '../../src/modules/users/infrastructure/schemas/user.schema';

function harness(kind: 'brand' | 'category', miss = false) {
  const id = new Types.ObjectId();
  const actor = { _id: new Types.ObjectId(), role: Role.SUPER_ADMIN };
  let row = { _id: id, slug: 'fixture', name: { en: 'Fixture' }, deletedAt: null as Date | null, isActive: true };
  const query = (work: () => unknown): { lean(): unknown; exec(): Promise<unknown> } => ({
    lean: () => query(work), exec: async () => work(),
  });
  const model = {
    findById: () => query(() => ({ ...row })),
    countDocuments: () => query(() => 0),
    findOneAndUpdate: (_filter: unknown, update: { $set: Partial<typeof row> }) => query(() => {
      if (miss || row.deletedAt !== null) return null;
      row = { ...row, ...update.$set }; return { ...row };
    }),
  };
  const products = { countDocuments: () => query(() => 0), updateMany: jest.fn(() => query(() => ({ modifiedCount: 1 }))) };
  const audit = { recordIntent: jest.fn(async () => 'operation'), record: jest.fn(async (input: unknown) => { void input; }) };
  const cache = { invalidateCache: jest.fn() };
  const Service = kind === 'brand' ? BrandAdminService : CategoryAdminService;
  const service = new Service(model as never, products as never, { findById: async () => actor } as never,
    {} as never, cache as never, audit as never);
  return { row: () => row, audit, products, cache,
    remove: () => service.softDelete(id, { actorId: actor._id, forensics: { ip: null, userAgent: null, requestId: 'synthetic-delete' } }) };
}

describe.each(['brand', 'category'] as const)('%s deletion outcome', kind => {
  it('returns the persisted deletion and records success only after a matched write', async () => {
    const h = harness(kind); const result = await h.remove();
    expect(result.deletedAt).toBeInstanceOf(Date);
    expect(result.deletedAt).toEqual(h.row().deletedAt);
    expect(h.audit.record).toHaveBeenCalledTimes(1);
    expect(h.audit.record).toHaveBeenCalledWith(expect.objectContaining({ metadata: expect.objectContaining({ outcome: 'succeeded' }) }));
  });
  it('zero-match throws conflict without success evidence or downstream changes', async () => {
    const h = harness(kind, true);
    await expect(h.remove()).rejects.toMatchObject({ status: 409 });
    expect(h.row().deletedAt).toBeNull();
    expect(h.audit.recordIntent).toHaveBeenCalledTimes(1);
    expect(h.audit.record).not.toHaveBeenCalled();
    expect(h.products.updateMany).not.toHaveBeenCalled();
    expect(h.cache.invalidateCache).not.toHaveBeenCalled();
  });
  it('concurrent callers yield one actual deletion and one success audit', async () => {
    const h = harness(kind); const outcomes = await Promise.allSettled([h.remove(), h.remove()]);
    expect(outcomes.filter(outcome => outcome.status === 'fulfilled')).toHaveLength(1);
    expect(outcomes.filter(outcome => outcome.status === 'rejected')).toHaveLength(1);
    expect(h.row().deletedAt).toBeInstanceOf(Date);
    expect(h.audit.record).toHaveBeenCalledTimes(1);
  });
  it('repeated deletion fails and preserves the original deletion timestamp/evidence', async () => {
    const h = harness(kind); await h.remove(); const at = h.row().deletedAt;
    await expect(h.remove()).rejects.toBeDefined();
    expect(h.row().deletedAt).toBe(at); expect(h.audit.record).toHaveBeenCalledTimes(1);
  });
});
