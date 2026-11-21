import { describe, expect, it, jest } from '@jest/globals';
import { Types } from 'mongoose';
import { AuditService } from '../../src/modules/audit/application/audit.service';
import { AuditAction, AuditEntityType } from '../../src/modules/audit/domain/audit-action';
import { diffFields, redactAuditValue } from '../../src/modules/audit/domain/audit-diff';
import { BrandAdminService } from '../../src/modules/catalog/application/brand-admin.service';
import { Role } from '../../src/modules/users/infrastructure/schemas/user.schema';

const input = {
  actor: { id: new Types.ObjectId(), role: 'SUPER_ADMIN', name: 'Fixture', email: 'fixture@example.invalid' },
  action: AuditAction.USER_ROLE_CHANGED,
  entity: { type: AuditEntityType.USER, id: new Types.ObjectId(), label: 'Fixture' },
  context: { ip: null, userAgent: null, requestId: 'p1-audit' },
};
describe('durable audit boundary', () => {
  it('persists a distinct requested intent with a stable operation identifier', async () => {
    const create = jest.fn(async (...args: unknown[]) => { void args; });
    const operationId = await new AuditService({ create } as never).recordIntent(input);
    expect(create).toHaveBeenCalledWith(expect.objectContaining({
      action: AuditAction.ADMIN_MUTATION_REQUESTED,
      metadata: { operationId, outcome: 'requested', intendedAction: input.action },
    }));
  });
  it('blocks a catalogue write when durable intent storage fails', async () => {
    const create = jest.fn(async () => { throw new Error('audit unavailable'); });
    const write = jest.fn();
    const actor = { _id: input.actor.id, role: Role.SUPER_ADMIN, fullName: 'Fixture', email: input.actor.email };
    const service = new BrandAdminService({ create: write } as never, {} as never,
      { findById: async () => actor } as never, {} as never, {} as never, new AuditService({ create } as never));
    await expect(service.create({ slug: 'p1', name: { en: 'Fixture' } }, { actorId: actor._id, forensics: input.context })).rejects.toThrow('audit unavailable');
    expect(write).not.toHaveBeenCalled();
  });
  it('writes actor, entity and correlation into the business session', async () => {
    const create = jest.fn(async (...args: unknown[]) => { void args; }); const session = {};
    await new AuditService({ create } as never).record(input, session as never);
    expect(create).toHaveBeenCalledWith([expect.objectContaining({ actor: input.actor, entity: input.entity, requestId: 'p1-audit' })], { session });
  });
  it('propagates an audit failure to abort a critical mutation', async () => {
    const create = jest.fn(async () => { throw new Error('audit unavailable'); });
    await expect(new AuditService({ create } as never).record(input, {} as never)).rejects.toThrow('audit unavailable');
  });
  it('redacts direct metadata and nested arrays as well as diffs', async () => {
    const create = jest.fn(async (...args: unknown[]) => { void args; });
    await new AuditService({ create } as never).record({ ...input, metadata: { nested: [{ accessToken: 'fake-secret', credentials: { key: 'fake-secret' } }], 'auth.passwordHash': 'fake-secret', safe: 'decision' } }, {} as never);
    expect(JSON.stringify(create.mock.calls)).not.toContain('fake-secret');
    expect(JSON.stringify(create.mock.calls)).toContain('decision');
    expect(JSON.stringify(diffFields({ credentials: { key: 'old' } }, { credentials: { key: 'fake-secret' } }))).not.toContain('fake-secret');
    expect(diffFields({ items: [] }, { items: [{ refreshToken: 'fake-secret' }] })).toEqual({ before: { items: [] }, after: { items: [{ refreshToken: '[redacted]' }] } });
  });
  it('preserves safe values, dates and entity identifiers', () => {
    const value = { at: new Date(), id: new Types.ObjectId(), status: 'PAID', tokenCount: 2 };
    expect(redactAuditValue(value)).toEqual(value);
  });
  it('does not manufacture an event for an unchanged role', async () => {
    const create = jest.fn(async (...args: unknown[]) => { void args; });
    await new AuditService({ create } as never).recordChange({ ...input, before: { role: 'ADMIN' }, after: { role: 'ADMIN' } }, {} as never);
    expect(create).not.toHaveBeenCalled();
  });
});
