create table "staff_workspace" (
  "id"              uuid not null primary key default gen_random_uuid(),
  "staff_id"        uuid references public.staff(id) on delete cascade,
  "workspace_id"    uuid references public.workspace(id) on delete cascade
);

alter table public.staff_workspace enable row level security;

create policy "Staff can see their own workspace memberships."
on staff_workspace
for select
to authenticated
using (
  exists (
    select 1
    from staff
    where staff.id = staff_id
    and staff.auth_user_id = auth.uid()
  )
);

grant select on public.staff_workspace to authenticated;
grant select, insert, update, delete ON public.staff_workspace to service_role;

create policy "Staff can see workspaces they belong to."
on workspace
for select
to authenticated
using (
  exists (
    select 1
    from staff_workspace sw
    join staff s on s.id = sw.staff_id
    where sw.workspace_id = public.workspace.id
    and s.auth_user_id = auth.uid()
  )
);
