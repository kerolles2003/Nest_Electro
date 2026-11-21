import { randomUUID } from 'node:crypto';
import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types, type ClientSession } from 'mongoose';
import { AuditAction, AuditEntityType } from '../domain/audit-action';
import { diffFields, redactAuditValue, type AuditChanges } from '../domain/audit-diff';
import { AuditLog } from '../infrastructure/schemas/audit-log.schema';

/** Durable audit records. Critical mutations pass their Mongo session so a
 * missing audit record aborts the mutation. Multi-step catalogue callers persist intent before mutation; their outcome
 * remains best-effort until the propagation transaction work. */
export interface AuditActorInput {
  readonly id: Types.ObjectId;
  readonly role: string;
  readonly name: string;
  readonly email: string;
}

/** Forensic context, from the request. Never supplied by a caller's body. */
export interface AuditContext {
  readonly ip: string | null;
  readonly userAgent: string | null;
  readonly requestId: string;
}

export interface AuditRecordInput {
  readonly actor: AuditActorInput;
  readonly action: AuditAction;
  readonly entity: {
    readonly type: AuditEntityType;
    readonly id: Types.ObjectId;
    readonly label: string;
  };
  /** Computed with `diffFields`, or absent for actions with no before state. */
  readonly changes?: AuditChanges | null;
  readonly metadata?: Record<string, unknown> | null;
  readonly context: AuditContext;
}

@Injectable()
export class AuditService {
  private readonly logger = new Logger(AuditService.name);

  constructor(@InjectModel(AuditLog.name) private readonly model: Model<AuditLog>) {}

  async record(input: AuditRecordInput, session?: ClientSession, required = false): Promise<void> {
    const record = {
      actor: { id: input.actor.id, role: input.actor.role, name: input.actor.name, email: input.actor.email },
      action: input.action, entity: { type: input.entity.type, id: input.entity.id, label: input.entity.label },
      changes: redactAuditValue(input.changes ?? null),
      metadata: redactAuditValue({ outcome: 'succeeded', ...input.metadata }),
      ip: input.context.ip, userAgent: input.context.userAgent,
      requestId: input.context.requestId,
    };
    if (session) {
      await this.model.create([record], { session });
      return;
    }
    try {
      await this.model.create(record);
    } catch (error) {
      if (required) throw error;
      // Do not copy provider/database error text, which may include credentials.
      this.logger.error(`AUDIT_WRITE_FAILED action=${input.action} entity=${input.entity.id.toHexString()} requestId=${input.context.requestId}`);
    }
  }

  /** Existing multi-step catalogue mutations must persist intent BEFORE their
   * first write. Requested is never a claim of success; outcome uses operationId.
   * This avoids changing taxonomy propagation architecture in P1. */
  async recordIntent(input: AuditRecordInput): Promise<string> {
    const operationId = randomUUID();
    await this.record({ ...input, action: AuditAction.ADMIN_MUTATION_REQUESTED,
      changes: null, metadata: { operationId, outcome: 'requested', intendedAction: input.action },
    }, undefined, true);
    return operationId;
  }

  /**
   * Records a change, computing the diff, and writes nothing when nothing
   * changed.
   *
   * An audit row saying "somebody saved this and altered nothing" is noise in a
   * log whose whole value is signal — and a two-year retention makes noise
   * expensive.
   */
  async recordChange(
    input: Omit<AuditRecordInput, 'changes'> & {
      readonly before: Record<string, unknown>;
      readonly after: Record<string, unknown>;
    },
    session?: ClientSession,
  ): Promise<void> {
    const changes = diffFields(input.before, input.after);

    if (changes === null) return;

    await this.record({
      actor: input.actor,
      action: input.action,
      entity: input.entity,
      changes,
      metadata: input.metadata ?? null,
      context: input.context,
    }, session);
  }
}
