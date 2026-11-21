# Nest Electro — Owner Decisions, 2026-10-07

> **Later owner scope override — 2026-10-07:** [G_ENTRY_SCOPE_DECISION_2026-10-07.md](G_ENTRY_SCOPE_DECISION_2026-10-07.md) supersedes D27/OA-02/OA-03/OA-04 blocker statements and Supabase launch-dependency/safety-remediation requirements in this historical OA-01 record. Supabase is OUT OF CURRENT LAUNCH SCOPE / LEGACY; historical credential work is deferred outside current execution; temporary Mongo certification moves to separately authorized production DB preparation/cutover. OA-01 is CLOSED with its explicit inputs retained for dependent tasks. G-ENTRY = PASS — CURRENT IMPLEMENTATION SCOPE; no implementation or production authorization. D01 and all other approved policy wording below remain unchanged.

## Owner

Project Owner — Kerolles Sobhy

## Date

2026-10-07

## Evidence and precedence

**OWNER CONFIRMED:** supplied OA-01 Launch Decisions Closure instruction, sections 2–22, in this conversation on the date above. Recording approval does not certify implementation, provider accounts, legal compliance or runtime behavior. No extra personal information is recorded.

This is the current launch-decision record. It supersedes conflicting launch choices/open-question labels in the historical MASTER_IMPLEMENTATION_PLAN.md §5, docs/P0_DECISIONS.md, P0_COMPLETION_REPORT.md and G_ENTRY_UNBLOCK_REPORT.md. Those historical observations remain valid as dated evidence; no findings are declared fixed. Affected task IDs below are scope annotations for future authorization, not permission to execute them.

### Decision-ID cross-reference

The owner instruction changes two original IDs and broadens D05. Use the date and subject when citing them; do not reinterpret old references silently.

| Original plan subject | Current owner decision |
|---|---|
| D02 return/refund plus manual-payment policy questions | D02 returns/refunds; D03 now specifically manual-transfer rejection/fulfilment |
| Original D03 shipping zones | Current D04 shipping zones (Egypt only; explicit table still required) |
| Original D04 shipping fees | Current D05 shipping fees plus free-shipping decision |
| Original D05 free-shipping threshold | Current D05; threshold remains open |
| D01, D06–D30 | IDs retained; launch dispositions updated below |

Consequently old P5.2 zone/rate references to D03/D04 are read through current D04/D05, while P6.5/P7.3–4 also depend on current D03. This is a documentation cross-reference only; no task or application state was renumbered.

## Locked Decisions

All rows are attributable to the owner instruction above (D01/D07/D12 and core authority reaffirm existing decisions). **RESOLVED — POLICY DIRECTION** does not close a listed commercial/legal input. **DEFERRED** selects exclusion from launch, not completed functionality. External dependencies are unprovisioned/unverified. Each row applies as of 2026-10-07.

