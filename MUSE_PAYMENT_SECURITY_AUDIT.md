# Payment Security Audit — Wallet/InstaPay and COD

Adversarial audit, third session (2026-11-21). Starting HEAD `1a9d76f`
(17 commits on `muse/autonomous-engineering`). Method: a dedicated
adversarial Jest suite (`apps/api/test/checkout/payment-adversarial.spec.ts`,
11 tests) executed against the real application on a real MongoDB
replica set — no mocked persistence — plus code inspection of
`PaymentVerificationService`, the lifecycle service, and the DTOs.
No real payments, no real messages; all data is isolated test data.

## Verdict in one paragraph

The core design held under attack: decisions are authorized from the
database profile (not the JWT claim), amount-matched exactly, guarded
on the current payment state so concurrent or repeated decisions
cannot double-apply, and written to the audit trail in the same
transaction. Two genuine defects were found and fixed (PAY-1, PAY-2).
One structural exposure remains open by design and needs an owner
decision (PAY-3). Nothing found allows a customer, a screenshot, or a
WhatsApp action to mark anything PAID.

## Findings

### PAY-1 — HIGH — An administrator could approve the payment on their OWN order (FIXED, `a911c20`)

- **Scenario**: an account holding ADMIN places a Wallet order as a
  customer, then calls `POST /admin/orders/:id/payment/verify` on it
  with the correct amount.
- **Observed before fix**: HTTP 200; the order became PAID. The
  "second pair of eyes" the whole workflow exists for was absent —
  the one insider path by which a declared transfer becomes money
  with no independent review.
- **Fix**: `decide()` now refuses when the decider is the order's
  customer (403, explicit message). Another administrator can always
  decide, so no legitimate flow is blocked.
- **Evidence**: adversarial test "an admin cannot approve a payment on
  their OWN order" — failed before the fix (expected 403, received
  200), passes after. The original manual-payment suite still passes
  unchanged (11/11).

### PAY-2 — MEDIUM — Resubmission resurrected the payment round on a CANCELLED order (FIXED, `a911c20`)

- **Scenario**: admin rejects a Wallet payment → customer cancels the
  order (cancellation deliberately does not touch payment state) →
  customer calls `POST /orders/:id/payment/resubmit`.
- **Observed before fix**: HTTP 200; the cancelled order's payment
  returned to PENDING_VERIFICATION — a verification round that
  `decide()` will always refuse (terminal order), i.e. an undead
  queue entry the customer was told is a fresh chance.
- **Fix**: `resubmit()`'s guarded update now excludes CANCELLED and
  RETURNED orders, and the refusal is the same STATE validation
  `decide()` uses for terminal orders (400).
- **Evidence**: adversarial test "resubmission is refused on a
  CANCELLED order" — failed before the fix (expected refusal, received
  200), passes after.

### PAY-3 — HIGH (business risk) — Fulfilment does not wait for payment verification (OPEN — owner decision)

- **Observed, proven by test**: a Wallet order whose payment was
  **rejected** (VERIFICATION_REJECTED) can be confirmed, shipped, and
  delivered end-to-end. The goods end up with the customer; no money
  was ever verified. The same holds while PENDING_VERIFICATION.
- **Why it is not a code bug per se**: the lifecycle deliberately
  separates delivery from payment for manual methods (ADR-ORDER-002 —
  delivery must never *mark* a manual order PAID, and it doesn't;
  revenue reporting counts PAID only, verified in code). The missing
  piece is a *gate*: nothing requires PAID before SHIPPED for prepaid
  methods.
- **Why it is still high risk**: Wallet/InstaPay are sold to the
  customer as prepayment. Every other control in this workflow is
  void if the warehouse ships first — a fraudulent or mistaken
  transfer then costs the goods, not just an admin's time.
- **Recommendation**: owner decides whether CONFIRMED or SHIPPED for
  manual-transfer orders requires `payment.status = PAID`. If yes,
  the change is small (a transition precondition) and the adversarial
  suite's EVIDENCE test is the one to flip. This audit did not change
  the rule: it is a business rule, and the brief forbids changing
  payment business rules unilaterally.

### PAY-4 — LOW (observation) — The same segregation-of-duties question exists on the COD lifecycle path

An admin can place a COD order and walk it to DELIVERED themselves,
which marks it PAID (cash collection is attested by the same person).
This is inherent to how COD works in a small operation — the operator
*is* the cash collector — and is recorded here only so the owner sees
the whole picture next to PAY-1. No change recommended without an
owner decision.

## Attacks that were tried and FAILED (the system held)

All proven by the adversarial suite against persisted state:

| Attack | Result |
| --- | --- |
| Two admins approve simultaneously | Exactly one 200, one 409; PAID once; exactly one succeeded audit row |
| Approve and reject race | Exactly one decision survives; `decidedBy` matches the winner |
| Replay a successful approval | Refused (state no longer PENDING_VERIFICATION) |
| Stale ADMIN token after DB role revocation | 403 — authority is resolved from the database, not the token claim |
| Decision on a RETURNED order still PENDING_VERIFICATION | 400 (session-2 fix holds) |
| Decision on a CANCELLED order | 400 (session-2 fix holds) |
| Negative / fractional / string / missing `confirmedAmount` | 400 each (DTO: `@IsInt @Min(0) @Max(MAX_SAFE_INTEGER)`) |
| Amount off by one minor unit, either direction | 400 AMOUNT_MISMATCH |
| Amount omitting the shipping fee | 400 AMOUNT_MISMATCH — comparison is against the grand total |
| Decision attempted on a COD order | 400 — only manual methods enter verification |
| Nonexistent order id / malformed id | 404 / 400 |
| Unauthenticated caller | 401 |
| Customer calling verify/reject | 403 |
| Customer resubmitting ANOTHER customer's order | 404 (ownership is a query condition, not a post-load check) |
| Resubmission while PENDING_VERIFICATION or after PAID | 409 — evidence cannot be replaced after approval |
| Screenshot / WhatsApp action marking paid | No such path exists in the codebase; PAID is reachable only via `approve` and the COD delivery effect |

## Residual risks not fully testable here

- **Evidence authenticity** is out of the system's reach by design:
  the transfer proof lives in WhatsApp (owner decision D16). The
  system guarantees *who decided, for how much, and when* — it cannot
  guarantee the screenshot was real. That is the owner's process
  risk, priced into the manual workflow.
- **Amount integrity after placement**: approval compares against
  `pricing.grandTotal` read inside the decision transaction. No
  post-placement flow edits an order's totals (verified by inspection
  of the admin order surface), so there is no known path to shrink a
  total before approving it.
- **Authorized-verifier list**: any ADMIN/SUPER_ADMIN can decide.
  The owner has not yet named a narrower verifier set (open owner
  input since session 1); PAY-1 narrows the worst case (self-dealing)
  but a two-admin shop should still decide who *should* verify.
