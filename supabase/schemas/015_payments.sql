create table payments (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),

  practice_id uuid not null references practices(id) on delete restrict,
  payer_id uuid not null references payers(id) on delete restrict,
  claim_id uuid references claims(id) on delete set null,

  payment_amount numeric(10,2) not null,
  payment_date date not null,
  payment_method text check (payment_method in ('check', 'eft', 'credit_card', 'cash', 'other')),
  check_number text,
  check_date date,

  era_transaction_id text,
  era_file_name text,

  is_reconciled boolean not null default false,
  notes text
);

create index idx_payments_claim on payments(claim_id);
create index idx_payments_payer on payments(payer_id);
create index idx_payments_practice on payments(practice_id);

alter table payments enable row level security;

create policy "Staff can manage payments at their practice"
  on payments for all
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );
