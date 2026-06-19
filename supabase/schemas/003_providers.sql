create table providers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  practice_id uuid not null references practices(id) on delete restrict,
  default_facility_id uuid references facilities(id) on delete set null,

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

create index idx_providers_practice on providers(practice_id);

alter table providers enable row level security;
