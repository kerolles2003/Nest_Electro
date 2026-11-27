# PAY-3 Fail-Closed Remediation Report

Date: 2026-11-22 · Branch: `muse/autonomous-engineering` ·
HEAD: `bb217fa54a683eeac318db20b1d3739e59b8356c` (unchanged —
this session's work is, like the previous remediation's, entirely
in the working tree; nothing staged or committed).

## The finding (independent review)

The PAY-3 gate as first implemented read:

```ts
order.payment !== undefined &&
isManualTransfer(order.payment.method) &&
order.payment.status !== PaymentStatus.PAID
```

An order with **no payment subdocument** therefore failed the
condition and **passed the gate** — fail-open on exactly the data
most likely to be corrupt (pre-schema / legacy documents). The
review also noted that the `DELIVERED` payment effect read
`order.payment.method` unguarded (a `TypeError` → 500 on such a
document). Both observations were correct.

## The fix — `OrderLifecycleService` (only file changed in src)

### 1. The gate is now a validator: `assertPaymentGate(order, to)`

`apply()` now calls it for **every** fulfilment transition —
`CONFIRMED`, `SHIPPED`, and `DELIVERED` — inside the transition
transaction, against the same snapshot the guarded update matches
on. It refuses, with the existing error code
`PAYMENT_REQUIRED_BEFORE_FULFILMENT` (HTTP 422, no new codes), on:

| Payment data | Detail code | CONFIRMED / SHIPPED | DELIVERED |
|---|---|---|---|
| payment missing or `null` | `PAYMENT_DATA_MISSING` | Refused | Refused |
| method absent / not in `PaymentMethod` | `PAYMENT_METHOD_UNRECOGNIZED` | Refused | Refused |
| status absent / not in `PaymentStatus` | `PAYMENT_STATUS_UNRECOGNIZED` | Refused | Refused |
| explicit COD (any recognized status) | — | **Allowed** | Allowed; effect pays + `collectedAt` |
| WALLET / INSTAPAY + `PAID` | — | **Allowed** | Allowed; effect changes nothing |
| WALLET / INSTAPAY + not `PAID` | `PAYMENT_REQUIRED` | Refused | (unreachable post-gate for API data; for pre-gate SHIPPED data the delivery proceeds and pays nothing — see Risks) |

Only an **explicitly recognized** COD method receives the COD
exemption. Missing data is never inferred as COD, never
defaulted, and never silently repaired — the corrupt document is
left exactly as found for an operator to correct.

### 2. The delivery effect reads fail-closed

`effectsFor`'s `DELIVERED` branch now reads
`order.payment?.method !== PaymentMethod.COD`: only an explicit
COD method collects cash; anything else — including a missing
record — takes the no-payment-change branch. (Within `apply()`
the gate has already refused such orders; the defensive read
keeps the effect safe by construction, not by call order.)

### 3. What did not change

The payment schema, the verification workflow, the transition
matrix, the audit/concurrency machinery, and the self-approval
prohibition are untouched. No migration was needed or performed:
the schema already requires `payment` with enum-validated
`method`/`status`, so invalid states can only arrive from outside
the API (pre-schema data) — the gate is the correct place to
refuse them, not a data rewrite.

## Test-fixture correction (not an assertion change)

`test/p1/order-audit.spec.ts` drives `CONFIRMED` with a mocked
order that had **no payment subdocument at all** — a
schema-impossible order. Under fail-closed it is now (correctly)
refused before the audit behaviour under test can occur. The
fixture was given the payment subdocument of a canonical COD
order (`COD` / `PENDING`); every assertion in the suite is
unchanged, and the suite's subject (the audit transaction
boundary) is unaffected.

## Tests

New suite `apps/api/test/orders/pay3-fail-closed.spec.ts`
(**12/12**), real replica-set integration, corrupt states written
through the native driver (no Mongoose repair), every refusal
asserting both the response and the persisted state:

- `payment === undefined` → 422, order untouched, data unrepaired
- `payment === null` → 422, untouched
- `payment.method === undefined` → 422
- unknown method `CARD` → 422 (never read as COD)
- missing status → 422 · unknown status → 422
- unknown method also blocks SHIPPED from a CONFIRMED state
- delivery with missing payment object → 422, still SHIPPED,
  nothing auto-paid, no 500
- delivery with unknown method → 422, payment **not** marked PAID
- controls: explicit COD full walk (PAID + `collectedAt` only at
  delivery); legacy `DELIVERY_FAILED + VERIFICATION_REJECTED`
  retry-shipment refused; verified INSTAPAY order delivers as
  PAID with delivery adding nothing

Targeted scope (gate suite 10 + fail-closed 12 + manual-payment +
payment-adversarial + order-lifecycle + admin-orders +
order-audit): **134/134**. The verify∥confirm race invariant
(gate suite test 7) passes unchanged.

Full regression, type-checks, lint, builds, and OpenAPI gates:
see the final tallies in `MUSE_EXECUTION_LOG.md` (this report is
written alongside them). One environmental note: a first full
run executed concurrently with production builds failed one
unrelated test (`addresses.spec.ts`, `read ECONNRESET`, 106 s
suite time under CPU contention); the authoritative full run was
re-executed with nothing else running.

## Risks / notes

- A **pre-gate** order already `SHIPPED` with a *valid* unpaid
  manual payment can still be delivered (delivery pays nothing).
  This is the standing decision from the first remediation —
  parcels already with a courier are not stranded — and the
  fail-closed change does not alter it: such an order's data is
  valid, merely unpaid.
- An order with corrupt payment data can still be **cancelled**
  (cancel is not a fulfilment transition and restores stock;
  blocking it would trap stock behind corrupt data). It cannot
  be confirmed, shipped, or delivered.
- The gate's refusals name the data problem in the error details
  (`PAYMENT_DATA_MISSING` etc. under the one existing error
  code), so an operator hitting one knows the record — not the
  request — is what needs attention.
