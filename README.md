# This project has moved

**→ https://github.com/kerolles2003/Nest_Electronics_Project**

That repository is the Nest Electronics system: the NestJS API, the customer
storefront, the admin console, and the frozen v1 API contract a mobile client is
built against. If you were sent here to work on Nest Electronics, you were sent
to the wrong place.

## What this repository is

An **early prototype**, kept for its history and nothing else. It is a
Supabase-backed Vite storefront, last touched on 2026-05-02, and it is **not**
an earlier version of the system at the link above — it is a different
architecture that was abandoned rather than migrated.

The two share an ancestor and then diverge completely. Nineteen commits here
have no counterpart there, and nothing here should be copied forward.

## Do not build against this

- The API in the new repository is the only source of business rules. This
  prototype talks to Supabase directly from the client.
- The v1 contract, its drift gate, the test suites and the security scanning all
  live in the new repository. None of them exist here.
- This repository is **archived**: read-only, and it will not be updated again.

## A note on the name

Three repositories under this owner have similar names. Only one is the system:

| Repository | What it is |
|---|---|
| **`Nest_Electronics_Project`** | **The project.** Go here. |
| `Nest_Electro` | This one — the archived prototype. |
| `Nest_Electronics` | Empty, created by mistake. Nothing is there. |

The most natural-sounding name is the empty one. The project is at
**`Nest_Electronics_Project`**.
