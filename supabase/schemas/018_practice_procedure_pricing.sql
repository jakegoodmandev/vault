create table practice_procedure_pricing (
  practice_id uuid not null references practices(id) on delete cascade,
  procedure_id uuid not null references procedures(id) on delete cascade,
  custom_charge numeric(10,2),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),

  primary key (practice_id, procedure_id)
);

alter table practice_procedure_pricing enable row level security;

create policy "Staff can manage procedure pricing"
  on practice_procedure_pricing for all
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );
