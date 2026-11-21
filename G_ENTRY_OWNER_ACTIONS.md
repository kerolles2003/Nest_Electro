# G-ENTRY — Current Owner Actions

## Current disposition — 2026-10-07

Owner: Project Owner — Kerolles Sobhy. Source: explicit scope rebaseline instruction; see [G_ENTRY_SCOPE_DECISION_2026-10-07.md](G_ENTRY_SCOPE_DECISION_2026-10-07.md).

**G-ENTRY = PASS — CURRENT IMPLEMENTATION SCOPE. Active owner-action blockers: none.** Future task-specific commercial/configuration inputs remain in the owner decision record; this does not invent their values or grant deployment/implementation permission.

| Action | Current status | Reason / boundary |
|---|---|---|
| OA-01 | **CLOSED** | Business decisions recorded. Explicit inputs remain required before dependent implementation/production acceptance; not global current entry blockers. |
| OA-02 | **DEFERRED — OUTSIDE CURRENT G-ENTRY**; **OUT OF CURRENT LAUNCH SCOPE / LEGACY** | Supabase excluded from current commerce launch. No access/ACL evidence request or remediation work; legacy code unchanged, technical removal not claimed. |
| OA-03 | **DEFERRED — OUTSIDE CURRENT G-ENTRY**; **DEFERRED / OUT OF CURRENT EXECUTION GATE** | Owner excludes historical credential work. No evidence/credential request, investigation or authentication probe; no technical closure claim. |
| OA-04 | **DEFERRED — OUTSIDE CURRENT G-ENTRY**; **DEFERRED TO PRODUCTION DATABASE PREPARATION / FINAL CUTOVER** | Temporary development Mongo does not block current entry. Final production transaction/topology and database certification required later, separately authorized. No provisioning/reset/migration now. |

## Archived owner actions — superseded scope

The original action list below is retained verbatim for history. Its BLOCKED labels and requests are **inactive**, not current owner actions. Do not request Supabase access, historical credential evidence or current Mongo provisioning from this archived list. Only explicit future scope authorization can reopen excluded work. D01 remains unchanged. No P1 begins here.

# G-ENTRY — Owner Actions

2026-10-07. Four unresolved action groups only. Do not resend D01, Google deferral, local-wishlist MVP or core authority decisions. No secrets requested; no infrastructure or credential mutation authorized by this list.

## OA-01 — Launch decisions recorded; explicit inputs remain

- **Blocker:** Policy directions recorded; required commercial/legal/configuration values remain OPEN. This is not unconditional OA-01 or G-ENTRY clearance.
- **Why required:** Implementation and launch must use actual approved inputs rather than inferred defaults.
- **Evidence received:** Project Owner — Kerolles Sobhy, 2026-10-07, supplied the OA-01 closure instruction. [OWNER_DECISIONS_2026-10-07.md](OWNER_DECISIONS_2026-10-07.md) is the current D01–D30 record, including the changed D03/D04 subjects and D05 fee/threshold grouping. Historical wording remains in earlier reports.
- **Exact evidence still needed:** Only the Remaining Inputs table in that record: approved returns/legal/tax policy; actual Egypt zones/rates and free-shipping decision; manual carrier operations; payment receiving/verification assignments and WhatsApp destination; email/media configuration; RPO/RTO/retention; hosting/domains/capacity; owner-approved stock/catalogue; applicable retention and notification details. D26 implementation detail remains P3. Do not request optional-feature specifications/accounts for explicitly deferred domains.
- **Where to obtain it:** Project owner coordinates business inputs and relevant legal/operations/infrastructure/account holders. No provider ownership is invented by naming the project decision owner.
- **What NOT to provide:** Secrets, customer PII, fabricated defaults or repeated approval of locked payment/Google/local-wishlist/core-authority choices.
- **Expected closure condition:** Business direction is recorded for all 30 decisions; outstanding inputs must be supplied before dependent implementation/production acceptance. No P1 execution is authorized. OA-02/OA-03/OA-04 remain separate, unchanged blockers.
- **Status:** **CLOSED WITH EXPLICIT OPEN INPUTS** — business-decision recording complete; remaining values unresolved. See [OA01_COMPLETION_REPORT.md](OA01_COMPLETION_REPORT.md).

