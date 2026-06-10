-- Intake-note summarizer schema (learning scaffold). Synthetic data only.
-- RLS is enabled on every table from day one (the healthcare-critical habit).

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------

-- 1:1 with auth.users, created automatically on signup (see trigger below).
create table if not exists public.profiles (
  id         uuid primary key references auth.users (id) on delete cascade,
  email      text,
  created_at timestamptz not null default now()
);

create table if not exists public.intake_notes (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  raw_text   text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.note_summaries (
  id         uuid primary key default gen_random_uuid(),
  note_id    uuid not null references public.intake_notes (id) on delete cascade,
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  summary    text not null,
  structured jsonb not null default '{}'::jsonb,
  model      text,
  created_at timestamptz not null default now()
);

create index if not exists intake_notes_user_id_idx   on public.intake_notes (user_id);
create index if not exists note_summaries_user_id_idx on public.note_summaries (user_id);
create index if not exists note_summaries_note_id_idx on public.note_summaries (note_id);

-- ---------------------------------------------------------------------------
-- Row-Level Security
-- ---------------------------------------------------------------------------

alter table public.profiles       enable row level security;
alter table public.intake_notes   enable row level security;
alter table public.note_summaries enable row level security;

-- profiles: a user sees and edits only their own row
create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

-- intake_notes: full CRUD scoped to the owner
create policy "intake_notes_select_own" on public.intake_notes
  for select using (auth.uid() = user_id);
create policy "intake_notes_insert_own" on public.intake_notes
  for insert with check (auth.uid() = user_id);
create policy "intake_notes_update_own" on public.intake_notes
  for update using (auth.uid() = user_id);
create policy "intake_notes_delete_own" on public.intake_notes
  for delete using (auth.uid() = user_id);

-- note_summaries: scoped to the owner (Next.js writes these as the signed-in user)
create policy "note_summaries_select_own" on public.note_summaries
  for select using (auth.uid() = user_id);
create policy "note_summaries_insert_own" on public.note_summaries
  for insert with check (auth.uid() = user_id);
create policy "note_summaries_delete_own" on public.note_summaries
  for delete using (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- Auto-create a profile row when a new auth user signs up
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
