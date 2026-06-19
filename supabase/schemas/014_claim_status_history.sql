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

create policy "Staff can manage status history at their facility"
  on claim_status_history for all
  using (
    claim_id in (
      select c.id from claims c
      join facilities f on f.id = c.facility_id
      join staff s on s.practice_id = f.practice_id
      where s.auth_user_id = auth.uid() and s.is_active = true
    )
  );
