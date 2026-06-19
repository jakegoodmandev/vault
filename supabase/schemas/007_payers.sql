create table payers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  practice_id uuid not null references practices(id) on delete restrict,

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

create index idx_payers_practice on payers(practice_id);

alter table payers enable row level security;

create policy "Staff can manage payers at their practice"
  on payers for all
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );
