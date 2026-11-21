# Nest Electro — Project Handoff Guide for Muse

**Document Version:** 1.0.0  
**Generated Date:** November 21, 2026  
**Repository:** `https://github.com/kerolles2003/Nest_Electro.git`  
**Primary Branch:** `phase-1-2-overnight`  
**Target Audience:** Muse (Lead AI Implementation Engineer)

---

## 1. Executive Summary & Project Architecture

### 1.1 Project Overview
Nest Electro is a production-grade Egyptian e-commerce platform specializing in consumer electronics. The project was originally started on Supabase/Next.js and transitioned into a dedicated modern microservices/monorepo architecture using NestJS, Next.js 16 (App Router + Turbopack), and MongoDB with Mongoose.

### 1.2 Technology Stack
- **Backend API (`apps/api`):** NestJS 11+, Mongoose 9+, MongoDB (replica set enabled for multi-document ACID transactions via `TransactionService`), TypeScript 5.9+. Runs on port `4000`.
- **Storefront App (`apps/storefront`):** Next.js 16.2.4 (App Router), React 19.2.4, Tailwind CSS, TypeScript. Runs on port `3000`.
- **Admin Dashboard (`apps/admin`):** Next.js 16.2.4 (App Router, `basePath: '/admin'`), React 19.2.4, Tailwind CSS, dark-only custom design system (Concept 03 "Editorial Human" tokens in `globals.css`). Runs on port `3001` (accessible at `/admin`).
- **Shared Packages (`packages/`):**
  - `@nest/config`: Unified environment schemas, JWT configuration, CSP definitions.
  - `@nest/types`: Shared domain interfaces, DTOs, and schemas.
  - `@nest/ui`: Shared UI components (`StatusBadge`, buttons, typography).
  - `@nest/providers`: Legacy provider singletons (contains Supabase client; see scope decisions below).

### 1.3 Active Architecture vs. Out-of-Scope Paths
> [!IMPORTANT]
> **Supabase is Completely Out of Scope:**  
> The project has migrated to MongoDB. Supabase remains in `packages/providers` as a legacy artifact. Under Owner Decision D02, **do NOT make Supabase a launch dependency, do NOT investigate Supabase ACLs, and do NOT attempt Supabase remediation.**
>
> **Flutter Client is Deferred:**  
> Flutter mobile app implementation is deferred (Decision D04). All active work is strictly focused on Web Storefront, Admin Dashboard, and NestJS API.
>
> **Temporary MongoDB Infrastructure:**  
> The active MongoDB instance is temporary development infrastructure. Do not attempt production migration, truncation, or drop scripts (Decision D01).

---

## 2. Git Repository State & Synchronization

### 2.1 Branch & Remote Information
- **Local & Remote Branch:** `phase-1-2-overnight`
- **Remote Origin URL:** `https://github.com/kerolles2003/Nest_Electro.git`
- **Upstream Tracking:** `origin/phase-1-2-overnight` (configured)
- **Base Commit:** `de8a353808c74b3885c2700ab89d756176dcecc7` (146 commits ahead of `origin/main`)
- **Handoff Commit:** Includes all completed P0/P1 code modifications, the full suite of audit reports, testing fixtures, and this handoff specification.

### 2.2 Security & Secrets Exclusion
All sensitive local configuration files have been verified against `.gitignore` and are strictly excluded from the Git tree:
- Root `.env` (excluded)
- `apps/admin/.env.local` (excluded)
- `apps/api/.env` (excluded)
- `apps/storefront/.env.local` (excluded)
- `.mcp.json` (excluded)
All examples (`.env.example`) contain placeholders and are safely tracked.

---

## 3. Completed Work & Verified Evidence

The repository contains substantial completed work across Phase 0 (Infrastructure & Security Baseline) and Phase 1 (Core Commerce & Administration):

### 3.1 Phase 0 Deliverables (Verified & Passing)
- **Test Infrastructure:** Dedicated Jest configurations `jest.p0.config.js` and `jest.p1.config.js` in `apps/api`.
- **Scratch Database Harness:** `apps/api/src/database/testing/scratch-database.ts` and runner scripts allow isolated per-suite MongoDB database spinning and cleanup.
- **Index Health & Consistency:** `apps/api/test/infrastructure/index-health.spec.ts` verifies MongoDB unique indexes across users, products, categories, brands, orders, and reviews.
- **Admin Proxy Security:** `apps/admin/src/proxy.ts` enforces JWT validation and rejects unauthorized users before reaching server components or actions.
- **Security Scanners:** `scripts/scan-secrets.mjs` scans for 15+ credential canary patterns with self-test verification.

