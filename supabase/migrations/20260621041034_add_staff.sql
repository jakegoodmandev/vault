SET check_function_bodies = false;
CREATE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.staff (auth_user_id, email)
  values (new.id, new.email)
  on conflict (email)
  do update set auth_user_id = new.id;

  return new;
end;
$function$;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
CREATE TABLE public.staff (id uuid DEFAULT gen_random_uuid() NOT NULL, auth_user_id uuid, email text NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL);
ALTER TABLE public.staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.staff ADD CONSTRAINT staff_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;
ALTER TABLE public.staff ADD CONSTRAINT staff_email_key UNIQUE (email);
ALTER TABLE public.staff ADD CONSTRAINT staff_pkey PRIMARY KEY (id);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.staff TO anon;
GRANT ALL ON public.staff TO authenticated;
GRANT ALL ON public.staff TO service_role;
CREATE POLICY "Staff can see their own profile only." ON public.staff FOR SELECT TO authenticated USING (((auth.uid() IS NOT NULL) AND (auth.uid() = auth_user_id)));
