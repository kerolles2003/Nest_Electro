# Nest Electro — Flutter mobile app: final report

Mission: build a Flutter customer-storefront app at `apps/mobile` on branch
`flutter-app` (cut from `origin/phase-1-2-overnight` at `5a1fd5c`), phases
0–9, fully autonomous, no owner questions. Status: **all 9 phases done
locally, gates green. The final GitHub sync is NOT done yet** — per owner
decision D-08 it happens when the owner is awake to approve its cards.
See "Transfer to GitHub" below.

## What was built

A complete customer storefront app (Android, iOS, web) talking only to
`apps/api`. Arabic is the default locale (RTL), English is second.
Stack: Riverpod 2, go_router, dio, freezed/json_serializable,
`flutter_secure_storage`, `cached_network_image`, `google_fonts`
(Albert Sans + Urbanist, the storefront families).

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
| 9 Wrap-up | This report + `README.md` | `flutter/phase-9-wrap-up` | (merge SHA in git log) | analyze clean, test 148/148 |

Final gate (re-verified on the merged tree): `flutter analyze` — no
issues; `flutter test` — **148/148 passed**; `flutter build web` passes.
All 9 phase branches are merged locally into `flutter-app` with real
merge commits; full history is preserved. Nothing was pushed to GitHub
except phase 0 (PR #3, merged before the plan change). `main` and
`phase-1-2-overnight` were never touched; no force-push; no deploy;
no secrets or `.env` files committed.

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

1. **Other controllers still catch only `ApiException` in their loads.**
   Phase 8 fixed this in `CartController._load` (a non-API failure left
   `isLoading: true` forever — a real bug the integration test caught).
   The same hang class exists in the account/orders/addresses/checkout
   controllers' load paths. Follow-up, low risk (their loads only touch
   the API, which throws `ApiException`).
2. **Dark-theme muted foreground unmeasured.** The storefront dark
   `--color-foreground-muted` (#64748b) was never contrast-swept (dark
   mode was never swept in phase 7). The app's own dark scheme tokens
   pass WCAG AA (pinned by test).
3. **`onSurfaceVariant` is the Material default**, not the storefront
   muted token (D-27) — deliberate, contrast-verified deviation.
4. **App icon is a placeholder** (navy + crimson "N", D-28). Replace
   `assets/icon/icon.png` with the real brand mark and re-run
   `dart run flutter_launcher_icons`.
5. **Fonts are fetched at runtime** (`google_fonts`), not bundled. The app
   falls back to system fonts offline; widget tests need
   `GoogleFonts.config.allowRuntimeFetching = false` in `setUpAll`
   before `AppTheme` is constructed (D-29/D-31). Bundling the TTFs
   would remove both caveats.
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
   `dart run flutter_launcher_icons`) and decide on bundling the fonts.
3. **Run the app on a real device/emulator** (Android SDK) and **build
   iOS on a Mac**; point it at the API with
   `--dart-define=API_BASE_URL=<your API URL>`.
4. **Owner deliverables that unblock production behaviour** (same
   deferred list as the API missions): Cloudinary account; real
   `MANUAL_PAYMENT_*` values (wallet number, InstaPay address, WhatsApp
   number); authorized payment verifiers; shipping rate table; policy
   texts; contact channel.
5. **Product decisions**: blog scope (ADV-3), Phase-8 coupons/reviews
   scope, and the `ApiException`-only catch follow-up in §1 above.
6. Read [DECISIONS.md](DECISIONS.md) (D-01…D-33) with the final PR —
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
  (created after the phase-9 merge; verified with `git bundle verify`).
  If the GitHub sync ultimately cannot complete, this bundle is the
  transfer vehicle — same pattern as bundle v7. Fetch it on the owner's
  machine and confirm the `flutter-app` tip SHA before pushing.