### 3.2 Phase 1 Deliverables (Verified & Integrated)
- **Admin Concept 03 Redesign:** Implemented across `apps/admin/src/app/(dashboard)/` and components (Orders, Products, Inventory, Customers, Brands, Categories, Reviews, Settings, Audit Log) using dark-only tokens.
- **Catalog Administration:** Complete CRUD services and controllers (`apps/api/src/modules/catalog/`) with audit diff logging, category hierarchy, and brand assignment.
- **Inventory Tracking:** Transactional stock adjustments and movement history drawer (`apps/admin/src/components/inventory/InventoryHistoryDrawer.tsx`).
- **Media Management:** Cloudinary integration and fallback local buffer handling (`apps/api/src/modules/media/`).
- **XSS & Content Sanitization:** `apps/storefront/src/lib/safe-content.ts` and `packages/config/src/content-security-policy.ts` providing strict HTML sanitization.

---

## 4. Known Critical Findings & Audit Defects

The forensic audit documented in `FULL_PROJECT_AUDIT_REPORT.md` revealed specific high-priority defects that Muse must address. These are categorized below in order of severity:

### 4.1 Blocker Defects (Must Fix First)
1. **[A01] API Bootstrapping Failure (`TransactionService` Injection):**
   - *Location:* `apps/api/src/database/database.module.ts` & consumers.
   - *Issue:* NestJS fails to bootstrap in standard mode because `TransactionService` is requested by downstream modules but not cleanly exported/provided in `DatabaseModule`.
   - *Impact:* API runtime cannot start without test harness mocking.
2. **[F01] Storefront SSR Cookie Crash on First Visit:**
   - *Location:* `apps/storefront/src/proxy.ts` / server component cookie access.
   - *Issue:* Unhandled cookie read during server-side rendering when the visitor has no pre-existing session causes a 500 error on the home page.
3. **[Payment Gap] Missing Wallet / InstaPay Manual Verification Workflow:**
   - *Location:* Storefront checkout flow & Admin Order Management.
   - *Issue:* The approved payment specification mandates Cash on Delivery (COD), Electronic Wallet, and InstaPay. While COD exists, Wallet and InstaPay lack the required manual verification step:
     - Customer selects Wallet/InstaPay $\rightarrow$ View instructions $\rightarrow$ WhatsApp redirect with order number and reference $\rightarrow$ Admin verifies screenshot/SMS $\rightarrow$ Admin marks order as `PAID`.
     - Current code has no WhatsApp handoff link generator and no admin manual confirmation action for unverified transfers.

### 4.2 High-Priority Functional Defects
1. **[A03] Media Upload Size Limit:**
   - *Location:* `apps/api/src/modules/media/presentation/media.controller.ts` & `ProductImageManager.tsx`.
   - *Issue:* Image uploads reject files $>1\text{MB}$ due to an unconfigured Multer buffer limit, blocking high-resolution product photography.
2. **[A05 / A06] Product Update Price Overwrite & Review Recount Race Condition:**
   - *Location:* `apps/api/src/modules/catalog/application/product-admin.service.ts` & review submission hooks.
   - *Issue:* Updating product details inadvertently overwrites sale pricing if not passed; review rating recalculation is non-atomic and subject to write race conditions.
3. **[A07] Slug Availability Check BasePath 404:**
   - *Location:* `apps/admin/src/components/products/ProductForm.tsx`.
   - *Issue:* Slug validation fetch targets `/api/catalog/check-slug` without respecting Next.js `/admin` basePath, resulting in 404 errors during product creation.
4. **[F16] Shipping Rate Query Returns Empty (0 rows):**
   - *Location:* `apps/api/src/modules/fulfilment/application/shipping-rates-admin.service.ts`.
   - *Issue:* Checkout fails to calculate governorate shipping rates because default Egyptian governorate rates are unseeded in development.
5. **[F17] Storefront Contact Form Mock:**
   - *Location:* `apps/storefront/src/app/contact/page.tsx`.
   - *Issue:* The contact form simulates submission client-side and does not dispatch emails or persist messages to the database.
6. **[F18] Catalog Pagination Truncation Bug:**
   - *Location:* Storefront product list query handler.
   - *Issue:* Pagination skips records when filtering by multiple facets due to incorrect limit/skip offset arithmetic in Mongoose aggregation.
7. **[F25] Notification Outbox & Retry Mechanism Missing:**
   - *Location:* `apps/api/src/modules/notifications/`.
   - *Issue:* Email and SMS notifications fire inline during checkout; transient SMTP failures cause order submission to hang or fail without an outbox retry queue.

### 4.3 Security & Infrastructure Findings
- **[A02] Next.js 16.2.4 Vulnerabilities:** Dependencies contain unpatched CVEs in Next.js internal server action parsing; needs pin evaluation once upstream patches land.
- **Rate Limiting:** Public auth endpoints (`/auth/login`, `/auth/register`, `/auth/forgot-password`) lack Redis-backed sliding window rate limiters.

---

## 5. Locked Project Owner Decisions (D01–D30)

Muse must treat the following decisions as inviolable constraints:

| ID | Decision Topic | Inviolable Policy |
|---|---|---|
| **D01** | Database Environment | Temporary development MongoDB only. **Do NOT** provision production MongoDB, drop collections, or run destructive migrations. |
| **D02** | Supabase Deprecation | Supabase is **OUT OF SCOPE**. Do not make Supabase a launch blocker or spend effort on Supabase policies/ACLs. |
| **D03** | Credential Rotation | Historical secret rotation is **OUTSIDE** current execution gate. Do not halt work to rotate credentials. |
| **D04** | Flutter Client | Flutter app is **DEFERRED**. Scope is web storefront, admin dashboard, and API. |
| **D05** | Production Cutover | Live production deployment remains a future authorized phase. |
| **D06** | Payment Model | **COD + Manual Wallet / InstaPay ONLY.** No Stripe, PayMob, or automated card gateway integration allowed. |
| **D07** | Admin Authentication | JWT-based auth with explicit `ADMIN` role check in proxy and API guards. |
| **D08** | Dark Design System | Admin must strictly adhere to the dark-only Concept 03 design tokens. |

---

## 6. Implementation Blueprint for Muse

Muse should execute remaining work in strict dependency order according to the following phased roadmap:

```
┌────────────────────────────────────────────────────────┐
│ Phase A: Unblock Runtime (A01, F01, Multer Limits)      │
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│ Phase B: Payment & Fulfillment (Wallet/InstaPay + COD)  │
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│ Phase C: Catalog, Inventory & Admin Integrity (A05-A07)│
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│ Phase D: Customer Journey Polish (F16-F18, Reviews, CSP)│
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│ Phase E: Pre-Production Hardening & Final Test Suites   │
└────────────────────────────────────────────────────────┘
```

### Actionable Task Breakdown:

1. **Step 1: Unblock API Bootstrapping (Defect A01)**
   - Open `apps/api/src/database/database.module.ts`.
   - Ensure `TransactionService` is included in `providers` and explicitly exported in `exports`.
   - Verify NestJS API starts without dependency injection errors (`npm run start:dev` in `apps/api`).
2. **Step 2: Fix Storefront SSR Cookie Guard (Defect F01)**
   - Open `apps/storefront/src/proxy.ts` and the root layout/server components.
   - Wrap cookie reads in safe optional accessors; gracefully handle cold visitors with default empty session state.
3. **Step 3: Implement Egyptian Wallet & InstaPay Manual Verification Flow**
   - In Storefront Checkout:
     - Add payment method selector: `CASH_ON_DELIVERY`, `VODAFONE_CASH` / `ORANGE_CASH` / `ETISALAT_CASH`, and `INSTAPAY`.
     - Render verified Egyptian wallet numbers and InstaPay address (from config/settings).
     - Provide WhatsApp transfer link with pre-filled message: `Order #{{orderId}} - Total: {{total}} EGP - Transfer Reference: {{ref}}`.
   - In Admin Orders (`apps/admin/src/components/orders/`):
     - Display `Payment Method`, `Transfer Reference`, and `Payment Status` (`PENDING_VERIFICATION`).
     - Add action button: `Confirm Payment Receipt` $\rightarrow$ Transitions status to `PAID` with audit logging.
4. **Step 4: Fix Admin Catalog & Form Paths (A03, A05, A06, A07)**
   - Configure Multer upload limits in `apps/api/src/modules/media/media.module.ts` to support up to $10\text{MB}$.
   - Fix price preservation logic in `ProductAdminService.updateProduct()`.
   - Fix slug availability check path in `ProductForm.tsx` to include `${basePath}/api/catalog/check-slug`.
5. **Step 5: Seed Egyptian Governorate Shipping Rates (F16)**
   - Add default governorates seed data (Cairo, Giza, Alexandria, Delta, Upper Egypt) in `ShippingRatesAdminService` so checkout shipping calculation functions out of the box.

---

## 7. Audit & Documentation References

The repository contains exhaustive forensic documentation. Muse should consult these files:

| File Name | Purpose |
|---|---|
| `FULL_PROJECT_AUDIT_REPORT.md` | Comprehensive 25-dimension audit report with forensic findings and technical proof. |
| `PROJECT_COMPLETION_MATRIX.md` | Complete 57-task reconciliation against `MASTER_IMPLEMENTATION_PLAN.md`. |
| `REMAINING_WORK_ROADMAP.md` | Dependency-sequenced roadmap across Workstreams A through E. |
| `PRODUCTION_READINESS_SCORECARD.md` | Metric scores, blocker register, and readiness criteria. |
| `OWNER_DECISIONS_2026-10-07.md` | Complete log of inviolable project owner decisions. |
| `ADMIN_DASHBOARD_AUDIT_REPORT.md` | Comprehensive UI/UX and route analysis of the Admin Dashboard. |
| `ADMIN_DASHBOARD_SECURITY_FINDINGS.md` | Security assessment of admin routes, actions, and proxy. |

---

*Handoff prepared and verified for Muse.*
