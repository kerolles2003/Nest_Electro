import { describe, it, expect, jest } from '@jest/globals';
import { Types } from 'mongoose';
import { CustomersAdminService } from '../../src/modules/users/application/customers-admin.service';
import { Role } from '../../src/modules/users/infrastructure/schemas/user.schema';

// Deterministic transaction model; not a substitute for live Mongo concurrency evidence.
function harness(roles: Role[]) {
  let rows = roles.map(role => ({ _id: new Types.ObjectId(), role, deletedAt: null as Date | null, tokenVersion: 1, email: 'fixture@example.invalid' }));
  const ids = rows.map(row => row._id);
  const session = {};
  let tail = Promise.resolve();
  type Query = { session(value: unknown): Query; lean(): Query; exec(): Promise<unknown> };
  const query = (work: () => unknown): Query => ({ session: (value: unknown) => { expect(value).toBe(session); return query(work); }, lean: () => query(work), exec: async () => work() });
  let fenced = false;
  const model = {
    updateMany: (filter: unknown, update: unknown, options: { session: unknown }) => query(() => {
      expect(filter).toEqual({ role: Role.SUPER_ADMIN, deletedAt: null });
      expect(update).toEqual({ $inc: { roleMutationVersion: 1 } });
      expect(options.session).toBe(session); fenced = true;
    }),
    findById: (id: Types.ObjectId) => query(() => { expect(fenced).toBe(true); return rows.find(row => row._id.equals(id)) ?? null; }),
    countDocuments: () => query(() => rows.filter(row => row.role === Role.SUPER_ADMIN && row.deletedAt === null).length),
    findOneAndUpdate: (filter: { _id: Types.ObjectId }, update: { $set: object }, options: { session: unknown }) => query(() => {
      expect(options.session).toBe(session);
      const index = rows.findIndex(row => row._id.equals(filter._id));
      rows[index] = { ...rows[index]!, ...update.$set, tokenVersion: rows[index]!.tokenVersion + 1 };
      return rows[index];
    }),
  };
  const audit = { record: jest.fn(async (_input: unknown, value: unknown) => { expect(value).toBe(session); }), recordChange: jest.fn(async (_input: unknown, value: unknown) => { expect(value).toBe(session); }) };
  const transactions = { run: (work: (value: object) => Promise<unknown>) => {
    const result = tail.then(async () => { const before = rows.map(row => ({ ...row })); fenced = false; try { return await work(session); } catch (error) { rows = before; throw error; } });
    tail = result.then(() => undefined, () => undefined); return result;
  } };
  const service = new CustomersAdminService(model as never, { aggregate: () => query(() => []) } as never, audit as never, transactions as never);
  const context = (index: number) => ({ actorId: ids[index]!, forensics: { ip: null, userAgent: null, requestId: 'p1-test' } });
  return { service, context, ids, audit, rows: () => rows };
}

describe('SUPER_ADMIN service boundary', () => {
  it.each(['demote', 'delete', 'deactivate'])('refuses the only owner: %s', async operation => {
    const h = harness([Role.SUPER_ADMIN]);
    await expect(operation === 'demote' ? h.service.changeRole(h.ids[0]!, Role.ADMIN, h.context(0)) : h.service.softDelete(h.ids[0]!, h.context(0))).rejects.toBeDefined();
    expect(h.rows()[0]!.role).toBe(Role.SUPER_ADMIN); expect(h.rows()[0]!.deletedAt).toBeNull();
    expect(h.audit.record).not.toHaveBeenCalled(); expect(h.audit.recordChange).not.toHaveBeenCalled();
  });
  it('permits another owner to demote an owner', async () => {
    const h = harness([Role.SUPER_ADMIN, Role.SUPER_ADMIN]);
    await h.service.changeRole(h.ids[1]!, Role.ADMIN, h.context(0));
    expect(h.rows()[1]!.role).toBe(Role.ADMIN); expect(h.audit.recordChange).toHaveBeenCalledTimes(1);
  });
  it('rechecks authority after simultaneous mutual removals', async () => {
    const h = harness([Role.SUPER_ADMIN, Role.SUPER_ADMIN]);
    const result = await Promise.allSettled([h.service.changeRole(h.ids[1]!, Role.ADMIN, h.context(0)), h.service.softDelete(h.ids[0]!, h.context(1))]);
    expect(result.filter(row => row.status === 'fulfilled')).toHaveLength(1);
    expect(h.rows().filter(row => row.role === Role.SUPER_ADMIN && row.deletedAt === null)).toHaveLength(1);
  });
  it('rolls back when the audit insert fails', async () => {
    const h = harness([Role.SUPER_ADMIN, Role.SUPER_ADMIN]);
    h.audit.recordChange.mockRejectedValueOnce(new Error('audit unavailable'));
    await expect(h.service.changeRole(h.ids[1]!, Role.ADMIN, h.context(0))).rejects.toThrow('audit unavailable');
    expect(h.rows()[1]!.role).toBe(Role.SUPER_ADMIN); expect(h.rows()[1]!.tokenVersion).toBe(1);
  });
  it('rejects direct service calls from an ordinary admin', async () => {
    const h = harness([Role.SUPER_ADMIN, Role.ADMIN]);
    await expect(h.service.changeRole(h.ids[0]!, Role.ADMIN, h.context(1))).rejects.toBeDefined();
  });
});
