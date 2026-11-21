# P1 Closure Review

Date: **2026-10-08**, Africa/Cairo. Scope: review only, against the current working tree at HEAD `de8a353808c74b3885c2700ab89d756176dcecc7`, branch `phase-1-2-overnight`.

## Executive Verdict

**P1 NOT CLOSED.**

The missing run-owned Mongo URI is **not** the reason for this verdict. P1.2, P1.3 and P1.5 have structurally complete application protocols with meaningful model tests; their database/runtime certification is deferred. Two concrete behavioral gaps remain: a catalogue image writer bypasses arrangement versioning, and losing taxonomy deletion operations can emit successful audit records. The master plan's explicit P1.1 CSP requirement also has no implementation or recorded scope deferral.

Fresh review checks pass: **56 P1/audit tests, 50 P0 tests, seven Chromium helper cases, and three application typechecks**. Two additional read-only, in-memory probes of actual classes reproduce the importer and audit gaps. No application or test code was changed to obtain these results.

G-ENTRY remains **PASS — CURRENT IMPLEMENTATION SCOPE**. This review neither reopens OA-02/03/04 nor authorizes any subsequent phase. It does not certify production readiness.

### Sources and evidence standard

The six requested documents were read completely: `MASTER_IMPLEMENTATION_PLAN.md`, `AUDIT.md`, `P0_COMPLETION_REPORT.md`, `G_ENTRY_SCOPE_REBASELINE_REPORT.md`, `OWNER_DECISIONS_2026-10-07.md`, and `P1_COMPLETION_REPORT.md`. Current owner scope overrides take precedence over archived BLOCKED statements. Actual affected services, callers, schemas, test fixtures and rendering sinks were inspected rather than accepting the report's classifications.

- **[C]** Current source inspection; repository-relative paths and line references below.
- **[T]** Executed during this review, with the limits stated.
- **[D]** Prior recorded result, not freshly executed here.
- **[A]** Evidence not yet available; no production behavior inferred.

## Task Matrix

| Task | Classification | Evidence | Runtime Dependency | Remaining Work |
| --- | --- | --- | --- | --- |
| P1.1 | **C — PARTIALLY COMPLETE** | [C/T] All four JSON-LD sinks use safe serialization; blog HTML uses allow-list reconstruction; seven Chromium cases pass. Explicit plan CSP deliverable absent (CR-03). | No Mongo needed for sink safety; final route/build/header checks remain. | Separately authorized CSP completion or explicit owner scope amendment; preserve the implemented sink protections. |
| P1.2 | **B — CODE COMPLETE — RUNTIME CERTIFICATION DEFERRED** | [C/T] Shared active-owner write guard, fresh actor/count checks and mutation/audit in one session; seven model tests. | Real Mongo write conflicts/retries, persistence and rollback. | P10 certification, including exactly-two-owner mixed removals and restart/failure cases. |
| P1.3 | **B — CODE COMPLETE — RUNTIME CERTIFICATION DEFERRED** | [C/T] Zero-reference claim, retain exclusion, permanent tombstone, provider call after commit, transactional completion; fake-provider failure/replay tests. | Real Mongo plus later isolated provider certification; unique media identity prerequisite P2.1. | Certify both race winners, shared references, crash/retry and provider idempotence. No destructive provider action now. |
| P1.4 | **C — PARTIALLY COMPLETE** | [C/T] Admin/API attach/detach/reorder use CAS and increment versions. Actual ImportRunner bypass reproduced (CR-01). | The demonstrated gap does not require Mongo to identify; final conflict certification does. | Bring the retained catalogue image writer into the same protocol under separate authorization; add regression covering importer/admin overlap. |
| P1.5 | **B — CODE COMPLETE — RUNTIME CERTIFICATION DEFERRED** | [C/T] Hard-delete/order check/refcount release/redirect removal/audit share a transaction; checkout writes the same product; historical order DTO reads snapshots. Seven model tests. | Real checkout/delete contention, commit rollback, combined cleanup and historical readback. | P10 certification. Model checkout is a stock-write surrogate, not the full CheckoutService. |
| P1.6 | **C — PARTIALLY COMPLETE** | [C/T] Critical writes couple audit to domain session; durable catalogue intents and redaction exist. Taxonomy zero-match paths still record success (CR-02). | False-success defect is locally reproducible; actual audit persistence/crash behavior needs Mongo later. | Correct narrow outcome attribution under separately authorized P1 follow-up; certify real durability later. |

No task is classified D solely because the test URI is absent. B does not certify an arbitrary temporary/standalone database as safe for transaction-dependent operations.

### P1.1 — Rendering safety

[C] `apps/storefront/src/lib/safe-content.ts:2–42` escapes every `<` in JSON serialization and reconstructs HTML through an inert template into new elements. Its allow-list retains formatting and HTTP(S) anchors, excludes scripts/embeds/SVG/MathML, and drops event/style attributes. `components/blog/BlogContent.tsx:11` applies this helper before assigning live `innerHTML`. Initial server/client render is empty.

