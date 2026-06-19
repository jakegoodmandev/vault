create table procedures (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  description text not null,
  category text,
  default_charge numeric(10,2),
  is_active boolean not null default true
);

alter table procedures enable row level security;
