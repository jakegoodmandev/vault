insert into public.workspace ("id", "name")
values ('00000000-0000-0000-0000-000000000000', 'Example Family Health');

insert into public.staff_workspace (staff_id, workspace_id)
select id, '00000000-0000-0000-0000-000000000000'
from public.staff;