## OA-02 — Supply live Supabase authority evidence

- **Blocker:** BLOCKED — F31/P0.2 live privileges/write authority unknown.
- **Why required:** Historical SQL extraction does not establish current RPC safety or exclusive authority.
- **Exact evidence needed:** Current timestamped, project-scoped read-only catalog export: roles/membership, function owners/bodies/SECURITY DEFINER/search_path, effective EXECUTE for PUBLIC/anon/authenticated/service_role and inherited/default grants, schema/table/sequence rights, RLS policies/bypass, API-exposed schemas and residual write paths. Include create_order_v1, create_order_v2, update_order_status_v2 and adjust_stock_v2. An owner-run export is sufficient; alternatively enable an authorized read-only connector through secure configuration. Existing P0 report has a starter catalog query; expand export coverage to schema/sequence/default grants and API settings, without invoking business functions.
- **Where to obtain it:** Supabase project owner using dashboard SQL/catalog tools and API settings; use a read-only transaction and ROLLBACK.
- **What NOT to provide:** Passwords, service-role keys, connection strings with credentials, table rows/PII; do not call RPCs or modify grants/functions/RLS.
- **Expected closure condition:** Evidence establishes actual effective rights and remaining writers with no unresolved critical ambiguity. Unsafe live privileges require separately authorized remediation and subsequent verification, not an evidence-only PASS.
- **Status:** OWNER ACTION REQUIRED — PROVIDE AUTHORIZED READ-ONLY SUPABASE ACCESS OR EXPORT.

## OA-03 — Supply attributable historical credential closure

- **Blocker:** BLOCKED — F37/P0.3 revocation proof missing.
- **Why required:** SECURITY.md's September 9 owner-rotation statement is documentary evidence; no attributable receipt has been provided.
- **Exact evidence needed:** Provider event/inactive-key metadata OR attributable owner-controlled attestation confirming the old agentrouter.org credential identified by the incident in SECURITY.md (historical blob 826d18a43510ceeeb6865809869b3021423ad3e2) no longer authorizes access, with account scope, date and safe provider identifier/fingerprint if available. A Git blob hash is not a credential fingerprint. Also reconcile older documented Supabase PAT/database-password/service-role exposure concerns in docs/PHASE-0.5-REPORT.md: identify applicability and supply closure evidence for affected historical credentials. Do not assume every current credential needs rotation.
- **Where to obtain it:** Relevant credential/account owner or provider credential/audit console; owner can explicitly attest to the existing rotation record.
- **What NOT to provide:** Old/new key values, secrets, authentication probes or scanner output as revocation proof. A historical HTTP 401 alone is insufficient. No rotation requested without separate authorization if evidence identifies an active exposed key.
- **Expected closure condition:** Attributable provider/owner evidence links each applicable historical incident to invalidation of its old credential; remaining incident uncertainty explicitly resolved.
- **Status:** OWNER ACTION REQUIRED — PROVIDE PROVIDER-SIDE OR OWNER-CONTROLLED REVOCATION/ROTATION EVIDENCE.

## OA-04 — Enable a dedicated disposable Mongo validation environment

- **Blocker:** BLOCKED — real replica-set transaction evidence absent.
- **Why required:** Passing ownership mocks do not demonstrate application commit/rollback against Mongo.
- **Exact evidence needed:** Enable local Docker engine (currently unavailable) and approve/create a fresh dedicated loopback-only disposable instance using the recipe in the unblock report, or supply equivalent existing run-owned local infrastructure with ownership evidence. Provide non-secret container identity/creation time/image digest and explicit disposable designation. Then authorize the existing isolated transaction gate and retain topology, primary, commit/rollback, cleanup and exit results.
- **Where to obtain it:** Local workstation/infrastructure owner. No production/shared environment permitted.
- **What NOT to provide:** Production/development URI, credentials, a reused ownership marker, shared volume or permission to drop/reset any existing DB.
- **Expected closure condition:** Dedicated nest-test-* replica set, primary elected, actual application transaction suite and guarded teardown pass; no foreign resources touched. Container existence or hello alone does not close this action.
- **Status:** BLOCKED — OWNER ACTION REQUIRED; no environment provisioned this pass.
