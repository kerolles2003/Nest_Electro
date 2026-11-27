# Deferred Owner Decisions — Nest Electro

Decisions that belong to the owner alone. During autonomous missions these are
recorded here with a safe, reversible default applied, and work continues on
everything independent of them. Nothing in this file is an approval; it is a
register of what is waiting.

Last updated: 2026-11-22 (autonomous hardening mission).

---

## D-01 — Cloudinary account (production media provider)

- **Question:** Create the Cloudinary account (project decision D-4) and provide its credentials for production configuration?
- **Why it matters:** Production media storage depends on it. The local disk provider is a development bridge and is refused in production by configuration validation.
- **Options:** (a) Create the account and hand over credentials via a secure channel; (b) choose a different production provider (would reopen the adapter decision).
- **Safest temporary behavior:** Local provider in dev/demo only; production refuses `MEDIA_PROVIDER=local`/`memory`. Nothing is uploaded anywhere.
- **Work that continues:** All media pipeline code, tests, and the local adapter are complete and verified.
- **Blocks:** Production only. Not dev, not staging (with the media caveat).

## D-02 — Real manual-payment receiving details

- **Question:** What are the real Wallet number, InstaPay address, and WhatsApp number customers should send transfers and evidence to?
- **Why it matters:** These are business facts only the owner possesses. They are shown to customers at checkout (`MANUAL_PAYMENT_WALLET_NUMBER`, `MANUAL_PAYMENT_INSTAPAY_ADDRESS`, `MANUAL_PAYMENT_WHATSAPP_NUMBER`).
- **Options:** Provide the real values for production env configuration.
- **Safest temporary behavior:** Unset in every committed file; an unconfigured method is simply not offered to customers. Demo uses obvious placeholder fixtures.
- **Work that continues:** The entire verification workflow is implemented and adversarially tested with fixtures.
- **Blocks:** Production only (real prepayment cannot be offered without them).

## D-03 — Authorized payment verifiers

- **Question:** Which admin accounts are authorized to approve/reject payment evidence?
- **Why it matters:** Verification must be attributable; the verifier list is a business control, and Segregation of Duties (PAY-1) already prevents self-approval.
- **Options:** Name the verifier accounts/roles for production.
- **Safest temporary behavior:** Any admin may verify others' orders; nobody may verify their own (enforced and audited).
- **Work that continues:** Everything; SoD is already enforced.
- **Blocks:** Production readiness sign-off, not development.

## D-04 — Shipping rate table (open parts of D04/D05)

- **Question:** Confirm the production shipping rate table (governorate rates, free-shipping thresholds, any exceptions).
- **Why it matters:** Rates are money-facing business facts; inventing them would mischarge real customers.
- **Options:** Approve the seeded table as-is, or provide corrections.
- **Safest temporary behavior:** Existing seeded rates preserved unchanged; no rate was invented or altered by any mission.
- **Work that continues:** Shipping code, guards, and tests are complete against the seeded table.
- **Blocks:** Production only.

## D-05 — Policy texts

- **Question:** Provide/approve the store's returns, privacy, and terms texts.
- **Why it matters:** Legal/customer-facing content is the owner's to state.
- **Options:** Supply texts, or approve drafting for review.
- **Safest temporary behavior:** No policy text invented by engineering.
- **Work that continues:** Everything else.
- **Blocks:** Production storefront completeness, not development.

## D-06 — Public contact channel (D16)

- **Question:** What is the store's public contact channel (the contact form currently has no real destination)?
- **Why it matters:** The storefront contact form was found to be non-functional (F17); wiring it needs a real destination owned by the business.
- **Options:** A monitored email inbox, the WhatsApp number from D-02, or both.
- **Safest temporary behavior:** Form stays visibly non-committal rather than pretending to deliver messages into a void.
- **Work that continues:** Everything else.
- **Blocks:** Production storefront completeness.

## D-07 — Blog behaviour when Supabase is unconfigured (ADV-3)

- **Question:** Should the storefront blog fail soft (like the admin coupons/reviews pages now do) when Supabase is unconfigured, keep failing hard, or be removed from navigation?
- **Why it matters:** Today `/blog` returns 500 in that configuration while sibling legacy pages render an honest "not live" state. It is a product call about what visitors should see.
- **Options:** (a) Fail-soft with an honest notice (the session-8 audit's recommendation, for symmetry); (b) keep as-is; (c) hide the blog until its domain is built.
- **Safest temporary behavior:** No change made autonomously; current behaviour preserved.
- **Work that continues:** Everything; the blog is outside the commerce scope.
- **Blocks:** Nothing for dev/staging; a known storefront wart for production.

## D-08 — Phase-8 domains (coupons, reviews) scope

- **Question:** When are coupons and reviews scheduled as real backend domains (PLAN.md §22, D-5)?
- **Why it matters:** Their admin screens still read/write Supabase and render a "domain not live" notice; the API has no model for either. Building them is a product phase, not a fix.
- **Options:** Schedule the phase, or formally defer.
- **Safest temporary behavior:** Pages render honestly (crash fixed in session 8); no backend invented.
- **Work that continues:** Everything in commerce scope.
- **Blocks:** Production completeness for those two features only.

## D-09 — Orphan media files (384 files, ~478 MB — remeasured 2026-11-22)

- **Question:** Delete the orphan files on local media disk that have no live ledger row, or retain them?
- **Why it matters:** They are not servable (the ledger gate refuses them — verified live), so they are pure disk usage; but deletion is destructive and was never authorized.
- **Measured 2026-11-22 (autonomous mission, `pnpm --filter api media:reconcile` against the demo environment):** 444 files on disk, 60 matched to live ledger rows, **384 on disk only totalling 501,279,722 bytes**, 0 live rows missing a file. Session 8 measured 84 files / 104.3 MB; repeated demo rebuilds since then grew the count — every rebuild uploads fresh copies and orphans the previous set.
- **Options:** (a) Authorize deletion after reviewing the reconciliation report; (b) keep them.
- **Safest temporary behavior:** Nothing deleted. The report-only reconciliation tool is built and prints the exact list on demand.
- **Work that continues:** Everything.
- **Blocks:** Nothing.

## D-10 — Push the reviewed branch and open the PR

- **Question:** Push `muse/full-admin-redesign-product-catalog` (HEAD `d9454e4`, independently reviewed: APPROVED) from an authenticated machine, so the PR can be opened?
- **Why it matters:** The sandbox has no GitHub git credentials and SSH egress is blocked by the network proxy; the connector cannot reproduce exact commit SHAs. Bundle v6 (`~/workspace/nest-electro-muse-full-admin-redesign-product-catalog-v6.bundle`) reproduces `d9454e4` exactly and a ready-to-paste PR body is saved.
- **Options:** (a) Fetch from the bundle and push (two commands); (b) leave the branch local.
- **Safest temporary behavior:** Branch preserved locally; nothing pushed, no history rewritten.
- **Work that continues:** All local engineering (this mission's branch `muse/autonomous-hardening` is stacked on `d9454e4`).
- **Blocks:** Code review on GitHub and merging; not local development.

## D-11 — Dependency audit (`pnpm audit`)

- **Question:** Run and triage `pnpm audit` on a networked machine?
- **Why it matters:** The sandbox proxy blocks the audit endpoint, so dependency vulnerability status is unknown.
- **Options:** Run it on the owner's machine and share results, or accept the gap for now.
- **Safest temporary behavior:** No dependency changed blind; lockfile untouched by all missions.
- **Work that continues:** Everything.
- **Blocks:** Production readiness sign-off.

## D-12 — Playwright in CI

- **Question:** Add the browser test suites to CI?
- **Why it matters:** Browser coverage currently runs locally only; CI would catch storefront/admin regressions on every PR.
- **Options:** (a) Add a CI workflow; (b) keep local-only.
- **Safest temporary behavior:** Local browser verification continues (used by every mission).
- **Work that continues:** Everything.
- **Blocks:** Nothing; a quality-hardening opportunity.
