import { describe, expect, it, jest } from '@jest/globals';
import { Types } from 'mongoose';
import { ProductAdminService } from '../../src/modules/catalog/application/product-admin.service';
import { InventoryRepository } from '../../src/modules/inventory/infrastructure/repositories/inventory.repository';
import { Role } from '../../src/modules/users/infrastructure/schemas/user.schema';

type Query = { session(value: unknown): Query; lean(): Query; exec(): Promise<unknown> };
function harness() {
  const session = {};
  let product: { _id: Types.ObjectId; sku: string; slug: string; name: { en: string }; deletedAt: Date | null; isActive: boolean; category: { path: Types.ObjectId[] }; brand: null; images: { publicId: string }[]; stock: { onHand: number } } | null = {
    _id: new Types.ObjectId(), sku: 'P1', slug: 'p1', name: { en: 'Fixture' }, deletedAt: null, isActive: true, category: { path: [] }, brand: null, images: [{ publicId: 'a' }], stock: { onHand: 2 },
  };
  const id = product._id;
  let orderCount = 0; let refCount = 1; let evidence: unknown[] = [];
  const history = { sku: 'P1', name: 'Historical product', price: 100 };
  const actor = { _id: new Types.ObjectId(), role: Role.SUPER_ADMIN, fullName: 'Fixture', email: 'fixture@example.invalid' };
  const context = { actorId: actor._id, forensics: { ip: null, userAgent: null, requestId: 'p1-delete' } };
  const query = (work: () => unknown): Query => ({ session: value => { expect(value).toBe(session); return query(work); }, lean: () => query(work), exec: async () => work() });
  let tail = Promise.resolve();
  const transactions = { run: (work: (session: object) => Promise<unknown>) => {
    const result = tail.then(async () => { const before = { product: product ? { ...product, stock: { ...product.stock } } : null, refCount, orderCount, evidence: [...evidence] };
      try { return await work(session); } catch (error) { product = before.product; refCount = before.refCount; orderCount = before.orderCount; evidence = before.evidence; throw error; }
    }); tail = result.then(() => undefined, () => undefined); return result;
  } };
  const products = {
    findById: () => query(() => product ? { ...product } : null),
    deleteOne: (_filter: unknown, options: { session: unknown }) => query(() => { expect(options.session).toBe(session); const existed = !!product; product = null; return { deletedCount: existed ? 1 : 0 }; }),
    findOneAndUpdate: (filter: Record<string, unknown>, update: { $set?: object; $inc?: Record<string, number> }, options: { session: unknown }) => query(() => {
      expect(options.session).toBe(session);
      if (!product) return null;
      if ('stock.onHand' in filter) {
        expect(filter).toMatchObject({ isActive: true, deletedAt: null });
        if (!product.isActive || product.deletedAt !== null || product.stock.onHand < 1) return null;
        product.stock.onHand += update.$inc?.['stock.onHand'] ?? 0;
      } else Object.assign(product, update.$set);
      return { ...product, stock: { ...product.stock } };
    }),
  };
  const audit = { record: jest.fn(async (input: unknown, value: unknown) => { expect(value).toBe(session); evidence.push(input); }) };
  const images = { releaseAll: jest.fn(async (_product: unknown, value: unknown) => { expect(value).toBe(session); refCount--; }) };
  const redirects = { forgetEntity: jest.fn(async (_type: unknown, _id: unknown, value: unknown) => { expect(value).toBe(session); }) };
  const cache = { invalidateCache: () => undefined };
  const service = new ProductAdminService(products as never, {} as never, {} as never, { countDocuments: () => query(() => orderCount) } as never, { findById: async () => actor } as never, redirects as never, images as never, cache as never, cache as never, audit as never, transactions as never);
  const inventory = new InventoryRepository(products as never, {} as never);
  const checkout = () => transactions.run(async () => { if (!await inventory.decrementForSale(id, 1, session as never)) throw new Error('unavailable'); orderCount++; });
  return { service, checkout, id, context, audit, redirects, images, history, product: () => product, refs: () => refCount, orders: () => orderCount, evidence: () => evidence };
}

describe('product deletion transaction protocol (model evidence)', () => {
  it('a product left in a cart cannot be checked out after deletion', async () => {
    const h = harness(); await h.service.hardDelete(h.id, h.context);
    await expect(h.checkout()).rejects.toThrow('unavailable'); expect(h.orders()).toBe(0);
  });
  it('deactivation before checkout is rejected by the stock write', async () => {
    const h = harness(); h.product()!.isActive = false;
    await expect(h.checkout()).rejects.toThrow('unavailable');
  });
  it.each(['checkout-first', 'delete-first'])('checkout/deletion race: %s', async order => {
    const h = harness();
    const results = await Promise.allSettled(order === 'checkout-first' ? [h.checkout(), h.service.hardDelete(h.id, h.context)] : [h.service.hardDelete(h.id, h.context), h.checkout()]);
    expect(results.filter(row => row.status === 'fulfilled')).toHaveLength(1);
    if (h.orders()) expect(h.product()).not.toBeNull();
  });
  it('releases once, retains bytes, and rejects repeated deletion', async () => {
    const h = harness(); const result = await h.service.hardDelete(h.id, h.context);
    expect(result.imagesDestroyed).toEqual([]); expect(result.imagesKept).toEqual(['a']);
    await expect(h.service.hardDelete(h.id, h.context)).rejects.toBeDefined();
    expect(h.refs()).toBe(0); expect(h.images.releaseAll).toHaveBeenCalledTimes(1);
  });
  it('rolls back product and image release when deletion auditing fails', async () => {
    const h = harness(); h.audit.record.mockRejectedValueOnce(new Error('audit unavailable'));
    await expect(h.service.hardDelete(h.id, h.context)).rejects.toThrow('audit unavailable');
    expect(h.product()).not.toBeNull(); expect(h.refs()).toBe(1); expect(h.evidence()).toHaveLength(0);
  });
  it('archives an ordered product without changing its historical snapshot', async () => {
    const h = harness(); await h.checkout(); const snapshot = { ...h.history };
    await expect(h.service.hardDelete(h.id, h.context)).rejects.toBeDefined();
    await h.service.softDelete(h.id, h.context); expect(h.history).toEqual(snapshot); expect(h.product()?.isActive).toBe(false);
    await h.service.restore(h.id, h.context); expect(h.product()?.deletedAt).toBeNull(); expect(h.product()?.isActive).toBe(false);
  });
});
