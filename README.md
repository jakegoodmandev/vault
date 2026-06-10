# Vault

Learning scaffold for an **AI-agents-for-healthcare** web app (Ontario). This is a side
project to learn the stack; the product/business case lives in [`docs/VISION.md`](docs/VISION.md)
and is intentionally deferred.

> Synthetic data only. No real patient data. See PHIPA notes in `docs/VISION.md`.

## Architecture

```
Browser → Next.js (Vercel) → Python agent service (Fly.io, Toronto)
                │                        │  LangGraph + Claude
                └── Supabase Auth        │
          Supabase Postgres + RLS (ca-central)
```

- `apps/web` — Next.js (App Router, TS) + Tailwind + shadcn/ui + Supabase Auth. Does all DB writes
  as the signed-in user, so RLS is enforced end to end.
- `services/agents` — Python FastAPI + LangGraph agent. Verifies the user's Supabase JWT (via the
  project JWKS), runs the summarizer, returns a structured result. No direct DB access.
- `supabase/` — local config + SQL migrations (schema + RLS).

## Prerequisites

Node 20+, pnpm, Docker (OrbStack), Supabase CLI, `uv`, `flyctl`. See the install checklist in
the project plan.

## Run it locally

```bash
# 1. Web app
pnpm install
pnpm dev:web                      # http://localhost:3000

# 2. Agent service (separate terminal)
cd services/agents
uv run uvicorn app.main:app --reload --port 8000   # http://localhost:8000

# 3. Database
# Either develop against your hosted Supabase project, or run the local stack:
supabase start                    # local Postgres/Studio via Docker (OrbStack)
supabase db reset                 # apply migrations to the local stack
```

Environment variables live in per-service `.env.local` / `.env` files (gitignored). Copy from the
`.env.example` in each service and fill in values.

## Test

```bash
pnpm test:e2e                     # Playwright end-to-end (apps/web)
```

## Deploy

- Web → Vercel (auto-deploys from GitHub; set env vars in the dashboard).
- Agent → Fly.io, Toronto region: `fly deploy` from `services/agents`.
