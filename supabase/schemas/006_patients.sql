create table patients (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  practice_id uuid not null references practices(id) on delete restrict,
  default_facility_id uuid references facilities(id) on delete set null,

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
create index idx_patients_practice on patients(practice_id);

alter table patients enable row level security;

create policy "Staff can manage patients at their practice"
  on patients for all
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );
