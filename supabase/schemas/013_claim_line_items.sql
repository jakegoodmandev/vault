create table claim_line_items (
  id uuid primary key default gen_random_uuid(),
  claim_id uuid not null references claims(id) on delete cascade,

  line_number smallint not null,
  procedure_code text not null,
  procedure_modifier_1 text,
  procedure_modifier_2 text,
  procedure_modifier_3 text,
  procedure_modifier_4 text,

  service_date date not null,
  place_of_service_code text,

  diagnosis_pointer smallint[],

  charge_amount numeric(10,2) not null,
  unit_count numeric(5,2) not null default 1,

  allowed_amount numeric(10,2) default 0,
  paid_amount numeric(10,2) default 0,
  patient_responsibility numeric(10,2) default 0,
  adjustment_amount numeric(10,2) default 0,
  adjustment_reason_code text,
  denial_reason_code text,
  denial_reason_description text,
  remark_code text,

  status text not null default 'draft' check (status in ('draft', 'submitted', 'paid', 'denied', 'appealed')),

  unique (claim_id, line_number)
);

create index idx_claim_line_items_claim on claim_line_items(claim_id);

alter table claim_line_items enable row level security;

create policy "Staff can manage line items at their facility"
  on claim_line_items for all
  using (
    claim_id in (
      select c.id from claims c
      join facilities f on f.id = c.facility_id
      join staff s on s.practice_id = f.practice_id
      where s.auth_user_id = auth.uid() and s.is_active = true
    )
  );
