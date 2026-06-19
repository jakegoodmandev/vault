create table claim_diagnoses (
  claim_id uuid not null references claims(id) on delete cascade,
  diagnosis_id uuid not null references diagnoses(id) on delete restrict,
  diagnosis_order smallint not null check (diagnosis_order between 1 and 12),

  primary key (claim_id, diagnosis_id),
  unique (claim_id, diagnosis_order)
);

alter table claim_diagnoses enable row level security;
