import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { AppException } from '../../../common/errors/app.exception';
import { TransactionService } from '../../../database/transaction.service';
import { AuditService, type AuditContext } from '../../audit/application/audit.service';
import { AuditAction, AuditEntityType } from '../../audit/domain/audit-action';
import { Role } from '../../users/infrastructure/schemas/user.schema';
import { UsersService } from '../../users/application/users.service';
import { isManualTransfer, OrderStatus, PaymentStatus } from '../domain/order-status';
import { Order, type OrderLean } from '../infrastructure/schemas/order.schema';

/**
 * Manual Wallet/InstaPay payment verification (owner decisions D01, D03).
 *
 * ## The rule this service exists to enforce
 *
 * A manual transfer becomes PAID in exactly one place: `approve`, called by
 * an authorized staff account, after confirming the received amount equals
 * the order's grand total. Everything else — checkout, a WhatsApp redirect,
 * a customer-declared sender, a screenshot — is evidence, never authority.
 *
 * ## How each required property is achieved
 *
 * - **Authorized**: the actor is resolved from the database profile (not
 *   the JWT claim) and must be ADMIN or SUPER_ADMIN, the same posture as
 *   every other privileged write in this codebase.
 * - **Amount-matched**: `approve` requires the confirmed received amount
 *   and refuses unless it equals `pricing.grandTotal` exactly.
 * - **Concurrency-safe / idempotent**: the decision is a single guarded
 *   update predicated on `payment.status: PENDING_VERIFICATION`. Two
 *   admins deciding at once cannot both win; a repeat decision after the
 *   fact matches nothing and is refused as a concurrent modification
 *   rather than silently succeeding twice.
 * - **Attributable and auditable**: the decision writes `decidedBy` /
 *   `decidedAt` onto the order AND an `ORDER_PAYMENT_CHANGED` audit row in
 *   the same transaction.
 * - **Rejection is a state, not a deletion**: rejection records the reason,
 *   keeps the order, and lets the customer resubmit evidence, which starts
 *   a fresh verification round (and clears the previous decision fields).
 */
@Injectable()
export class PaymentVerificationService {
  constructor(
    @InjectModel(Order.name) private readonly orders: Model<Order>,
    private readonly transactions: TransactionService,
    private readonly users: UsersService,
    private readonly audit: AuditService,
  ) {}

  /** Approves a pending manual transfer. The ONLY path to PAID for D01 methods. */
  async approve(input: {
    orderId: Types.ObjectId;
    actorId: Types.ObjectId;
    confirmedAmount: number;
    context: AuditContext;
  }): Promise<OrderLean> {
    return this.decide(input, 'approve');
  }

  /** Rejects a pending manual transfer, with a reason the customer can see. */
  async reject(input: {
    orderId: Types.ObjectId;
    actorId: Types.ObjectId;
    reason: string;
    context: AuditContext;
  }): Promise<OrderLean> {
    return this.decide(input, 'reject');
  }

  private async decide(
    input: {
      orderId: Types.ObjectId;
      actorId: Types.ObjectId;
      context: AuditContext;
    } & (
      | { confirmedAmount: number }
      | { reason: string }
    ),
    decision: 'approve' | 'reject',
  ): Promise<OrderLean> {
    const actor = await this.users.findById(input.actorId);
    if (actor === null) throw AppException.accountDisabled();
    if (![Role.ADMIN, Role.SUPER_ADMIN].includes(actor.role)) throw AppException.forbidden();

    return this.transactions.run(async session => {
      const order = await this.orders
        .findById(input.orderId)
        .session(session)
        .lean<OrderLean>()
        .exec();
      if (order === null) throw AppException.orderNotFound();

      if (!isManualTransfer(order.payment.method)) {
        throw AppException.validation([
          {
            field: 'paymentMethod',
            message: 'Only Wallet and InstaPay orders go through manual verification.',
            code: 'STATE',
          },
        ]);
      }

      /*
       * Cancellation and return deliberately do NOT touch payment state in
       * the lifecycle service, so a cancelled order can still be sitting in
       * PENDING_VERIFICATION. Deciding its payment would mark a dead order
       * PAID (or rejected) — refuse: a terminal order has no payment to
       * verify. Found in self-review of this service, 2026-11-21.
       */
      if (order.status === OrderStatus.CANCELLED || order.status === OrderStatus.RETURNED) {
        throw AppException.validation([
          {
            field: 'orderStatus',
            message: 'A cancelled or returned order cannot be verified for payment.',
            code: 'STATE',
          },
        ]);
      }

      if (order.payment.status !== PaymentStatus.PENDING_VERIFICATION) {
        throw AppException.concurrentModification();
      }

      const at = new Date();
      let set: Record<string, unknown>;

      if (decision === 'approve') {
        const confirmed = (input as { confirmedAmount: number }).confirmedAmount;
        if (confirmed !== order.pricing.grandTotal) {
          throw AppException.validation([
            {
              field: 'confirmedAmount',
              message: 'The confirmed amount does not match the order total.',
              code: 'AMOUNT_MISMATCH',
            },
          ]);
        }
        set = {
          'payment.status': PaymentStatus.PAID,
          'payment.collectedAt': at,
          'payment.verification.decidedBy': input.actorId.toHexString(),
          'payment.verification.decidedAt': at,
          'payment.verification.decisionNote': null,
        };
      } else {
        set = {
          'payment.status': PaymentStatus.VERIFICATION_REJECTED,
          'payment.verification.decidedBy': input.actorId.toHexString(),
          'payment.verification.decidedAt': at,
          'payment.verification.decisionNote': (input as { reason: string }).reason,
        };
      }

      const updated = await this.orders
        .findOneAndUpdate(
          { _id: input.orderId, 'payment.status': PaymentStatus.PENDING_VERIFICATION },
          { $set: set },
          { new: true, session },
        )
        .lean<OrderLean>()
        .exec();
      if (!updated) throw AppException.concurrentModification();

      await this.audit.record(
        {
          actor: { id: actor._id, role: actor.role, name: actor.fullName, email: actor.email },
          action: AuditAction.ORDER_PAYMENT_CHANGED,
          entity: { type: AuditEntityType.ORDER, id: input.orderId, label: order.orderNumber },
          changes: {
            before: { paymentStatus: PaymentStatus.PENDING_VERIFICATION },
            after: { paymentStatus: updated.payment.status },
          },
          metadata: {
            outcome: 'succeeded',
            decision,
            method: order.payment.method,
            ...(decision === 'approve'
              ? { confirmedAmount: (input as { confirmedAmount: number }).confirmedAmount }
              : { reason: (input as { reason: string }).reason }),
          },
          context: input.context,
        },
        session,
      );

      return updated;
    });
  }

  /**
   * The customer resubmits transfer evidence after a rejection: a new
   * declared sender, a fresh submission time, and the previous decision
   * cleared. Guarded on VERIFICATION_REJECTED, so it cannot resurrect a
   * paid, pending, or cancelled-payment order.
   */
  async resubmit(input: {
    orderId: Types.ObjectId;
    userId: Types.ObjectId;
    transferSender: string;
    context: AuditContext;
  }): Promise<OrderLean> {
    const customer = await this.users.findById(input.userId);
    if (customer === null) throw AppException.accountDisabled();

    return this.transactions.run(async session => {
      const updated = await this.orders
        .findOneAndUpdate(
          {
            _id: input.orderId,
            userId: input.userId,
            'payment.status': PaymentStatus.VERIFICATION_REJECTED,
          },
          {
            $set: {
              'payment.status': PaymentStatus.PENDING_VERIFICATION,
              'payment.verification.transferSender': input.transferSender,
              'payment.verification.submittedAt': new Date(),
              'payment.verification.decidedBy': null,
              'payment.verification.decidedAt': null,
              'payment.verification.decisionNote': null,
            },
          },
          { new: true, session },
        )
        .lean<OrderLean>()
        .exec();

      if (!updated) {
        const exists = await this.orders
          .findOne({ _id: input.orderId, userId: input.userId })
          .session(session)
          .lean<OrderLean>()
          .exec();
        if (exists === null) throw AppException.orderNotFound();
        throw AppException.concurrentModification();
      }

      /*
       * A resubmission is a payment-state change, so it belongs in the same
       * audit trail as the decisions — without this row the trail showed a
       * rejection followed by a decision on a round nobody recorded
       * starting. Written in the same transaction as the state change.
       */
      await this.audit.record(
        {
          actor: {
            id: customer._id,
            role: customer.role,
            name: customer.fullName,
            email: customer.email,
          },
          action: AuditAction.ORDER_PAYMENT_CHANGED,
          entity: { type: AuditEntityType.ORDER, id: input.orderId, label: updated.orderNumber },
          changes: {
            before: { paymentStatus: PaymentStatus.VERIFICATION_REJECTED },
            after: { paymentStatus: PaymentStatus.PENDING_VERIFICATION },
          },
          metadata: { outcome: 'succeeded', decision: 'resubmitted', method: updated.payment.method },
          context: input.context,
        },
        session,
      );

      return updated;
    });
  }
}
