create table "workspace" (
  "id"              uuid not null primary key default gen_random_uuid(),
  "name"            text not null,
  "created_at"      timestamptz not null default now()
);

alter table public.workspace enable row level security;

grant select on public.workspace to authenticated;
grant select, insert, update, delete ON public.workspace to service_role;
