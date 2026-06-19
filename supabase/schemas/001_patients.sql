create table patients (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  first_name text not null,
  last_name text not null,
  date_of_birth date not null,
  gender text check (gender in ('male', 'female', 'other', 'unknown')),
  sin_last_four text,

  address_line_1 text,
  address_line_2 text,
  city text,
  province text,
  postal_code text,
  phone text,
  email text,

  patient_external_id text,
  is_active boolean not null default true,
  notes text
);

create index idx_patients_name on patients(last_name, first_name);
create index idx_patients_active on patients(is_active);

alter table patients enable row level security;
