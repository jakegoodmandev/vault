create table practice_diagnoses (
  practice_id uuid not null references practices(id) on delete cascade,
  diagnosis_id uuid not null references diagnoses(id) on delete cascade,
  is_active boolean not null default true,
  is_favorite boolean not null default false,
  created_at timestamptz not null default now(),

  primary key (practice_id, diagnosis_id)
);

alter table practice_diagnoses enable row level security;

create policy "Staff can manage practice diagnoses"
  on practice_diagnoses for all
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );
