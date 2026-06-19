-- RLS policies for core tables created before staff existed.
-- Defined here so the staff table is available for subqueries.

create policy "Staff can view their practice"
  on practices for select
  using (
    id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );

create policy "Staff can view facilities at their practice"
  on facilities for select
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );

create policy "Staff can manage providers at their practice"
  on providers for all
  using (
    practice_id in (
      select practice_id from staff
      where auth_user_id = auth.uid() and is_active = true
    )
  );
