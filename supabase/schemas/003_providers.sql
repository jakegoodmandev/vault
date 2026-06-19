create table providers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  registration_number text unique not null,
  first_name text not null,
  last_name text not null,
  credentials text,
  taxonomy_code text,

  address_line_1 text,
  address_line_2 text,
  city text,
  province text,
  postal_code text,
  phone text,
  email text,

  is_active boolean not null default true
);

alter table providers enable row level security;