[C] Product detail `app/products/[slug]/page.tsx:239–240` and blog detail `app/blog/[slug]/page.tsx:96–97` cover the four script sinks. Blog content reaches the protected component at `:155`; product description remains React text at `:452`. Product/name/category/brand/breadcrumb/URL/image values in structured data pass through the same serializer. Metadata remains structured Next metadata, not manually concatenated script source. The source search across storefront/admin/packages found no alternate active raw HTML sink bypassing these helpers.

[T] The existing browser script passes all seven cases again. It exercises the actual helper inside Chromium, not a served Next page, hydration journey or production CSP. Script elements inserted with `innerHTML` alone are not proof of executable script behavior; the useful assertions additionally inspect the resulting DOM, reject dangerous attributes/URLs, require exactly one JSON-LD script and verify JSON round-trip. Malformed-markup/final route coverage is not comprehensive.

**Remaining concern:** CR-03 is a missing, explicitly planned defense, not evidence that the fixed stored-content payload still executes. Blog formatting is intentionally narrower and client-rendered; blog remains deferred. No Supabase access is needed or requested.

### P1.2 — SUPER_ADMIN fencing

[C] `customers-admin.service.ts:217–369` starts both role change and soft deletion with a session-bound `updateMany` increment on all active SUPER_ADMIN documents. Actor, target and remaining-owner checks occur inside that transaction. The subsequent write and audit insert use the same session. This shared write set addresses write skew; it is not merely a count followed by an unrelated mutation. Current self-change restrictions remain, and ordinary admins are refused at the service boundary. Soft deletion is the existing deactivation mechanism; no additional application hard-delete/bulk disable writer was found in the users/auth paths inspected. Staff provisioning adds identities rather than removing owners.

[C] `database/transaction.service.ts:70–79` uses the existing driver's `withTransaction`, snapshot reads, majority/journal writes and session cleanup; there is no standalone fallback. The protocol preserves an initially valid owner set; it does not bootstrap a database with zero owners.

[T] The seven fixture tests assert service refusal, guard/session wiring, successful permitted demotion, mutual demotion/deactivation and rollback on audit failure. The three only-owner cases hit self-change refusal; they do not independently exercise every count branch. The real HTTP test at `test/users/admin-customers.spec.ts:499` adds two fixture owners while another owner exists, so its asserted pair survival is not a complete exactly-two-total-owner experiment. Those limits require stronger certification, not a new infrastructure task or an identified application-code defect.

### P1.3 — Media fencing

[C] `media-asset.repository.ts:87–140` puts retain and zero-reference deletion claim on the same authoritative ledger identity. `MediaService.destroy` at `media.service.ts:253–285` commits claim plus requested audit before invoking storage, retains the fence on failure, and finalizes tombstone plus success audit in another transaction. Repeated requests cannot reattach a tombstone; only one conditional finalization records completion. Remote calls are outside transaction callbacks. A retry may repeat an idempotent provider destroy; exactly-once network delivery is not claimed.

[C] ProductImageService commits descriptor changes and ledger retain/release together. Product hard deletion releases references without deleting bytes. Failed image import compensation now retains bytes for explicit cleanup. There is no automatic cleanup of unknown media in the inspected flow. Provider storage remains behind its existing port; tests use a fake destroy function.

**Prerequisite, not a new P1 implementation claim:** `mediaAssets.publicId` uniqueness and accurate initial references. The schema declares `media_asset_public_id_unique`; the historical audit found it missing on its inspected development database. `record()` upsert excludes deleting rows and therefore relies on this unique index to prevent another row for a tombstoned identity. No current database index state was queried. This is the existing **P2.1/F02** handoff, and precludes claiming present production safety.

### P1.4 — Arrangement versioning

[C] `product-image.service.ts:299–414` validates expectedVersion, checks the exact image set and primary selection, then writes with an imageVersion predicate and increments it. Attach and detach also use the shared CAS write. Missing legacy version is interpreted as zero without a backfill. The DTO requires a nonnegative integer; `admin-products.controller.ts:563`, admin Server Action, API client and ProductImageManager forward the displayed version. Stale operations produce the existing conflict response rather than silently retrying old intent.

[C/T] That proof applies to the API service, not every writer. The retained `catalogue:import --images` path writes the entire images array without that predicate/increment (CR-01). Its CLI is a supplier catalogue tool, explicitly retained after launch in `catalogue-import.ts:15–44`; it is not the separately deferred final database migration. No import was run.

### P1.5 — Product/checkout/media integrity

[C] `product-admin.service.ts:756–784` checks order references and deletes the product within the same transaction, releases media references once, removes redirects with the session and writes audit. Its result explicitly retains bytes. A retry after committed deletion fails the product lookup and cannot decrement references twice. Soft deletion/restore at `:586–680` also couple mutation and audit.

[C] Checkout's `commit()` obtains cart/product state in its session and performs InventoryService.commitSale before inserting the snapshot order and clearing cart. `inventory.repository.ts:56–79` requires active, undeleted, sufficient-stock products in the same conditional write. A deletion and sale contend on that product; if the sale commits first, a retried delete must see its order reference. If deletion commits first, sale cannot decrement the missing product. Archive/unpublish likewise cannot bypass the sale predicate.

[C] CartService propagates the transaction session and represents missing/inactive products as unavailable. `checkout.service.ts:559` embeds name/SKU/price/quantity; `order.repository.ts:169` reads the owned order directly, and `order-response.dto.ts:272` projects its stored item values. Historical financial detail does not depend on joining a current product.

The model tests do not place a real order: their checkout surrogate calls the real InventoryRepository with a fake model and increments an in-memory order count. Their historical fixture is a separate unchanged object, so that assertion alone proves no persisted readback. Source tracing supplies the structural evidence; live checkout/delete, cancellation/return, combined product cleanup and restart/readback remain certification work. Post-commit taxonomy recount failure remains **P5.1/F23**, distinct from the atomic destructive boundary. CR-01's separate importer gap does not negate the inspected hard-delete transaction, but must not be ignored when certifying all writers together.

### P1.6 — Durable attributable audit

[C] `audit.service.ts:46–105` persists into the existing Mongo AuditLog model. Critical callers pass their business session and insertion errors propagate, so those operations cannot commit without their audit. The schema provides createdAt, actor snapshot, action/entity, requestId and forensic context. User changes, product/image deletion/restoration, inventory adjustment, shipping fee updates and staff order transitions have this coupling. Customer cancellation retains its existing embedded history policy; payment verification/refund features remain later P6/P7 work and are not represented as implemented.

[C] Multi-step catalogue writers persist required `ADMIN_MUTATION_REQUESTED` evidence before domain writes. Their requested-only records mean unknown/not completed, not success. This meets the plan's permitted durable-intent alternative for missing post-write evidence; it does not make taxonomy propagation transactional. Redaction handles named credential fields, dotted paths and nested arrays; actor/entity fields are explicitly selected. This is a field-based policy, not arbitrary secret detection in user prose. Order notes are not duplicated into audit metadata.

[T] Tests prove audit argument/session wiring, selected redaction cases, intent-storage failure preventing a write, and modeled rollback. **CR-02 remains:** brand/category soft-delete losers can produce success events even when their conditional write changes nothing. Passing critical transaction tests cannot certify all catalogue audit outcomes.

## Test Evidence

### Fresh execution in this review

Commands ran on 2026-10-08, approximately 01:32–01:35 Africa/Cairo, with existing installed dependencies. No default integration setup or application server was started.

| Working directory | Exact command | Result | What it proves |
| --- | --- | --- | --- |
| `apps/api` | `node node_modules/jest/bin/jest.js --config jest.p1.config.js --runInBand --no-cache` | Exit 0; 7 suites, 56 tests | 44 P1 model/DTO/unit tests plus 12 existing audit-diff tests. No real Mongo. |
| `apps/api` | `node node_modules/jest/bin/jest.js --config jest.p0.config.js --runInBand --no-cache` | Exit 0; 2 suites, 50 tests | Ownership/provider-isolation checks with fakes/local processes; not live database ownership/transaction proof. |
| Each of `apps/api`, `apps/admin`, `apps/storefront` | `node node_modules/typescript/bin/tsc --noEmit --incremental false` | All exit 0 | Static compilation for the current application projects; not behavior or all integration-test roots. |
| `apps/storefront` | `node scripts/test-content-safety.cjs` | Exit 0; 7 cases | Actual helper in Chromium; all requests aborted. No Next server, provider or real stored records. |
| `apps/api` | Inline TypeScript-transpilation probes reproduced below, piped to `node -` | Both exit 0; defects reproduced | Actual ImportRunner/BrandAdminService methods with explicitly supplied in-memory collaborators. No Mongo connection, imports executed, or provider SDK calls. |

### Suite-by-suite interpretation

| Test source | Count / type | Meaningful assertions / limits |
| --- | --- | --- |
| `test/p1/users-invariant.spec.ts` | 7; service/model, concurrent callers | Guard/session checks, fresh authority, refusal and rollback. Fixture serializes entire transactions. |
| `test/p1/media-images.spec.ts` | 14; service/repository model, concurrent callers/fake provider | Both attach/delete orderings; remove/cleanup; replacement; repeated cleanup; intent/finalization/provider failures; version conflicts. No Mongo conflict implementation. |
| `test/p1/image-contract.spec.ts` | 6; DTO/unit contract | Five invalid version forms and valid zero. Not HTTP/OpenAPI drift certification. |
| `test/p1/product-deletion.spec.ts` | 7; service/model | Conditional stock surrogate, two serialized winner orders, reference release once, audit rollback, archive/restore. No actual cart/customer checkout/history endpoint. |
| `test/p1/durable-audit.spec.ts` | 7; unit/service | Required intent, session and attribution, selected redaction and no-op behavior. Mock create is not durable storage. |
| `test/p1/order-audit.spec.ts` | 3; service/model, concurrent callers | Status/history rollback and one successful modeled duplicate transition. |
| `test/audit/audit-diff.spec.ts` | 12; pure unit | Diff/redaction behavior, not mutation durability. |
| `scripts/test-content-safety.cjs` | 7; browser helper | Representative malicious/safe markup and JSON script breaking/round-trip. Not full browser E2E. |