| ID | Subject | Exact status | Owner-approved direction / scope impact | Remaining input or boundary | Affected future phase/tasks |
|---|---|---|---|---|---|
| D01 | Payment | LOCKED — OWNER CONFIRMED | COD + manual electronic wallet/InstaPay transfer; mandatory authorized admin verification for manual transfers; no online gateway. | Receiving instructions, WhatsApp destination and authorized verification operators remain inputs. | P6.5, P7.3–4, P4.3, P10.1–3; P8.6 gateway deferred |
| D02 | Returns / refunds | RESOLVED — POLICY DIRECTION; OPEN — POLICY INPUT REQUIRED | Admin-controlled manual review/approval; no automatic customer-initiated refund. Record decision, explicit amount and auditable refund status; no silent financial change. | Approved return windows, eligibility, fees, exclusions and policy wording before launch; settlement responsibility and any partial-return/cancellation rules before their implementation. | P7.2–3, P4.3, P5.5, P6.5 |
| D03 | Manual transfer rejection / fulfilment | RESOLVED — POLICY DIRECTION | Submission remains pending verification; rejection never means paid. Resubmission may follow eventual UX. Fulfilment must not treat an unverified transfer as paid; COD normal flow remains. Reuse compatible domain states. | Exact resubmission UX belongs to later design; no reservation/expiry deadline or shipment-hold rule is invented. Obtain policy for any such behavior before implementation. | P6.5, P7.3–4, P4.3, P10.1–3 |
| D04 | Shipping zones | RESOLVED — POLICY DIRECTION; OPEN — OWNER INPUT REQUIRED | Egypt only; explicit approved service zones, not assumed universal coverage. | Operational supported/unsupported zone table before launch; no invented city rates. | P5.2, P5.5, P6.5 |
| D05 | Shipping fees / free shipping | RESOLVED — CONFIGURED ZONE RATES; OPEN — OWNER DECISION REQUIRED | Rates configured by approved zone; no guessed globally hardcoded fee. Free-shipping threshold is not approved. | Actual rate table and free-shipping enablement/threshold decision; no attributable approved threshold found in required records or targeted ADR check. Runtime disabled default is not owner approval. | P5.2, P5.5; P8.1 build deferred |
| D06 | Carrier | RESOLVED — MANUAL OPERATIONS; Carrier automation: DEFERRED | Launch may operate shipping manually/admin-side; no carrier API required. | Carrier/operator, tracking, dispatch/delivery promises and retry/return-to-origin handling before operational launch; no SLA invented. | P5.2, P7.4; E07 API branch deferred |
| D07 | Google OAuth | DEFERRED | Existing Google deferral preserved; no parallel Supabase identity. | None for launch OAuth; reopening requires explicit approval. | P8.5 deferred |
| D08 | Coupons | DEFERRED | Not a launch dependency; existing coupon paths cannot become an active authority by accident. | No coupon commercial values needed for launch; old engineering decisions retained only for a later approved scope. | P8.1 deferred-feature safety branch, P9.1 |
| D09 | Reviews | DEFERRED | No customer review system required at initial launch; do not invent provenance. | No review feature inputs for launch; residual safety and truthful presentation still required. | P8.2 deferred-feature safety branch, P5.3, P9.1 |
| D10 | Campaigns | DEFERRED | No campaign-management system required for launch. | None for a campaign build; existing truthful catalogue merchandising is not new campaign scope. | P8.7 build deferred |
| D11 | Blog | DEFERRED | Blog functionality is not a launch dependency. Residual implementation must not compromise Nest/Mongo commerce authority. | No new editorial provider/content implementation required; reachable residual surfaces still require safe treatment. | P8.3 deferred-feature safety branch, P9.1; P1.1 applicable safety remains |
| D12 | Wishlist | LOCKED — LOCAL/BROWSER MVP; sync DEFERRED | Existing local/browser wishlist remains; no account-sync implementation. | None for account sync at launch. | P8.4 local branch, P9.1 |
| D13 | Tax / invoices | RESOLVED — POLICY DIRECTION; Tax automation: DEFERRED; OPEN — LEGAL INPUT REQUIRED | No automated tax engine. Preserve store-approved financial amounts; invent neither rates nor invoice/legal requirements. Existing integer EGP representation is preserved, not evidence of tax compliance. | Applicable business/legal tax/invoice approval before launch; approve any required rate/representation before implementation. | P7.3, P5.3, P10; P8.6 gateway deferred |
| D14 | Email | Email functionality: REQUIRED; Provider provisioning: EXTERNAL DEPENDENCY | At minimum account/email verification, order confirmation and important order-status notifications. Existing password-reset baseline is not removed by this minimum. | Provider/account, sender/domain, reply-to/locales where needed and real deliverability verification; no credentials or DNS invented. | P4.1–3, P10.3 |
| D15 | Media | Durable media: REQUIRED; Media provider provisioning/configuration: EXTERNAL DEPENDENCY | Production catalogue requires durable storage. Preserve existing server-mediated media architecture; no replacement provider selected here. | Actual provider/account configuration, ownership/retention/recovery policy and isolated provider-test resources. Existing Cloudinary adapter is not account readiness. | P1.3–5, P4.4, P5.3, P9.7 |
| D16 | Support | RESOLVED — WHATSAPP; OPEN — CONFIGURATION INPUT REQUIRED | WhatsApp is the launch customer-support channel and manual-transfer evidence channel. | Actual WhatsApp destination and operational staffing/response promises, if published. No phone number invented. | P6.4–5, P5.5, P7.3–4 |
| D17 | Legal / policy | Policy approval: REQUIRED BEFORE LAUNCH; OPEN — OWNER INPUT REQUIRED | Truthful returns/refund, shipping/delivery, privacy and terms/conditions policies are required. | Approved text and applicable legal review, including receipt/sender-information handling; no legal approval claimed. | P5.5, P7.3; future consent work only if activated |
| D18 | Analytics / consent | Analytics: DEFERRED | Marketing analytics do not block commerce launch. Consent/privacy requirements precede any future activation. | None for marketing integration at launch; operational monitoring remains required under D29. | P8.8 marketing deferred; P9.6 operational work retained |
| D19 | Recovery / backup | Backup/recovery: REQUIRED; Exact RPO/RTO: OWNER DECISION REQUIRED | Production must have backup/recovery capability. | Approved numerical RPO/RTO, retention and recovery ownership before recovery certification; no targets invented. | P9.7, P10.4 |
| D20 | Hosting / runtime | Hosting/runtime: REQUIRED; Specific provider/topology: EXTERNAL / OWNER DECISION | An approved production environment is required; none selected or provisioned by this decision. | Hosting provider/region/runtime/ingress/topology approval before dependent implementation and certification. | P3.3, P9.4–5, P10.4 |
| D21 | Domains / TLS | Production domains: OWNER/INFRASTRUCTURE INPUT REQUIRED | Approved storefront and API hosts, HTTPS/TLS and correct origins required. | Actual owned domains and admin exposure/origin arrangement, TLS/DNS responsibility; no hostname guessed. | P4.1, P4.4, P5.4, P9.3–5 |
| D22 | Opening stock provenance | Production opening stock: OWNER-SUPPLIED / OWNER-APPROVED DATA REQUIRED | No fabricated real stock; attributable owner approval required. Synthetic/test stock only in isolated tests. | Approved quantities, provenance and effective date before production data acceptance; salesCount interpretation where required by ledger/reporting remains unapproved. | P2.4, P5.3, P10; final migration separately deferred |
| D23 | Review provenance | Production review provenance: NOT REQUIRED FOR LAUNCH; synthetic production reviews PROHIBITED | Reviews deferred; future real reviews require attributable customer/content provenance. Synthetic reviews only in isolated test/certification environments. | No launch review dataset required. Unproven production review/rating claims must not be presented as real; no data deletion authorized now. | P5.3/F38 safety retained; P8.2 review build deferred |
| D24 | Product content ownership | Production catalog content: OWNER-SUPPLIED / OWNER-APPROVED | Attributable content owner required for name, description, images, category, brand, price, stock and relevant specifications as applicable. | Approved real content/images/rights, availability and promises before production; no fabricated catalogue. | P5.3–5, P10.2–3 |
| D25 | Product deletion | RESOLVED — POLICY DIRECTION; retention detail pending | Do not hard-delete products with historical order references. Prefer inactive/archive where supported; preserve historical order integrity. | Exact retention requirements finalized during later implementation; this does not approve unrestricted deletion of other/shared-media products. | P1.5, P7.4, P9.7 |
| D26 | Token revocation | Secure token/session revocation: REQUIRED; Implementation: P3 | Do not weaken security for convenience. Existing staff invalidation protection remains. | P3 must specify and verify secure endpoint/session semantics; this is not owner acceptance of a particular stale-access window. | P3.4, P10.4 |
| D27 | Legacy grants / secret ownership | RESOLVED — AUTHORITY DIRECTION; BLOCKED — OA-02; BLOCKED — OA-03 | Nest/Mongo intended commerce authority. Live Supabase privilege and historical credential evidence remain separate blockers. | Existing OA-02/OA-03 evidence and authorized account-holder attribution; this owner policy is not a revocation receipt or grant export. | P0.2–3, P10.4 |
| D28 | Authority boundaries | LOCKED — OWNER CONFIRMED | Nest/Mongo authoritative for active auth/users/addresses/catalogue/inventory/cart/checkout/orders/shipping/refunds/payment state/relevant audit. Blog/reviews/coupons deferred; no duplicate business writers. | Future implementation must enforce boundaries; no production authority switch, dual write or migration authorized. | P8.1–4 safety/local branches, P9.1, P10.5 |
| D29 | Capacity / SLO / topology | RESOLVED — READINESS REQUIREMENT; OWNER / INFRASTRUCTURE DECISION REQUIRED | Production-like validation, observable runtime/API, adequate launch capacity and failure/recovery validation required. | Expected traffic, exact SLO/capacity targets and topology before dependent design/certification. No numerical targets assumed. | P3.3, P9.2, P9.5–7, P10.4 |
| D30 | Notifications | RESOLVED — SCOPE; OPEN — DELIVERY DETAILS | Required: email verification, order confirmation, important order-status changes. Manual WhatsApp: transfer evidence and support. No automated WhatsApp transactional provider approved. | Exact important-status/template/recipient matrix and retry/retention operational settings before implementation/certification; no extra admin alert channel invented. Preserve baseline reset email. | P4.2–3, P7.3–4, P9.6, P10.3 |

