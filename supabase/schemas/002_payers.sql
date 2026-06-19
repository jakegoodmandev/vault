create table payers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  name text not null,
  payer_id text,
  address_line_1 text,
  address_line_2 text,
  city text,
  province text,
  postal_code text,
  phone text,
  website text,

  payer_type text check (payer_type in ('commercial', 'government', 'auto', 'wsib', 'other')),
  is_active boolean not null default true
);

alter table payers enable row level security;