**Concurrency distinction:** The P1 fixtures submit simultaneous promises, but `tail.then(...)` serializes complete callbacks and restores JavaScript snapshots on failure. They test serial outcomes and protocol wiring, with external fake effects allowed between transactions. They cannot detect Mongo write skew, driver retry behavior, ambiguous commit or crash durability. No live database race is claimed here.

The actual HTTP tests in `test/users/admin-customers.spec.ts:499`, `test/catalog/product-images.spec.ts:644,658,875`, plus media/audit/delete/import integration suites, use application boot and the P0-owned database. They were inspected but not executed in this review. Their Promise.all requests are genuine concurrent requests when run, but lack deterministic barriers at every contested DB boundary. The existing historical-order/delete suite is useful coverage; no present persisted-order result is inferred from it.

[D] The prior report records a successful API build, changed-test-root compilation, lint and scoped Swagger/page checks. This review did not rebuild, regenerate OpenAPI, install packages or claim a fresh full AppModule contract export. Application typechecks were freshly repeated; prior build evidence remains dated.

## Mongo Boundary

The current process has no `NEST_TEST_MONGODB_URI` (presence-only check, no environment values disclosed). The prior integration command was:

```text
node node_modules/jest/bin/jest.js --runInBand test/catalog/product-images.spec.ts test/users/admin-customers.spec.ts test/media/media-upload.spec.ts test/audit/admin-order-audit.spec.ts
```

[D/C] Its recorded exit 1 occurred before database access. `test/setup/prepare-scratch-database.ts` calls newScratchRun before ensureCleanScratchDatabase. `src/database/testing/scratch-run.ts:16–62` rejects the missing URI before configuration installation or connection. The ordinary Jest configuration registers that setup for all suites; the P1/P0 configurations explicitly remove database setup/teardown. This is why the focused suites can pass while HTTP integration does not run.

The ownership protocol requires explicit loopback, credential-free dedicated `nest-test-*` replica topology, fresh random run/capability and exclusive ownership verification before fixture writes. A database name or stale marker is insufficient. No fallback to application MONGODB_URI or existing developer data is permitted. This review neither invokes the database setup nor provisions its prerequisite.

Already evaluable without Mongo: source/session/CAS wiring, input validation, sanitizer output, source-to-sink coverage, selected redaction, deterministic modeled failures and both newly reproduced code defects.

Not certified without actual Mongo: snapshot conflict detection, withTransaction retry/ambiguous commit, cross-collection atomic rollback, unique indexes in effect, real ownership claims, durable audit persistence/restart, full checkout/delete behavior and API persistence/readback. Those are **P10 / PRODUCTION CERTIFICATION**, with final production topology/index/security/backup validation later under separate authorization. No code fallback is authorized for a temporary database lacking transactions.

The missing URI is an environment limitation for B-classified tasks. It does not explain CR-01/02/03 and cannot fix them. No credentials, topology changes or infrastructure task are requested here.

## Defects Found

### CR-01 — Retained catalogue image writer bypasses the version protocol

- **Task:** P1.4; F09/shared media interaction.
- **Severity:** MEDIUM — silent image overwrite and reference-count drift; no live destructive exploit claimed.
- **Files:** `apps/api/src/database/import/import-runner.ts:334–345,403–431`; `image-importer.ts:100–106`; `catalogue-import.ts:15–44,192–211`; `apps/api/package.json` catalogue:import script.
- **Evidence [C/T]:** Image import decides whether to skip from an earlier images snapshot, performs uploads, then calls `updateOne({_id}, {$set:{images}}, {session})`. It does not reread the current arrangement, match imageVersion, increment it, or check matchedCount before retaining assets. The API's CAS cannot protect against this independent writer.
- **Reproduction:** Import begins from empty images; while its fake upload awaits, an admin arrangement becomes `[admin-image]`, version 1. Resume actual ImportRunner with `[import-image]`. Result: images overwritten to `[import-image]`, version still 1, imported image retained. An already-retained admin image is not released by that path. This is a model reproduction of the actual importer method, not an executed import or Mongo race.
- **Why it matters:** “Every image mutation increments the version” in the historical P1 report is too broad. Transaction use alone cannot revalidate a snapshot loaded before its callback starts. The CLI is an ordinary retained catalogue writer, not automatically excluded by final-migration deferral.
- **Recommended future task:** Separately authorized **P1.4 follow-up** to use the shared conditional arrangement/reference protocol (including matched-result validation) and regress import versus attach/reorder/delete. Broader bulk-catalogue propagation remains P5.1. Do not run an import or migrate data to fix this review.

