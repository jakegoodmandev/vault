create table "staff" (
  "id"              uuid not null primary key default gen_random_uuid(),
  "auth_user_id"    uuid references auth.users(id) on delete set null,
  "created_at"      timestamptz not null default now(),
);
