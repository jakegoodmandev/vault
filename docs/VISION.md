# Vision: AI agents for Ontario healthcare offices

## The aspiration

Build the healthcare analog of **Legora** (an AI workspace that automates repetitive
knowledge work for law firms). Target: **Ontario healthcare offices**. Find an annoying,
repeatable piece of work that burns time for **doctors and admin staff** and eliminate or
dramatically improve it with **AI agents and automation**, helping clinicians and admins do
their jobs better.

## Current status (2026-06)

Learning-focused **side project**, not yet a company. The tech foundation is being built to
learn the stack (Supabase, Next.js/Vercel, a Python FastAPI + LangGraph agent service,
OrbStack) and to be moldable into the product later. **The business case is intentionally
deferred** to a future `/office-hours` session.

## Open questions for the future business session

- Who exactly is the user (a named role at a named clinic), and what task do they hate?
- What is the status-quo workaround, and what does it cost in hours/dollars?
- What is the narrowest wedge someone would pay for this week?
- What real access do we have to shadow Ontario healthcare workers?

## Healthcare constraints to honor from day one

- **PHIPA** (Ontario's personal health information law) effectively wants **Canadian data
  residency** → Supabase region `ca-central`; the agent service runs in Fly.io Toronto.
- **No real patient data** while learning. Synthetic data only.
- **RLS on every table** from the start (tenant/user isolation).
- Audit logging, vendor data-processing agreements, and a formal compliance pass are
  **future work**, required before any real PHI touches the system.

## What exists today (the learning scaffold)

A minimal end-to-end slice — an **intake-note summarizer** on synthetic data — that exercises
every layer once:

`sign in (Supabase Auth) → paste a synthetic note → Next.js Server Action → Python agent
(LangGraph + Claude) → structured summary → saved to Supabase (RLS) → rendered in the UI`

See the repository `README.md` for how to run it.