### CR-02 — Losing brand/category deletion can falsely audit success

- **Task:** P1.6; F27 outcome attribution.
- **Severity:** MEDIUM — misleading attributable security history and success response.
- **Files:** `apps/api/src/modules/catalog/application/brand-admin.service.ts:223–260`; `category-admin.service.ts:283–330`.
- **Evidence [C/T]:** Both read an undeleted snapshot, conditionally update with `deletedAt:null`, then use `?? current` if the write returns null. They still emit a deleted action with `outcome:'succeeded'` via unconditional `audit.record`.
- **Reproduction:** Two operators can read undeleted state; the first deletes; the second update matches zero. The actual BrandAdminService, supplied that zero-match result, returns deletedAt null and emits `BRAND_DELETED`, succeeded, before.deletedAt null, after.deletedAt null. The category source has the same branch. No actual customer or taxonomy data was used.
- **Why it matters:** A durable requested intent is legitimate evidence of an attempt. A separate successful deletion attributed to a loser that performed no deletion is not. Critical transactional audit tests do not cover this caller branch.
- **Recommended future task:** Separately authorized **P1.6 follow-up** to distinguish zero-match/conflict from success and test concurrent taxonomy deletion outcome attribution. Preserve durable intent; do not require a wholesale P5.1 taxonomy rewrite for this narrow correction. Full taxonomy consistency remains P5.1, not P2.

### CR-03 — Explicit P1.1 CSP deliverable absent

- **Task:** P1.1; defense-in-depth portion of F05.
- **Severity:** LOW — unmet planned defense, not a demonstrated sanitizer bypass.
- **Evidence [C]:** `MASTER_IMPLEMENTATION_PLAN.md:224` explicitly says “Add a compatible CSP as defense in depth, not a substitute.” Searches for Content-Security-Policy/contentSecurityPolicy/CSP in the frontends found no implementation; storefront `next.config.ts` and `src/proxy.ts` do not supply one. No governing owner record explicitly defers this particular deliverable. An unseen future ingress policy cannot be assumed.
- **Why it matters:** The stored HTML/JSON-LD fix is supported, but the entire canonical task cannot be described as implemented solely from its passing helper tests.
- **Recommended future task:** Separately authorized **P1.1 follow-up**, or explicit owner-approved scope reassignment, followed by browser/header and production-build compatibility verification. No configuration changed in this review.

No additional live vulnerability, missing index result, historical credential result, or Supabase issue is invented. P2's known constraints remain prerequisites, not newly discovered current database facts.

## Deferred Certification

After the implementation gaps are addressed under separate authorization, certify the following on safe run-owned production-like resources; do not provision them in this review:

1. **P1.2 / P10.1:** exactly-two-owner demote/delete/mixed races, fresh authorization after retry, fault/commit rollback and durable actor evidence. Include controlled interleavings, not only concurrent request launch.
2. **P1.3 / P10.1, P10.3:** attach/delete both winners, shared images, remove/replacement/product-delete cleanup, provider timeout, success-before-finalization failure, repeated cleanup and process restart. Install/verify required unique identity constraints through later approved P2 work before testing reliance on them.
3. **P1.4 / P10.1–2:** same-version HTTP winner/loser, attach/detach/replacement/import interactions, exact reference counts, version increments, primary uniqueness and stale admin-screen feedback.
4. **P1.5 / P10.1:** real CheckoutService/order insertion against hard delete/archive, rollback injection, repeated deletion, cancellation/return after archive and customer/admin historical detail readback. The existing unit snapshot fixture is not sufficient.
5. **P1.6 / P10.1:** Mongo audit/domain atomic commit and rollback, actual restart durability, repeat/replay operation attribution, taxonomy loser outcomes after correction, and requested-only versus completed intent interpretation. Provider failure remains distinguishable from successful physical deletion with pending DB finalization.
6. **P1.1 / P10.2, P10.4:** actual served product/blog rendering with synthetic hostile values, malformed markup, hydration, JSON parsing, safe formatting and the implemented CSP once separately completed/scoped. No residual Supabase access is implied.
7. Full HTTP integration, full generated OpenAPI equality and release artifact build/browser checks on the same candidate. Controlled real Cloudinary tests require their own future opt-in isolated account/resources. Mock passes are not provider certification.

Final production database preparation, topology/transactions/indexes, backup/recovery, security validation and any migration/cutover remain separately authorized future work. No credential or resource request is made here.

## P2 Handoff

Only the existing master-plan P2 tasks are handed off, without execution:

