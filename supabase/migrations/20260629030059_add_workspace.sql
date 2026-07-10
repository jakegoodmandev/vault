CREATE TABLE public.staff_workspace (id uuid DEFAULT gen_random_uuid() NOT NULL, staff_id uuid, workspace_id uuid);
ALTER TABLE public.staff_workspace ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.staff_workspace ADD CONSTRAINT staff_workspace_pkey PRIMARY KEY (id);
ALTER TABLE public.staff_workspace ADD CONSTRAINT staff_workspace_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(id) ON DELETE CASCADE;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.staff_workspace TO anon;
GRANT MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON public.staff_workspace TO authenticated;
GRANT ALL ON public.staff_workspace TO service_role;
CREATE POLICY "Staff can see their own workspace memberships." ON public.staff_workspace FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.staff
  WHERE ((staff.id = staff_workspace.staff_id) AND (staff.auth_user_id = auth.uid())))));
CREATE TABLE public.workspace (id uuid DEFAULT gen_random_uuid() NOT NULL, name text NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL);
ALTER TABLE public.workspace ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace ADD CONSTRAINT workspace_pkey PRIMARY KEY (id);
ALTER TABLE public.staff_workspace ADD CONSTRAINT staff_workspace_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspace(id) ON DELETE CASCADE;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.workspace TO anon;
GRANT MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON public.workspace TO authenticated;
GRANT ALL ON public.workspace TO service_role;
CREATE POLICY "Staff can see workspaces they belong to." ON public.workspace FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.staff_workspace sw
     JOIN public.staff s ON ((s.id = sw.staff_id)))
  WHERE ((sw.workspace_id = workspace.id) AND (s.auth_user_id = auth.uid())))));