## Payment and financial boundary

COD is approved and does not require manual payment verification; it follows the normal approved fulfilment lifecycle. Manual Wallet/InstaPay is also approved: checkout shows configured instructions, the customer transfers externally and sends the order number, sender phone/account identifier and receipt screenshot through WhatsApp. That evidence leaves the order conceptually PAYMENT_PENDING_VERIFICATION. Only an authorized Nest server-side admin approval may make a manual transfer PAID; rejection must not do so and may lead to resubmission. Every verification action requires audit evidence.

Browser state, screenshots, WhatsApp messages and customer declarations are not authoritative payment sources. No revenue recognition, wallet settlement or release of financial value before manual approval. This does not add a wallet-ledger feature. Map pending/rejected review outcomes safely onto the existing model during later authorized implementation; do not add duplicate states merely to match these conceptual labels. This policy does not specify a stock-reservation timeout or permit treating shipment/delivery as manual-payment approval.

Returns/refunds are admin-controlled and manual. No automatic customer-initiated refund is approved. Admin must review against the supplied policy, explicitly approve any refund, record its amount/decision and auditable status, and preserve truthful financial state. Refund approval is not evidence that an external settlement happened; no automatic financial change is authorized by this record.

## Remaining Inputs

These are still OPEN or EXTERNAL DEPENDENCIES, not default values. Project owner supplies/approves business inputs and assigns appropriate operational/account holders; this record does not invent named service owners. No secrets should be placed in these documents.

| Input | Related decisions | Required before |
|---|---|---|
| Return/refund wording: windows, eligibility, fees, exclusions; actual settlement responsibility and any required partial-return/cancellation rules | D02, D17 | Policy-dependent implementation and production launch |
| Manual payment receiving instructions, WhatsApp destination and authorized verifier assignments; any commercial expiry/reservation/fulfilment-hold rule if needed | D01, D03, D16 | Completing checkout/admin flow and launch; do not invent such rules |
| Egypt supported/unsupported zones, rate table and operational handling of remote/failed delivery | D04–D06 | Configuring/verifying shipping and public promises |
| Explicit free-shipping enablement/threshold answer | D05 | Final shipping configuration/acceptance; no attributable approved threshold found |
| Manual carrier/operator, tracking and actual delivery/retry/return-to-origin process | D06 | Operator readiness and truthful delivery policy; no carrier API needed |
| Applicable formal tax/invoice/business/legal requirements and approved financial representation | D13, D17 | Relevant financial implementation and launch sign-off; no automated tax engine assumed |
| Email provider/account, sender/domain, reply-to/locales as needed and verified delivery | D14, D21 | P4 provider configuration/certification; secure provisioning separately authorized |
| Durable media account/configuration and retention/recovery ownership | D15, D25 | P4 media certification and P9 recovery; preserve existing adapter architecture |
| Actual WhatsApp number, staffing and any promised response times | D16 | Real support/contact content and launch; no automated WhatsApp provider |
| Approved returns, delivery, privacy and terms text, including handling of payment evidence | D17 | Public policy acceptance before production |
| Exact RPO/RTO, retention and restore owner | D19 | P9.7/P10.4 acceptance; no numerical targets guessed |
| Hosting/provider/region/runtime/ingress/topology and expected traffic/SLO/capacity targets | D20, D29 | Dependent P3/P9 design and production-like certification |
| Owned storefront/API domains and admin origin arrangement, TLS/DNS responsibility | D21 | Origin/sender/TLS configuration and launch; no DNS action now |
| Owner-approved opening stock with date/provenance; salesCount interpretation if required | D22 | Ledger/data acceptance; synthetic stock only in isolated tests |
| Attributable catalogue content owner and approved names/descriptions/images/rights/taxonomy/prices/stock/specifications | D24 | Catalogue production acceptance |
| Retention detail preserving all order references | D25 | Later deletion/recovery implementation; hard deletion of referenced products prohibited |
| Secure revocation semantics and verification design | D26 | P3; engineering detail, not approval to weaken security |
| Exact important-status email/template/recipient matrix and retry/retention details | D30 | P4 implementation/certification; baseline reset email preserved |

