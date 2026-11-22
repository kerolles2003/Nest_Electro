import { describe, expect, it, jest } from '@jest/globals';
import { Types } from 'mongoose';
import { OrderLifecycleService } from '../../src/modules/orders/application/order-lifecycle.service';
import { OrderStatus, PaymentMethod, PaymentStatus } from '../../src/modules/orders/domain/order-status';
import { Role } from '../../src/modules/users/infrastructure/schemas/user.schema';

function harness() {
  const session = {};
  const actor = { _id: new Types.ObjectId(), role: Role.ADMIN, fullName: 'Fixture', email: 'fixture@example.invalid' };
  // The payment subdocument is part of the fixture because it is part of
  // every real order (required by the schema): an explicit COD order, the
  // canonical confirm case. Under the fail-closed PAY-3 gate a
  // payment-less fixture order is refused before any audit behaviour
  // could be observed — which is the gate working, not this suite's
  // subject. This suite's subject is the audit transaction boundary.
  let order = { _id: new Types.ObjectId(), orderNumber: 'P1-ORDER', status: OrderStatus.PLACED, items: [], statusHistory: [] as unknown[], payment: { method: PaymentMethod.COD, status: PaymentStatus.PENDING, verification: null, collectedAt: null, refundedAmount: null, refundNote: null } };
  let evidence: unknown[] = [];
  let tail = Promise.resolve();
  const transactions = { run: (work: (session: object) => Promise<unknown>) => {
    const result = tail.then(async () => { const before = { ...order }; const events = [...evidence];
      try { return await work(session); } catch (error) { order = before; evidence = events; throw error; }
    }); tail = result.then(() => undefined, () => undefined); return result;
  } };
  const orders = {
    findForTransition: async (_id: unknown, value: unknown) => { expect(value).toBe(session); return { ...order }; },
    applyTransition: async (input: { to: OrderStatus; historyEntry: unknown }, value: unknown) => { expect(value).toBe(session); order = { ...order, status: input.to, statusHistory: [...order.statusHistory, input.historyEntry] }; return order; },
  };
  const audit = { record: jest.fn(async (input: unknown, value: unknown) => { expect(value).toBe(session); evidence.push(input); }) };
  const service = new OrderLifecycleService(transactions as never, orders as never, {} as never, { findById: async () => actor } as never, audit as never);
  const confirm = () => service.transitionByStaff({ actorId: actor._id, orderId: order._id, to: OrderStatus.CONFIRMED, context: { ip: null, userAgent: null, requestId: 'p1-order' } });
  return { actor, confirm, audit, order: () => order, evidence: () => evidence };
}
describe('order audit transaction boundary', () => {
  it('attributes a successful status mutation', async () => {
    const h = harness(); await h.confirm();
    expect(h.evidence()).toEqual([expect.objectContaining({ actor: expect.objectContaining({ id: h.actor._id }), changes: { before: { status: 'PLACED' }, after: { status: 'CONFIRMED' } } })]);
  });
  it('rolls the status and embedded history back on audit failure', async () => {
    const h = harness(); h.audit.record.mockRejectedValueOnce(new Error('audit unavailable'));
    await expect(h.confirm()).rejects.toThrow('audit unavailable');
    expect(h.order().status).toBe(OrderStatus.PLACED); expect(h.order().statusHistory).toHaveLength(0); expect(h.evidence()).toHaveLength(0);
  });
  it('simultaneous duplicate transitions produce one event', async () => {
    const h = harness(); const results = await Promise.allSettled([h.confirm(), h.confirm()]);
    expect(results.filter(row => row.status === 'fulfilled')).toHaveLength(1); expect(h.evidence()).toHaveLength(1);
  });
});
