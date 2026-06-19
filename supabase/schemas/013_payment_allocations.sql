create table payment_allocations (
  id uuid primary key default gen_random_uuid(),
  payment_id uuid not null references payments(id) on delete cascade,
  claim_id uuid not null references claims(id) on delete restrict,
  claim_line_item_id uuid references claim_line_items(id) on delete set null,

  allocated_amount numeric(10,2) not null,

  unique (payment_id, claim_line_item_id)
);

alter table payment_allocations enable row level security;
