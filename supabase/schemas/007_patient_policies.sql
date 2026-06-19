create table patient_policies (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  patient_id uuid not null references patients(id) on delete cascade,
  payer_id uuid not null references payers(id) on delete restrict,

  policy_holder_first_name text not null,
  policy_holder_last_name text not null,
  policy_holder_date_of_birth date,
  relationship_to_patient text check (relationship_to_patient in ('self', 'spouse', 'child', 'parent', 'other')),

  member_id text not null,
  group_number text,
  policy_number text,

  coverage_start_date date,
  coverage_end_date date,
  is_primary boolean not null default true,

  copay_amount numeric(10,2),
  deductible_amount numeric(10,2),
  deductible_met numeric(10,2),

  notes text
);

create index idx_patient_policies_patient on patient_policies(patient_id);
create index idx_patient_policies_payer on patient_policies(payer_id);

alter table patient_policies enable row level security;
