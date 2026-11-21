/**
 * The order lifecycle. ONE axis.
 *
 * Authority: docs/architecture/ORDER-LIFECYCLE.md §2.
 *
 * Legacy carried three independent status columns — 7 x 6 x 5 = 210
 * combinations with no cross-field validation anywhere — and live data already
 * contained incoherent states (orders `shipped` while payment was `pending`,
 * one `delivered` while fulfilment was `unfulfilled`). This is that collapsed to
 * a single fulfilment axis plus a separate payment axis below.
 *
 * The COMPLETE frozen set is declared here although checkout can only produce
 * `PLACED`. Two reasons, both about contracts rather than convenience:
 *
 *  1. A generated Dart enum is exhaustive. Adding a value later is a breaking
 *     change for a mobile client already installed on a real device, which is
 *     exactly what API-CONTRACT.md §8's "additive-only within v1" forbids.
 *  2. The persisted enum validator must already accept the value that the state
 *     machine will write, or introducing transitions becomes a data migration.
 *
 * Declaring the vocabulary is not implementing the machine: there is no
 * transition matrix in this phase, and no endpoint that can change a status.
 */
export enum OrderStatus {
  /** Submitted by the customer. Stock is already committed. */
  PLACED = 'PLACED',
  /** An admin verified it, typically by phone — the real COD business step. */
  CONFIRMED = 'CONFIRMED',
  SHIPPED = 'SHIPPED',
  /** Terminal. Under COD, delivery IS the payment event. */
  DELIVERED = 'DELIVERED',
  /** The courier attempted and failed. Retryable, or returned. */
  DELIVERY_FAILED = 'DELIVERY_FAILED',
  /** Terminal. Cancelled before dispatch; stock restored. */
  CANCELLED = 'CANCELLED',
  /** Terminal. Goods came back; stock restored. */
  RETURNED = 'RETURNED',
}

/** All lifecycle statuses in official order. */
export const ORDER_STATUSES: readonly OrderStatus[] = Object.values(OrderStatus);


/**
 * Payment, on its own axis.
 *
 * Authority: ORDER-LIFECYCLE.md §3. Every COD order is `PENDING` until the
 * courier collects cash, which under ADR-ORDER-002 happens atomically with the
 * transition to `DELIVERED`. That is what makes "delivered but unpaid"
 * structurally impossible rather than merely discouraged.
 */
export enum PaymentStatus {
  PENDING = 'PENDING',
  /**
   * A manual Wallet/InstaPay transfer has been claimed by the customer and
   * is waiting for an authorized admin to verify it (owner decisions
   * D01/D03). This is NOT paid: no revenue, no fulfilment-as-paid treatment.
   * Only `PaymentVerificationService.approve` may move it to PAID.
   */
  PENDING_VERIFICATION = 'PENDING_VERIFICATION',
  /**
   * An admin reviewed a manual transfer and rejected it. Never means paid.
   * The customer may resubmit evidence, which returns the order to
   * PENDING_VERIFICATION (D03).
   */
  VERIFICATION_REJECTED = 'VERIFICATION_REJECTED',
  PAID = 'PAID',
  REFUNDED = 'REFUNDED',
}

/**
 * The approved payment methods (D01): Cash on Delivery, plus manual
 * electronic wallet and InstaPay transfers with mandatory authorized admin
 * verification. No online gateway exists in this scope. The enum is data a
 * client renders from, not an assumption baked into its UI.
 */
export enum PaymentMethod {
  COD = 'COD',
  WALLET = 'WALLET',
  INSTAPAY = 'INSTAPAY',
}

/** True for the methods that go through manual admin verification. */
export function isManualTransfer(method: PaymentMethod): boolean {
  return method === PaymentMethod.WALLET || method === PaymentMethod.INSTAPAY;
}

/** The payment status a newly placed order starts in, per method. */
export function initialPaymentStatusFor(method: PaymentMethod): PaymentStatus {
  return isManualTransfer(method) ? PaymentStatus.PENDING_VERIFICATION : PaymentStatus.PENDING;
}

/**
 * The status every checkout-created order starts in. Server-controlled: no DTO
 * in the system carries a status field, so there is nothing for a client to
 * submit.
 */
export const INITIAL_ORDER_STATUS = OrderStatus.PLACED;

/** Every COD order is unpaid at placement, by definition. */
export const INITIAL_PAYMENT_STATUS = PaymentStatus.PENDING;
