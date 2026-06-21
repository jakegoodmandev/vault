insert into auth.users (
  id, instance_id, aud, role, email,
  encrypted_password, email_confirmed_at,
  confirmation_token, email_change,
  email_change_token_new, recovery_token,
  raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at, confirmation_sent_at,
  is_sso_user, is_anonymous
) values (
  'ff000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'admin@mainstchiro.ca',
  crypt('password123', gen_salt('bf')),
  now(),
  '', '', '', '',
  '{"provider": "email"}',
  format('{"name": "%s %s"}', 'Sarah', 'Williams')::jsonb,
  now(), now(), now(),
  false, false
);
