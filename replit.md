# Workspace

## Overview

pnpm workspace monorepo using TypeScript. Each package manages its own dependencies.

## Stack

- **Monorepo tool**: pnpm workspaces
- **Node.js version**: 24
- **Package manager**: pnpm
- **TypeScript version**: 5.9
- **API framework**: Express 5
- **Database**: PostgreSQL + Drizzle ORM (API server) + Supabase (storefront)
- **Validation**: Zod (`zod/v4`), `drizzle-zod`
- **API codegen**: Orval (from OpenAPI spec)
- **Build**: esbuild (CJS bundle)

## Key Commands

- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- `pnpm --filter @workspace/api-server run dev` — run API server locally

See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details.

## Artifacts

### Nest Electronics Storefront (`artifacts/storefront`)
- **Kind**: web (Vite + React)
- **Stack**: Vite, React, wouter (routing), zustand (state), @supabase/ssr, lucide-react, Tailwind v4
- **Env vars**: `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`
- **Preview path**: `/` (root)
- **Port**: 18539

#### Pages
- `/` — HomePage (HeroBanner, TrustBar, FeaturedProducts, NewArrivals, BrandsStrip, CategoryGrid)
- `/products` — ProductsPage with filters/sorting
- `/products/:slug` — ProductDetailPage
- `/categories` — CategoriesPage (all categories)
- `/categories/:slug` — CategoryPage (products by category)
- `/brands/:slug` — BrandPage (products by brand)
- `/search` — SearchPage (query param: `?q=`)
- `/wishlist` — WishlistPage
- `/contact` — ContactPage
- `/checkout` — CheckoutPage (multi-step: shipping → review → confirmation)
- `/login`, `/register`, `/forgot-password` — Auth pages
- `/account/orders`, `/account/orders/:id`, `/account/profile`, `/account/addresses` — Account pages

#### Key Files
- `src/App.tsx` — Router + layout
- `src/lib/supabase.ts` — Singleton Supabase browser client
- `src/lib/constants.ts` — ROUTES, EGYPTIAN_GOVERNORATES
- `src/stores/cart-store.ts` — Cart zustand store
- `src/stores/wishlist-store.ts` — Wishlist zustand store
- `src/stores/ui-store.ts` — UI state (cart drawer, mobile menu)
- `src/hooks/useAuth.ts` — Auth hook (Supabase session)
- `src/components/Navbar.tsx` — Main nav with category megamenu, cart/wishlist icons
- `src/components/CartDrawer.tsx` — Slide-in cart drawer
- `src/components/ProductCard.tsx` — Product card + skeleton
