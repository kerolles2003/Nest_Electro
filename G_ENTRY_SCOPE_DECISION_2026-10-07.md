# Nest Electro — G-ENTRY Scope Decision, 2026-10-07

## Decision

**Owner:** Project Owner — Kerolles Sobhy. **Decision date:** 2026-10-07. **Evidence:** explicit G-ENTRY Scope Rebaseline instruction in this conversation (OWNER CONFIRMED).

The project owner intentionally narrows the current G-ENTRY scope to development implementation entry. This decision supersedes conflicting G-ENTRY/launch-dependency requirements in the master plan and previous P0/OA reports. Historical findings remain evidence of their recorded state; scope exclusion is not technical remediation or proof of safety.

## Excluded

1. **Supabase — OUT OF CURRENT LAUNCH SCOPE / LEGACY.** Not a required commerce authority, launch dependency or G-ENTRY blocker. OA-02: **DEFERRED — OUTSIDE CURRENT G-ENTRY**. Existing legacy code may remain untouched; technical removal is not claimed. No ACL investigation, access request, remediation task, code removal, Supabase modification or migration is authorized or required by the current launch scope.
2. **Historical credential rotation/revocation evidence — DEFERRED / OUT OF CURRENT EXECUTION GATE.** OA-03: **DEFERRED — OUTSIDE CURRENT G-ENTRY**. No evidence/credential request, investigation, authentication probe or credential mutation. No new assertion about old credential validity or provider-side action is made.
3. **Temporary Mongo replica-set validation — DEFERRED TO PRODUCTION DATABASE PREPARATION / FINAL CUTOVER.** OA-04: **DEFERRED — OUTSIDE CURRENT G-ENTRY**. Current Mongo is a **TEMPORARY DEVELOPMENT ENVIRONMENT** by owner designation, not a certified production database. No provisioning, rebuild, reset/drop, migration or production setup now.

These are deliberate owner scope dispositions. F31/P0.2/E02 and Supabase-specific branches are retained as historical/out-of-scope material, not active launch requirements. F37/P0.3 remains a deferred topic, not a current execution prerequisite. No Supabase remediation work is created. Reopening excluded work requires separate explicit scope authorization.

## Deferred

- Final production database setup and associated production infrastructure work.
- Production transaction capability, replica-set/topology validation, required indexes, backup/recovery, data integrity, connection/security configuration and production-like database certification.
- Final production migration/cutover: **DEFERRED**, after functional completion and a separate authorized planning/rehearsal/execution process. No date, provisioning action or migration execution is approved here.

Final production database validation remains mandatory before production cutover. Existing application correctness work (including transaction semantics, index/readiness logic and ledger correctness) remains in its future implementation tasks; this does not defer those code defects wholesale. Production-target setup/certification is distinct from application development and isolated regressions.

## Current Gate

**G-ENTRY = PASS — CURRENT IMPLEMENTATION SCOPE**

| Current criterion | Evidence / disposition |
|---|---|
| P0 execution | Recorded in P0_COMPLETION_REPORT.md: decision record and safeguards delivered. P0.2/P0.3 and real runtime evidence were not technically completed; their current entry prerequisites are explicitly removed by this owner decision. |
| OA-01 | CLOSED for business-decision recording; all 30 directions/statuses documented. Explicit inputs remain required before their dependent tasks/production acceptance. |
| Test ownership safeguards | Recorded 2026-10-07 G-ENTRY pass: 2 suites, 50 tests, exit 0. Source/configuration unchanged since that recorded pass; no fresh test run claimed in this documentation-only pass. |
| Launch decisions | OWNER_DECISIONS_2026-10-07.md plus this scope override; D01 remains unchanged. |
| Scope compliance | Documentation only; no unauthorized implementation, provider/infrastructure operation or database migration. |
| Future dependencies | Production database/provider/content/operational inputs remain explicitly future or task-specific; no invented defaults. |

**Remaining active G-ENTRY blockers: none under this definition.** OA-01's missing values do not become global entry blockers; a later task must still use approved inputs when it actually depends on them.

PASS here does not mean production readiness, production DB readiness, completed migration, configured providers, passed future production gates or deployment authorization. It also does not authorize starting P1 in this run. The next implementation step requires separate authorization.

## Preserved boundaries

D01 is unchanged: COD approved without manual payment verification; Wallet/InstaPay manual transfer approved with mandatory authorized admin verification, audit trail and WhatsApp evidence-only submission. Only authorized server-side approval may make a manual transfer PAID; no premature financial recognition. No online payment gateway introduced. Nest/Mongo remains active commerce authority; local/browser wishlist remains and Google/Flutter stay deferred.

Existing test ownership and cleanup guards remain mandatory. Deferring environment certification does not permit a test to bypass a guard, treat shared/temporary data as disposable, or claim transaction assertions passed without execution. Future test evidence must state any environment-dependent test not run; that is a task-level verification limit, not reinstatement of OA-04 as a global current G-ENTRY blocker.

No application, schema, data, provider, credential, dependency, infrastructure, DNS, commit or push change is authorized by this decision.
