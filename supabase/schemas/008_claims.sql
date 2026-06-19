create table claims (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  patient_id uuid not null references patients(id) on delete restrict,
  patient_policy_id uuid references patient_policies(id) on delete restrict,
  primary_provider_id uuid not null references providers(id) on delete restrict,
  facility_id uuid not null references facilities(id) on delete restrict,
  referring_provider_id uuid references providers(id) on delete restrict,
  supervising_provider_id uuid references providers(id) on delete restrict,

  claim_number text,
  external_claim_id text,

  service_date_from date not null,
  service_date_to date not null,
  date_received date,
  place_of_service_code text not null default '11',

  accident_date date,
  accident_state text,
  accident_description text,
  is_auto_accident boolean not null default false,

  total_billed_amount numeric(10,2) not null default 0,
  total_allowed_amount numeric(10,2) default 0,
  total_paid_amount numeric(10,2) default 0,
  total_patient_responsibility numeric(10,2) default 0,
  total_adjustment_amount numeric(10,2) default 0,
  balance_due numeric(10,2) default 0,

  status text not null default 'draft' check (status in ('draft', 'ready', 'submitted', 'accepted', 'partial_paid', 'paid', 'denied', 'appealed', 'closed', 'void')),
  filing_indicator text,

  last_denial_reason text,
  appeal_date date,
  appeal_status text,

  billing_provider_id uuid references providers(id) on delete restrict,
  pay_to_provider_id uuid references providers(id) on delete restrict,

  notes text
);

create index idx_claims_patient on claims(patient_id);
create index idx_claims_status on claims(status);
create index idx_claims_service_date on claims(service_date_from, service_date_to);
create index idx_claims_provider on claims(primary_provider_id);

alter table claims enable row level security;
