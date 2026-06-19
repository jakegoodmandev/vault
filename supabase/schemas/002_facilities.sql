create table facilities (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  practice_id uuid not null references practices(id) on delete restrict,

  name text not null,
  registration_number text unique,
  taxonomy_code text,

  address_line_1 text,
  address_line_2 text,
  city text,
  province text,
  postal_code text,
  phone text,

  place_of_service_code text default '11',
  is_active boolean not null default true
);

create index idx_facilities_practice on facilities(practice_id);

alter table facilities enable row level security;
