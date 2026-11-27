# Nest Electro — Flutter mobile app: final report

Mission: build a Flutter customer-storefront app at `apps/mobile` on branch
`flutter-app` (cut from `origin/phase-1-2-overnight` at `5a1fd5c`), phases
0–9 plus a phase-10 hardening pass, fully autonomous, no owner questions.
Status: **all 9 phases + phase 10 done locally, gates green. The final
GitHub sync is NOT done yet** — per owner decision D-08 it happens when
the owner is awake to approve its cards. See "Transfer to GitHub" below.

## What was built

A complete customer storefront app (Android, iOS, web) talking only to
`apps/api`. Arabic is the default locale (RTL), English is second.
Stack: Riverpod 2, go_router, dio, freezed/json_serializable,
`flutter_secure_storage`, `cached_network_image`, bundled Albert Sans +
Urbanist TTFs (the storefront families; `google_fonts` was removed in
phase 10 — the app renders its real typography fully offline).

| Phase | What | Branch commit | Merged into `flutter-app` | Gate |
|---|---|---|---|---|
| 0 Recon | SCREENS.md (22 storefront routes), API_GAPS.md, DECISIONS.md, PROGRESS.md | `f91cade` | PR #3 merged on GitHub `81d1037` (before the plan change) | — |
| 1 Scaffold | `flutter create` (org com.nestelectro), theme, routing table (20 routes), gen_l10n ar+en, `ApiConfig` dart-define base URL | `bfd98d5` + `da2ca51` | `ed0653d` | analyze clean, test 1/1 |
| 2 Core | dio client (Accept-Language, Bearer, 401 refresh-once, envelope errors), token storage, freezed models for the full customer surface | `2856a00` | `d6305fd` | analyze clean, test 19/19 |
| 3 Auth | Login / register / forgot / reset / verify-email + router guards; register 429 UX (3/hour, button disabled while busy) | `1d239a3` | `328aacf` | analyze clean, test 36/36; live 401 `INVALID_CREDENTIALS` verified |
| 4 Catalogue | Home (hero, trust bar, categories, featured + new-arrival rails, brands), product list (search/filter/sort/pagination), product detail (gallery, specs, related), categories tree, search suggestions | `072a140` | `3066b42` | analyze clean, test 54/54, `flutter build web` passes |
| 5 Cart & checkout | Guest basket (local) + server cart, `POST /cart/preview` pricing, addresses, per-address quote, manual payment instructions, order placement with per-checkout idempotency key | `690eac4` | `8c5452b` | analyze clean, test 79/79, `flutter build web` passes; live `POST /cart/preview` verified (2 × 380.00 = 760.00 EGP) |
| 6 Account | Profile, order history + detail (cancel / resubmit payment), addresses CRUD, local wishlist | `5d5d594` | `9a55103` | analyze clean, test 112/112, `flutter build web` passes; live-verified with a fresh customer account |
| 7 Polish | Image caching everywhere, pull-to-refresh, tooltips, WCAG AA contrast (caught + fixed a real dark-theme defect), RTL fixes on every screen, app icon placeholder | `a0da7cc` | `44e8ad2` | analyze clean, test 116/116, `flutter build web` passes; axe-style sweep: 0 violations on audited screens |
| 8 Quality | 32 new tests, happy-path integration test, GitHub Actions workflow | `89c9efa` | `49172ab` | analyze clean, test **148/148** |
| 9 Wrap-up | This report + `README.md` | `4aebdd7` | `cdd518e` | analyze clean, test 148/148 |
| 10 Hardening | Stuck-spinner fix extended to account/orders/addresses/checkout (7 load paths, 6 regression tests); fonts bundled as TTFs, `google_fonts` removed; dark muted foreground measured + fixed (#64748B → #94A3B8); widget coverage for home / product detail / cart / checkout / login; load test 20→50→100 users + 3 checkouts + parallel idempotency proof (see "Phase 10 — Hardening" below) | `flutter/phase-10-hardening` | (merge commit recorded in PROGRESS.md) | analyze clean, test **163/163**, `flutter build web` passes |

Final gate (re-verified on the merged tree): `flutter analyze` — no
issues; `flutter test` — **163/163 passed**; `flutter build web` passes.
All 10 phase branches are merged locally into `flutter-app` with real
merge commits; full history is preserved. Nothing was pushed to GitHub
except phase 0 (PR #3, merged before the plan change). `main` and
`phase-1-2-overnight` were never touched; no force-push; no deploy;
no secrets or `.env` files committed.

## Phase 10 — Hardening (2026-11-27, owner out of the house)

What changed:

- **Stuck-spinner class closed** (known issue #1, except one follow-up):
  the generic `catch` from phase 8's `CartController._load` fix now covers
  the account, orders (first page + load more), order detail, addresses,
  and checkout (load + quote) load paths. A non-API failure surfaces
  `LOAD_FAILED` and clears the loading flag instead of spinning forever.
  Six regression tests, one per controller (three for orders).
  Remaining: `ProductListController` (`catalogue_providers.dart`) still
  catches only `ApiException` in its loads — same hang class, out of the
  phase-10 task's explicit controller list; the one remaining follow-up.
- **Fonts bundled** (known issue #5 closed): 8 static TTFs
  (Albert Sans + Urbanist, 400/500/600/700, ~352 KB) in
  `assets/fonts/`, declared in `pubspec.yaml`; `google_fonts` removed.
  The app works fully offline and the test `allowRuntimeFetching`
  workaround (D-29/D-31) is gone.
- **Dark muted foreground measured and fixed** (known issue #2 closed):
  old #64748B was 3.90:1 on the dark surface (below WCAG AA 4.5:1);
  new #94A3B8 is 7.24:1 (6.41:1 / 5.89:1 on the other dark surfaces),
  pinned by test. Screens still use `colorScheme.onSurfaceVariant`
  (Material default, D-27) — the token was fixed for correctness, not
  rewired.
- **Coverage extended**: 15 new tests (163 total) — home screen (2),
  product detail / cart / checkout / login error states with retry,
  plus app-side concurrency: single-flight token refresh (pre-existing
  test), receive-timeout → `TIMEOUT` mapping, and double-tap order
  placement calling the repository exactly once.
- **App icon untouched** (placeholder "N" stays, per the task).

Load test (live local demo API; driver + raw results in
`~/workspace/loadtest-p10/`, kept outside the repo):

| Endpoint | 20 users p50 / p95 | 50 users p50 / p95 | 100 users p50 / p95 |
|---|---|---|---|
| `GET /products?limit=12&sort=newest` | 113 / 295 ms | 251 / 658 ms | 297 / 1,393 ms |
| `GET /categories` | 14 / 59 ms | 23 / 87 ms | 83 / 120 ms |
| `GET /products?q=esp32` | 35 / 84 ms | 68 / 101 ms | 91 / 210 ms |
| `GET /products/:slug` | 27 / 80 ms | 49 / 113 ms | 105 / 273 ms |
| `POST /cart/preview` | 24 / 79 ms | 53 / 92 ms | 75 / 225 ms |

- **Zero 5xx, zero transport errors** across ~3,400 requests (two runs);
  every request 2xx in the clean run. First run's search 400s were the
  driver's fault (`search` is not a param — the API takes `q`, D-38).
- **Checkouts**: 3 fresh accounts (register is throttled 3/hour per IP —
  the ceiling), 3 COD orders (`NE-20261127-0001`…`0003`); re-sending the
  same idempotency key returned the same order each time. A parallel
  double-send (two concurrent `POST /orders`, one fresh key) returned
  statuses `[201, 200]` for the same order (`NE-20261127-0004`) with the
  user's order count rising by exactly 1 — **no duplicate orders**.
- **Honest limit — read this before quoting the numbers:** the driver,
  the API, and Mongo all ran on the same 1.5-CPU sandbox cell, so the
  latencies above are dominated by the cell, not the code. This proves
  the system holds up under 100 concurrent users on sandbox hardware;
  it is **not production-scale proof**. What must be re-checked on real
  hosting: the same steps against the production-shaped deployment
  (separate DB/API hosts, real network), sustained rather than burst
  load, and a real-device checkout. The one endpoint to watch is
  `GET /products` (list) — its p95 degrades fastest with concurrency
  (295 → 658 → 1,393 ms); a candidate for server-side caching or an
  index review on real hosting.
- `flutter build web` prints a CupertinoIcons font warning; it is benign
  (no code references `CupertinoIcons`, D-40).

## What's mocked (no API endpoint — see API_GAPS.md)

- **G1 Wishlist** — device-only (SharedPreferences), clearly marked mock,
  with a "device-only" banner. Needs a future wishlist API to sync.
- **G2 Blog** — static placeholder posts, clearly marked mock. Needs a
  future blog API.
- **G3 Reviews** — rating average/count display only; no review list or
  submission (Phase 8 domain on the backend).
- **G4 Coupons** — no coupon input in checkout (Phase 8 domain).
- **G5 Contact** — static screen, not an API gap.
- **G6 Payments** — manual-only: COD / wallet / InstaPay instructions from
  `GET /checkout/payment-methods`; `transferSender` collected for
  wallet/InstaPay; no gateway SDK integrated (per mission rules).
  Wallet/InstaPay orders stay `PENDING_VERIFICATION` until an admin
  verifies them; resubmission is offered when verification is rejected.
- **G7 Images** — local media-delivery shape by default; Cloudinary shape
  only via `--dart-define=CLOUDINARY_CLOUD_NAME` (account not delivered).
- **G8 Push notifications** — none (no endpoint; order status is checked
  by re-opening order history).
- **G9 Guest checkout** — not possible; `POST /orders` requires auth.
  Guests can browse, search, and price a basket via `/cart/preview`,
  then log in/register at checkout.

## Known issues

1. **Other controllers still catch only `ApiException` in their loads —
   mostly fixed in phase 10.** The account/orders/addresses/checkout
   controllers now have the generic `catch` (see "Phase 10 — Hardening").
   The one remaining instance is `ProductListController`
   (`catalogue_providers.dart`) — same hang class, follow-up.
2. **Dark-theme muted foreground — FIXED in phase 10.** Measured
   #64748B at 3.90:1 (below AA); changed to #94A3B8 at 7.24:1, pinned by
   test (D-36).
3. **`onSurfaceVariant` is the Material default**, not the storefront
   muted token (D-27) — deliberate, contrast-verified deviation.
4. **App icon is a placeholder** (navy + crimson "N", D-28). Replace
   `assets/icon/icon.png` with the real brand mark and re-run
   `dart run flutter_launcher_icons`.
5. **Fonts — FIXED in phase 10.** The TTFs are bundled in
   `assets/fonts/`; `google_fonts` is removed and the app renders its
   real typography fully offline (D-35).
6. **iOS was never built** — iOS cannot be built on Linux; it needs a Mac
   (D-07). **No APK was built** — no Android SDK in the sandbox (D-10).
   `flutter test` (Dart VM) and `flutter build web` are the verified gates.
7. **Brand/category header falls back to the slug** when the detail fetch
   fails — acceptable; the list below carries the loading/error states.
8. **Demo observation, not an app defect** (D-25): the documented sandbox
   customer (`sandbox@nest-electronics.test`) returns
   `INVALID_CREDENTIALS` against the current demo DB; phases 3/5/6 were
   live-verified with fresh accounts instead.

## What the owner needs to do next

1. **Approve the final GitHub sync** (when awake — see "Transfer to
   GitHub"). Review the final PR `flutter-app` →
   `phase-1-2-overnight` and **do not merge it** until reviewed; merging
   is the owner's call.
2. **Replace the app icon** (`assets/icon/icon.png`, then
   `dart run flutter_launcher_icons`). Fonts are bundled since phase 10 —
   no decision left there.
3. **Run the app on a real device/emulator** (Android SDK) and **build
   iOS on a Mac**; point it at the API with
   `--dart-define=API_BASE_URL=<your API URL>`. Re-run the load steps
   against the real hosting (see "Phase 10 — Hardening" — sandbox
   numbers are not production proof).
4. **Owner deliverables that unblock production behaviour** (same
   deferred list as the API missions): Cloudinary account; real
   `MANUAL_PAYMENT_*` values (wallet number, InstaPay address, WhatsApp
   number); authorized payment verifiers; shipping rate table; policy
   texts; contact channel.
5. **Product decisions**: blog scope (ADV-3), Phase-8 coupons/reviews
   scope, and the one remaining `ApiException`-only catch
   (`ProductListController`, known issue #1).
6. Read [DECISIONS.md](DECISIONS.md) (D-01…D-41) with the final PR —
   it is the record of every autonomous choice and its reasoning.

## Transfer to GitHub

- **Final sync: PENDING — owner must be awake to approve the cards.**
  One sync: reuse the existing remote `flutter-app` branch (tip
  `81d1037`, phase 0 only — do NOT re-create it), snapshot-upload the
  finished `flutter-app` content, open the final PR `flutter-app` →
  `phase-1-2-overnight`, **DO NOT merge it**.
- **Binary exclusion:** the generated app-icon PNGs (and any other
  binary under `apps/mobile`) MUST be excluded from any connector
  `push_files` manifest — snapshot push is text-only; the git bundle
  below carries them.
- **Bundle fallback:** `~/workspace/nest-electro-flutter-app-v1.bundle`
  (7,069,177 bytes, `git bundle verify` passed). Contains `flutter-app`
  at `cdd518e` plus all 10 `flutter/phase-*` branches; prerequisite is
  `5a1fd5c` (`phase-1-2-overnight` tip, already on GitHub). If the GitHub
  sync ultimately cannot complete, this bundle is the transfer vehicle —
  same pattern as bundle v7. Fetch it on the owner's machine and confirm
  the `flutter-app` tip SHA before pushing.