- **P2.1 / F02:** safe declared-index readiness, especially media publicId identity and existing order/inventory uniqueness prerequisites; no index creation now.
- **P2.2 / F04:** fail readiness closed on inspection error, not empty false-green results.
- **P2.3 / F03:** include stocked zero-ledger products and orphan event IDs in reconciliation.
- **P2.4 / F03:** approved development opening-balance provenance and isolated fixture consistency; no production backfill or final migration.

CR-01/02/03 remain P1 follow-up items, not disguised P2 tasks. Runtime certification remains P10 with P1 scenario ownership. Nothing in this review starts P2.

## Read-only defect probe commands

Both commands ran in `apps/api`. They transpile existing TypeScript into process memory and provide all persistence/provider collaborators as fakes. They write no source/test files and import no AppModule.

### CR-01 probe

```powershell
@'
const fs = require('node:fs');
const ts = require('typescript');
require.extensions['.ts'] = (module, filename) => module._compile(ts.transpileModule(fs.readFileSync(filename, 'utf8'), {compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022,experimentalDecorators:true,emitDecoratorMetadata:true}}).outputText, filename);
const { ImportRunner } = require('./src/database/import/import-runner.ts');
(async () => {
  let product = { images: [], imageVersion: 0 };
  let releaseUpload;
  const uploaded = new Promise(resolve => { releaseUpload = resolve; });
  const retained = [];
  const runner = new ImportRunner({products:{updateOne: (_filter, update) => ({exec:async () => {product.images=update.$set.images; return {matchedCount:1};}})}}, {importer:{importFor:async () => uploaded, retainAll:async ids => retained.push(...ids)},transactions:{run:async work => work({})}});
  const pending = runner.importImages('synthetic-product', [], {mapped:{imagePaths:['synthetic']},mappedFields:new Set(['imagePaths']),dryRun:false});
  product.images=[{publicId:'admin-image'}]; product.imageVersion=1;
  releaseUpload({images:[{publicId:'import-image'}],result:{uploaded:1,skipped:0,failures:[]}});
  await pending;
  console.log(JSON.stringify({probe:'actual ImportRunner with in-memory collaborators only',images:product.images,imageVersion:product.imageVersion,retained,overwroteNewerAdminArrangement:product.images[0].publicId==='import-image' && product.imageVersion===1}));
})();
'@ | node -
```

Output: `images=[import-image]`, `imageVersion=1`, `retained=[import-image]`, `overwroteNewerAdminArrangement=true`. Calling the compiled private helper here is a bounded white-box probe, not a claim of full CLI execution.

### CR-02 probe

```powershell
@'
const fs=require('node:fs'),ts=require('typescript');
require.extensions['.ts']=(m,f)=>m._compile(ts.transpileModule(fs.readFileSync(f,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022,experimentalDecorators:true,emitDecoratorMetadata:true}}).outputText,f);
const {Types}=require('mongoose');
const {BrandAdminService}=require('./src/modules/catalog/application/brand-admin.service.ts');
const {Role}=require('./src/modules/users/infrastructure/schemas/user.schema.ts');
const id=new Types.ObjectId(), actor={_id:new Types.ObjectId(),role:Role.SUPER_ADMIN,fullName:'Synthetic',email:'fixture@example.invalid'};
const current={_id:id,slug:'synthetic-brand',name:{en:'Synthetic'},deletedAt:null,isActive:true};
const query=value=>({lean:()=>query(value),exec:async()=>value});
const events=[];
const service=new BrandAdminService({findById:()=>query(current),findOneAndUpdate:()=>query(null)},{updateMany:()=>query({modifiedCount:0})},{findById:async()=>actor},{},{invalidateCache(){}},{recordIntent:async()=> 'synthetic-operation',record:async event=>events.push(event)});
(async()=>{const result=await service.softDelete(id,{actorId:actor._id,forensics:{ip:null,userAgent:null,requestId:'synthetic-review'}});console.log(JSON.stringify({probe:'actual BrandAdminService with zero-match conditional update',returnedDeletedAt:result.deletedAt,auditAction:events[0].action,outcome:events[0].metadata.outcome,auditChanges:events[0].changes}));})();
'@ | node -
```

Output: `returnedDeletedAt=null`, `auditAction=BRAND_DELETED`, `outcome=succeeded`, `auditChanges={before:{deletedAt:null},after:{deletedAt:null}}`.

## Review changes and safety

This review creates **P1_CLOSURE_REVIEW.md** and appends the dated closure section to **P1_COMPLETION_REPORT.md**. The prior completion report's execution history is preserved byte-for-byte before the append.

No application/test/configuration/dependency file was edited by this review. No Mongo connection, data mutation, index creation, infrastructure/provider call, credential operation, Supabase action, migration, deployment, staging, commit or push was performed. Chromium ran only the local existing helper regression, with network requests aborted. Unit probes changed only their local JavaScript objects.

