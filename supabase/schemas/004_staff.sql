create table staff (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique not null references auth.users(id) on delete cascade,
  practice_id uuid not null references practices(id) on delete restrict,
  default_facility_id uuid references facilities(id) on delete set null,
  role text not null check (role in ('admin', 'biller', 'provider', 'front_desk')),
  provider_id uuid references providers(id) on delete set null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table staff enable row level security;

create policy "Staff can view their own record"
  on staff for select
  using (auth_user_id = auth.uid());

create policy "Staff can view colleagues at their practice"
  on staff for select
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );
