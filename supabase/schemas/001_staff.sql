create table "staff" (
  "id"              uuid not null primary key default gen_random_uuid(),
  "auth_user_id"    uuid references auth.users(id) on delete set null,
  "email"           text not null unique,
  "created_at"      timestamptz not null default now()
);

alter table public.staff enable row level security;

create policy "Staff can see their own profile only."
on staff
for select 
to authenticated
using (auth.uid() is not null and auth.uid() = auth_user_id);

grant select on public.staff to authenticated;
grant select, insert, update, delete ON public.staff to service_role;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.staff (auth_user_id, email)
  values (new.id, new.email)
  on conflict (email)
  do update set auth_user_id = new.id;

  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();
