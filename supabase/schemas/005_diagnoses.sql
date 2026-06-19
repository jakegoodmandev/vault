create table diagnoses (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  description text not null,
  category text,
  is_active boolean not null default true
);

alter table diagnoses enable row level security;