D27 evidence stays BLOCKED under OA-02/OA-03, and real isolated Mongo validation stays BLOCKED under OA-04. None is investigated or executed in OA-01. These dependencies are not relabelled as resolved policy inputs.

No launch coupon/review/campaign/blog/marketing/OAuth specification or provider account is requested for deferred features. Production review provenance is not required for launch, but synthetic reviews/verified claims cannot appear as real customer content. F38 truthful presentation and residual route/action/security boundaries remain future required safety work, not permission to build deferred features or delete data now.

## Scope impact on the roadmap

- Required customer/admin scope includes COD plus manual Wallet/InstaPay verification, manual admin-controlled returns/refunds, Egypt zone-based shipping, transactional email, durable media, manual WhatsApp support/evidence, truthful policies/catalogue, secure revocation and recovery/observability.
- P8.1/P8.2/P8.3 select their deferred-feature safety branches; no coupon, review or blog feature build is launch-critical. P8.7 campaign build and P8.8 marketing integration are deferred. Applicable P1.1/F05, P5.3/F38 and P9.1 authority/safety work is retained for any reachable residual surfaces.
- P8.5 Google and P8.6 online gateway remain deferred. Earlier P8.6 wording suggesting a COD-only deferred branch is superseded by D01's COD + manual-transfer model in P6.5/P7.3–4. No gateway webhook/merchant-account work is needed for this launch.
- P8.4 retains the existing local wishlist branch; account synchronization is deferred. No competing SQL writer is approved.
- E05/E06 and marketing E14–16 are not launch account dependencies. E07 carrier API automation and automated tax engine are deferred. Email/media/hosting/domains and operational readiness remain separate external dependencies, not provisioned services.
- D30 adds no automated WhatsApp provider. Analytics deferral does not remove operational monitoring, auditable payment/refund actions or baseline password-reset emails.
- Flutter remains deferred. Final production database migration/cutover stays outside current phases until functional completion, then separate planning/rehearsal/authorization. No deployment or implementation authorized by this decision record.

## Closure boundary

OA-01 records a clear launch direction for every decision while retaining explicit open inputs. It does not close all values, prove implementation or pass G-ENTRY. OA-02/OA-03/OA-04 remain unchanged and blocked; subsequent execution requires separate authorization.
