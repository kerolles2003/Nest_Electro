# PAY-3 Remediation Report — fulfilment waits for verified payment

Date: 2026-11-21 (remediation session, following the adversarial audit)
Branch: `muse/autonomous-engineering` — changes are in the working tree,
uncommitted, per the mission's staging restriction.

## The owner decision being implemented

Approved verbatim by the owner on 2026-11-21:

- Wallet/InstaPay orders **must not enter shipping or fulfilment until
  payment status is `PAID`**, and `PAID` is reachable only through the
  existing authorized manual verification workflow.
- Screenshots, WhatsApp redirects, customer claims or payment evidence
  must never independently authorize fulfilment.
- Enforcement must be on the backend, covering every fulfilment entry
  point.
- COD orders may enter fulfilment before cash collection and must
  remain unpaid until collection is explicitly confirmed; the manual
  restriction must not leak into COD.

This supersedes the behaviour the adversarial audit recorded as PAY-3
(a `VERIFICATION_REJECTED` wallet order walked confirm → ship →
deliver) and qualifies ADR-ORDER-002's separation of delivery from
payment for manual transfers: delivery still never *creates* a manual
payment, and now fulfilment cannot start before one exists.

## Enforcement point

One gate, in the one place every fulfilment transition passes through:

- **File:** `apps/api/src/modules/orders/application/order-lifecycle.service.ts`,
  inside `OrderLifecycleService.apply()` — after the state-graph and
  actor checks, before the guarded update, **inside the transition
  transaction** and against the same order snapshot the guarded update
  matches on.
- **Rule:** a transition whose target is `CONFIRMED` or `SHIPPED`,
  on an order whose payment method is a manual transfer
  (`isManualTransfer`: WALLET or INSTAPAY), whose payment status is
  not `PAID`, is refused.
- **Refusal:** HTTP 422, new additive error code
  `PAYMENT_REQUIRED_BEFORE_FULFILMENT`
  (`apps/api/src/common/errors/error-code.enum.ts`), with
  `details[0].field = 'paymentStatus'` naming the current payment
  status. 422 follows the catalogue's own precedent
  (`ADDRESS_LIMIT_REACHED`): the request is well formed and the edge
  exists; the order's payment *state* refuses it, and retrying
  succeeds once the payment state changes.

### Why these targets

- `CONFIRMED` is the first fulfilment step — gating it means an unpaid
  manual order never enters the fulfilment pipeline at all.
- `SHIPPED` is gated as well so no path can dispatch without passing
  the gate — including **retry-shipment** (`DELIVERY_FAILED → SHIPPED`),
  which matters for orders that entered fulfilment before the gate
  existed (pre-gate data).
- `DELIVERED` is not gated: it is reachable only from `SHIPPED`, and
  gating it would strand parcels already with a courier. A pre-gate
  order already `SHIPPED` while unpaid can still be delivered — see
  "Remaining risks".
- Cancellation and return are remedial, not fulfilment entry, and are
  not gated (a customer must always be able to cancel an unpaid order).

### Why this covers every entry point

`transitionByStaff` (all six admin actions) and `cancelForCustomer`
are the only callers that move an order; the repository's
`applyTransition` is called only from `apply()`. There is no second
lifecycle implementation, no bulk/import path, and no UI-side state
writes — the admin UI calls the same endpoints, so the gate binds
direct API callers and the console identically. Because the check runs
inside the transaction against the transition's own snapshot, a
payment decision and a fulfilment attempt racing each other cannot
interleave into a bypass (proven by test 7 below).

## Test evidence

New suite: `apps/api/test/orders/pay3-fulfilment-gate.spec.ts`
(10 tests, real replica-set MongoDB, full HTTP stack). All pass.

| # | Scenario | Result |
|---|----------|--------|
| 1 | WALLET `PENDING_VERIFICATION` → confirm | 422 `PAYMENT_REQUIRED_BEFORE_FULFILMENT`, order stays `PLACED` |
| 2 | INSTAPAY `VERIFICATION_REJECTED` → confirm | 422, stays `PLACED` |
| 3 | WALLET verified `PAID` → confirm, ship | 200/200, `SHIPPED` + `PAID` |
| 4+5 | COD unpaid → confirm, ship | 200/200, payment still `PENDING` after shipping |
| 6 | COD → deliver | payment becomes `PAID` only at `DELIVERED` |
| 7 | verify ∥ confirm race | invariant holds: order is `CONFIRMED` only if payment is `PAID`; a confirm that read the pre-verification snapshot is refused 422 |
| 8a | Direct ship from `PLACED` | 409 `INVALID_STATE_TRANSITION` (state graph) |
| 8b | Retry-shipment on pre-gate data (`DELIVERY_FAILED`, unpaid, state constructed directly) | 422 from the gate, status unchanged |
| 9 | Customer token → confirm; anonymous → confirm | 403 / 401, order untouched |
| 10 | `PAID` wallet full cycle incl. delivery-failed → retry-shipment → deliver | all 200, ends `DELIVERED` + `PAID` |

### Existing tests updated (behaviour they encoded is now refused)

- `test/checkout/payment-adversarial.spec.ts` — the session-3
  *EVIDENCE* test that documented the old behaviour now asserts the
  gate (422 at confirm for a rejected wallet order). The RETURNED-order
  decision test now constructs the `RETURNED + PENDING_VERIFICATION`
  state directly (pre-gate data), since the API walk it used is
  refused at `CONFIRMED`; the behaviour under test (decide() refuses
  terminal orders) is unchanged.
- `test/checkout/manual-payment.spec.ts` — "DELIVERED does not pay an
  unverified manual order" reworked: the walk it performed is now
  blocked at confirm (asserted), and after verification the same walk
  delivers as `PAID`, proving delivery itself contributes nothing to
  the payment state.

### Contract artefacts

The new error code is additive; `docs/api/openapi.v1.json` and
`docs/api/index.html` were regenerated (`openapi:export`) and both
contract gates pass (`openapi:check`, `openapi:page:check`).

## Defect found by the full regression — and fixed

The first full-suite run after the gate landed failed 3 tests in
`test/p1/order-audit.spec.ts` — a unit-style spec that drives the
lifecycle service with a mocked repository whose order fixture has
**no `payment` subdocument**. The gate read `order.payment.method`
unconditionally and threw a `TypeError` (a 500 where a clean answer
belonged). The schema marks `payment` required, so API-created
orders always carry it; but a payment-less legacy document must not
crash the lifecycle. The gate now treats a missing payment
subdocument as "not classifiable as a manual transfer" (not gated),
which is the only defensible reading of absent data. For every
schema-valid order the behaviour is byte-identical. The affected
suite and the gate suite re-ran green (13/13), and the full
regression was re-run end-to-end on the final code; its tally is
recorded in `MUSE_EXECUTION_LOG.md`.

## Remaining risks / notes

- **Pre-gate orders already `SHIPPED` while unpaid** can still be
  delivered (deliberate: stranding parcels helps no one). No such
  orders can be created any more; any that exist in a real database
  are a one-off operational review, not a code path.
- The admin UI will surface the 422 as a failed confirm/ship action.
  A dedicated queue filter for `PENDING_VERIFICATION` orders
  (already in `MUSE_REMAINING_WORK.md`) would make the intended
  workflow — verify first, then fulfil — the path of least
  resistance; the backend does not depend on it.
- `ORDER-LIFECYCLE.md` still describes the pre-PAY-3 matrix; it
  should be annotated with the decision at the owner's convenience.
  Not edited here to keep this change scoped to code + tests.
