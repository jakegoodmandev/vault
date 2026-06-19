create table claim_status_history (
  id uuid primary key default gen_random_uuid(),
  claim_id uuid not null references claims(id) on delete cascade,
  created_at timestamptz not null default now(),

  status text not null,
  status_date date not null,
  status_code text,
  status_description text,

  changed_by uuid,
  notes text
);

create index idx_claim_status_history_claim on claim_status_history(claim_id);

alter table claim_status_history enable row level security;
