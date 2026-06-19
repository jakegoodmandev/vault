create table claim_diagnoses (
  claim_id uuid not null references claims(id) on delete cascade,
  diagnosis_id uuid not null references diagnoses(id) on delete restrict,
  diagnosis_order smallint not null check (diagnosis_order between 1 and 12),

  primary key (claim_id, diagnosis_id),
  unique (claim_id, diagnosis_order)
);

alter table claim_diagnoses enable row level security;

create policy "Staff can manage claim diagnoses at their facility"
  on claim_diagnoses for all
  using (
    claim_id in (
      select c.id from claims c
      join facilities f on f.id = c.facility_id
      join staff s on s.practice_id = f.practice_id
      where s.auth_user_id = auth.uid() and s.is_active = true
    )
  );
