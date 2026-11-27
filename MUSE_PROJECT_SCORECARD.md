# Nest Electro — Project Scorecard

**HEAD:** `bb7c331` on `phase-1-2-overnight` · **Overall: 5.8 / 10** · **Production readiness: 2 / 10**

Scores are evidence-based at this HEAD, not effort-based. The codebase is unusually well engineered *where it works* — and it currently does not start. Both facts are in the scores.

| # | Category | Score | Justification (evidence) |
|---|---|---|---|
| 1 | Architecture | 7 | Clean monorepo (pnpm/Turborepo), Nest module boundaries with documented ownership, ports for email/media providers, no dual writers in the active path. Docked for legacy Supabase packages still wired into storefront blog and root deps. |
| 2 | Backend Engineering | 7 | Transactional checkout with idempotency, audit-intent/change pattern, typed config with placeholder-secret refusal, fail-fast DB config. Docked hard for a module graph that does not compile at runtime (A01) and the non-transactional product update (A05/A06). |
| 3 | Frontend Engineering | 6 | Server-component discipline, typed API client, fail-closed slug route design in admin. Docked for F01 renewal-in-render, F17 fake form, category/brand truncation (F18). |
| 4 | Admin Dashboard | 6 | Broad operational surface (products, inventory, orders, customers, shipping, audit log, media) with a coherent design system. Docked because A01 makes it unreachable, A07 silently breaks slug checks, and there is no payment-verification surface (Wallet gap). |
| 5 | Authentication | 7 | JWT access/refresh with rotation, reuse-as-theft detection, httpOnly cookies, email verification, throttling on abuse-sensitive routes. Docked because storefront renewal destroys sessions in practice (F01). |
| 6 | Authorization | 7 | Global JwtAuthGuard (opt-out via `@Public()`), RolesGuard, role re-checked from DB in sensitive services (e.g. shipping `updateFee`), admin proxy checks. No counterexample found in the inspected paths. |
| 7 | Security | 6 | Helmet/CSP, CORS allow-list (no wildcard with credentials), `forbidNonWhitelisted` DTO pipe, secret scanner in CI (verified clean this audit: 935 blobs, 16 patterns), media sniffing/EXIF stripping. Docked for Next.js 16.2.4 age (flagged A02 in prior audits, not re-verified here), in-memory throttler (single-instance assumption), and placeholder contact data. Historical credential rotation is outside the current gate per owner decisions — not scored. |
| 8 | Database Integrity | 6 | Replica-set transactions with snapshot/majority concerns, explicit index sync (`autoIndex: false`), unique indexes, scratch-DB test harness. Docked for A05/A06 non-atomic paths and counts (`recount`) maintained outside transactions. |
| 9 | Inventory Management | 8 | Strongest area: `commitSale` inside the checkout transaction, per-line availability precondition, first refusal aborts the whole order; admin adjustments transactional with movement history. |
| 10 | Checkout | 6 | Transactional placement, idempotency-key replay protection, server-side pricing and shipping quote. Docked: COD is the only method that can actually be placed (Wallet gap), and checkout dies with the API under A01. |
| 11 | COD Workflow | 8 | Matches the approved model precisely: `PENDING` at placement, `PAID`+`collectedAt` atomically at DELIVERED, revenue keyed on `payment.status = PAID`. |
| 12 | Wallet/InstaPay Workflow | 0 | Does not exist. No enum value, no state, no UI, no admin action, no WhatsApp handoff. See Findings Verification. |
| 13 | Order Lifecycle | 8 | Single fulfilment axis + separate payment axis, guarded transitions, audit rows, refund recorded as outcome without silent financial change. |
| 14 | Media Management | 7 | Server-mediated uploads, magic-byte sniffing, size limits consistent at 5 MB, reference-count ledger with destroy refusal, reconciliation report. Docked for the A01 reachability issue (MediaService is one of the three broken consumers). |
| 15 | Shipping Management | 5 | Well-formed admin service/UI and a strict no-fallback quote, but runtime-broken by A01 and blocked on the owner-approved rate table (D04/D05 open). |
| 16 | Email/Notifications | 5 | Provider port (Brevo/Resend/console), verification + order-confirmation + reset templates, failure classification. Deliberately no outbox/retry/queue (documented decision in `notifications.service.ts`) — a real operational risk the owner should consciously accept or reverse. |
| 17 | Customer Experience | 5 | Good listing/search/cart bones; undermined by session loss (F01), a contact form that discards messages while claiming success (F17), unreachable products beyond 24 per category/brand (F18), and unverified-review claims (F38). |
| 18 | Admin Experience | 6 | Thoughtful UX (fail-closed slug semantics, inventory history drawer, shipping table). Docked for the silently-dead slug check (A07) and missing payment-verification work queue. |
| 19 | Performance | 5 | Sensible defaults (no-store only where needed, revalidate opt-in, image pipeline caps). **Not measured** — no load test or runtime profiling was possible in this audit; score is a neutral midpoint, not a finding. |
| 20 | Accessibility | 4 | Some aria labelling in admin tables/forms; no evidence of a systematic pass, and this audit did not run an accessibility tool. Scored low for absence of evidence, not for proven violations. |
| 21 | Automated Testing | 6 | 67 API spec files + 18 Playwright specs, scratch-DB isolation, email-isolation and production-like-limits setups, slug/media/checkout coverage. Docked because no suite compiles the *full* AppModule graph — which is exactly how A01 survived a "tested" codebase — and because DB suites could not be executed in this audit (no local replica set available; see Test Coverage Gaps). |
| 22 | CI/CD | 6 | Real gates: lint, type-check, build, OpenAPI drift, transaction gate, blocking secret scan on every branch. Docked: main CI runs only on `main` pushes + PRs, so long-lived feature branches (like the audited one) can drift unverified; no CD (by design, deferred). |
| 23 | Maintainability | 8 | Exceptional in-code documentation: design rationale, authority references, and failure history are recorded at the point of decision. This is why this audit could verify or refute prior claims quickly. Docked slightly for sheer document sprawl at repo root (30+ overlapping reports). |
| 24 | Operational Readiness | 3 | Health endpoint and structured logging exist; but no outbox, in-memory throttling, no provisioned email/media/WhatsApp inputs (D14–D16 open), no backup/RPO/RTO decision (D19 open), no hosting/domain decision (D20/D21 open). |
| 25 | Production Readiness | 2 | The API does not boot (A01), an approved payment method is absent, policies/rate table/WhatsApp number are open owner inputs, and production DB/hosting are unprovisioned (deferred by owner decision). Nothing here is close to a launch checklist pass. |

**Overall: 144 / 250 = 5.8 / 10.**