The shared tree was already dirty at entry. Additional independent work appeared while this review ran, including `admin-dashboard-audit/` and frontend tsconfig changes; those are not this review's edits and were not reverted. Therefore a globally clean tree or globally unchanged configuration is **not** claimed. SHA-256 comparison against review entry distinguishes these paths from the two review documents. The final Git evidence below records the observed shared tree, not P1-only attribution.

## Final Git and integrity verification

Snapshot: 2026-10-08T01:41:20.624592+03:00. Branch: `phase-1-2-overnight`. HEAD: `de8a353808c74b3885c2700ab89d756176dcecc7` (unchanged). Nothing staged. `git status`, `git status --short`, `git diff --check`, `git diff --stat`, `git diff --cached --stat` and `git rev-parse HEAD` all exited 0. Global diff check emitted no whitespace errors; stderr included existing line-ending and inaccessible global-ignore warnings. Tracked diff stat: 105 files changed, 3125 insertions, 2910 deletions; this includes prior/shared work and excludes untracked files.

The original 43,077 bytes of P1_COMPLETION_REPORT.md retain SHA-256 `e16fea35ba96be7d3ec2d8f0912166a1f197b408ab66cae06df31017e708c3eb` after append. Compared with the entry manifest (847 files), existing file content changed only in that report and the independently changed `apps/admin/tsconfig.json`; additions are this review plus independent `admin-dashboard-audit/` artifacts. No entry file disappeared. Storefront tsconfig content matches entry despite Git line-ending warnings. Thus this review authored exactly two documentation changes; it does not claim the concurrently used worktree was otherwise static.

Exact `git status --short` output:

```text
 M apps/admin/e2e/global-teardown.ts
 M apps/admin/e2e/origin.ts
 M apps/admin/playwright.shared.ts
 M apps/admin/src/actions/product-image.actions.ts
 M apps/admin/src/app/(dashboard)/audit-log/page.tsx
 M apps/admin/src/app/(dashboard)/brands/page.tsx
 M apps/admin/src/app/(dashboard)/categories/page.tsx
 M apps/admin/src/app/(dashboard)/coupons/page.tsx
 M apps/admin/src/app/(dashboard)/customers/page.tsx
 M apps/admin/src/app/(dashboard)/inventory/page.tsx
 M apps/admin/src/app/(dashboard)/layout.tsx
 M apps/admin/src/app/(dashboard)/loading.tsx
 M apps/admin/src/app/(dashboard)/orders/[id]/page.tsx
 M apps/admin/src/app/(dashboard)/orders/loading.tsx
 M apps/admin/src/app/(dashboard)/orders/page.tsx
 M apps/admin/src/app/(dashboard)/page.tsx
 M apps/admin/src/app/(dashboard)/products/[id]/edit/page.tsx
 M apps/admin/src/app/(dashboard)/products/loading.tsx
 M apps/admin/src/app/(dashboard)/products/new/page.tsx
 M apps/admin/src/app/(dashboard)/products/page.tsx
 M apps/admin/src/app/(dashboard)/reviews/page.tsx
 M apps/admin/src/app/(dashboard)/settings/page.tsx
 M apps/admin/src/app/global-error.tsx
 M apps/admin/src/app/globals.css
 M apps/admin/src/app/layout.tsx
 M apps/admin/src/app/login/form.tsx
 M apps/admin/src/app/login/page.tsx
 M apps/admin/src/app/not-found.tsx
 M apps/admin/src/app/template.tsx
 M apps/admin/src/app/unauthorized/page.tsx
 M apps/admin/src/components/audit-log/AuditLogTable.tsx
 M apps/admin/src/components/brands/BrandsManager.tsx
 M apps/admin/src/components/categories/CategoriesManager.tsx
 M apps/admin/src/components/coupons/CouponsTable.tsx
 M apps/admin/src/components/customers/CustomersTable.tsx
 M apps/admin/src/components/inventory/InventoryAdjustDialog.tsx
 M apps/admin/src/components/inventory/InventoryHistoryDrawer.tsx
 M apps/admin/src/components/inventory/InventoryTable.tsx
 M apps/admin/src/components/layout/AdminHeader.tsx
 M apps/admin/src/components/layout/Sidebar.tsx
 M apps/admin/src/components/orders/OrderDetail.tsx
 M apps/admin/src/components/orders/OrdersTable.tsx
 M apps/admin/src/components/orders/QueueFilters.tsx
 M apps/admin/src/components/products/ProductForm.tsx
 M apps/admin/src/components/products/ProductImageManager.tsx
 M apps/admin/src/components/products/ProductSpecsEditor.tsx
 M apps/admin/src/components/products/ProductTable.tsx
 M apps/admin/src/components/reviews/ReviewsTable.tsx
 M apps/admin/src/components/settings/ShippingRatesTable.tsx
 M apps/admin/src/components/system/DomainNotLiveNotice.tsx
 M apps/admin/src/lib/api/endpoints.ts
 M apps/admin/src/lib/api/types.ts
 M apps/admin/tsconfig.json
 M apps/api/scripts/cloudinary-tests.js
 M apps/api/src/database/import/image-importer.ts
 M apps/api/src/database/testing/scratch-database.cli.ts
 M apps/api/src/database/testing/scratch-database.ts
 M apps/api/src/database/testing/scratch-databases.ts
 M apps/api/src/modules/audit/application/audit.service.ts
 M apps/api/src/modules/audit/domain/audit-action.ts
 M apps/api/src/modules/audit/domain/audit-diff.ts
 M apps/api/src/modules/catalog/application/brand-admin.service.ts
 M apps/api/src/modules/catalog/application/category-admin.service.ts
 M apps/api/src/modules/catalog/application/product-admin.service.ts
 M apps/api/src/modules/catalog/application/product-image.service.ts
 M apps/api/src/modules/catalog/application/slug-redirect.service.ts
 M apps/api/src/modules/catalog/infrastructure/schemas/product.schema.ts
 M apps/api/src/modules/catalog/presentation/admin-products.controller.ts
 M apps/api/src/modules/catalog/presentation/dto/admin-product-image.dto.ts
 M apps/api/src/modules/catalog/presentation/dto/admin-product-response.dto.ts
 M apps/api/src/modules/fulfilment/application/shipping-rates-admin.service.ts
 M apps/api/src/modules/inventory/application/inventory-admin.service.ts
 M apps/api/src/modules/media/application/media.service.ts
 M apps/api/src/modules/media/infrastructure/repositories/media-asset.repository.ts
 M apps/api/src/modules/media/infrastructure/schemas/media-asset.schema.ts
 M apps/api/src/modules/media/media.module.ts
 M apps/api/src/modules/media/presentation/dto/media-response.dto.ts
 M apps/api/src/modules/media/presentation/media.controller.ts
 M apps/api/src/modules/orders/application/order-lifecycle.service.ts
 M apps/api/src/modules/users/application/customers-admin.service.ts
 M apps/api/src/modules/users/infrastructure/schemas/user.schema.ts
 M apps/api/test/audit/admin-order-audit.spec.ts
 M apps/api/test/catalog/admin-product-create.spec.ts
 M apps/api/test/catalog/admin-product-delete.spec.ts
 M apps/api/test/catalog/admin-product-update.spec.ts
 M apps/api/test/catalog/admin-taxonomy.spec.ts
 M apps/api/test/catalog/product-images.spec.ts
 M apps/api/test/database/scratch-databases.spec.ts
 M apps/api/test/import/image-import.spec.ts
 M apps/api/test/infrastructure/index-health.spec.ts
 M apps/api/test/media/cloudinary-integration.spec.ts
 M apps/api/test/media/media-upload.spec.ts
 M apps/api/test/setup/email-isolation.spec.ts
 M apps/api/test/setup/email-isolation.ts
 M apps/api/test/setup/prepare-scratch-database.ts
 M apps/api/test/setup/scratch-database.ts
 M apps/api/test/users/admin-customers.spec.ts
 M apps/storefront/e2e/global-teardown.ts
 M apps/storefront/e2e/origin.ts
 M apps/storefront/playwright.config.ts
 M apps/storefront/src/app/blog/[slug]/page.tsx
 M apps/storefront/src/app/products/[slug]/page.tsx
 M apps/storefront/src/components/blog/BlogContent.tsx
 M docs/api/index.html
 M docs/api/openapi.v1.json
?? AUDIT.md
?? CODEBASE_MAP.md
?? G_ENTRY_OWNER_ACTIONS.md
?? G_ENTRY_SCOPE_DECISION_2026-10-07.md
?? G_ENTRY_SCOPE_REBASELINE_REPORT.md
?? G_ENTRY_UNBLOCK_REPORT.md
?? MASTER_IMPLEMENTATION_PLAN.md
?? OA01_COMPLETION_REPORT.md
?? OWNER_DECISIONS_2026-10-07.md
?? P0_COMPLETION_REPORT.md
?? P1_CLOSURE_REVIEW.md
?? P1_COMPLETION_REPORT.md
?? admin-dashboard-audit/
?? admin-redesign-exploration/
?? apps/admin/src/app/(dashboard)/error.tsx
?? apps/admin/src/components/ui/
?? apps/api/jest.p0.config.js
?? apps/api/jest.p1.config.js
?? apps/api/scripts/sync-p1-openapi.cjs
?? apps/api/src/database/testing/scratch-run.ts
?? apps/api/src/database/testing/test-providers.ts
?? apps/api/test/database/scratch-run.spec.ts
?? apps/api/test/p1/
?? apps/storefront/scripts/
?? apps/storefront/src/lib/safe-content.ts
?? docs/P0_DECISIONS.md
?? docs/admin-redesign/
```

