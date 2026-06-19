create table payment_allocations (
  id uuid primary key default gen_random_uuid(),
  payment_id uuid not null references payments(id) on delete cascade,
  claim_id uuid not null references claims(id) on delete restrict,
  claim_line_item_id uuid references claim_line_items(id) on delete set null,

  allocated_amount numeric(10,2) not null,

  unique (payment_id, claim_line_item_id)
);

alter table payment_allocations enable row level security;

create policy "Staff can manage payment allocations at their facility"
  on payment_allocations for all
  using (
    payment_id in (
      select id from payments
      where practice_id in (
        select practice_id from staff
        where auth_user_id = auth.uid() and is_active = true
      )
    )
  );
