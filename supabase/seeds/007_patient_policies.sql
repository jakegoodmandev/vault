-- Jane: Sun Life (primary health) + Aviva Canada (auto -- SABS coverage)
insert into patient_policies (id, patient_id, payer_id, policy_holder_first_name, policy_holder_last_name, relationship_to_patient, member_id, group_number, coverage_start_date, is_primary) values
  ('aa000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001', 'Jane',  'Smith',  'self',   'MEM001', 'GRP001', '2026-01-01', true),
  ('aa000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000002', 'Jane',  'Smith',  'self',   'POL-AVIVA-001', null,      '2026-01-01', false),
  -- Robert: OHIP (senior -- 18 visits/year)
  ('aa000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000003', 'Robert','Johnson', 'self',   'OHIP-1234-5678', null,      '2026-01-01', true),
  -- Maria: Canada Life group benefits
  ('aa000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000004', 'Maria', 'Garcia',  'self',   'MEM003', 'GRP003', '2026-01-01', true),
  -- David: Sun Life
  ('aa000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000004', 'b0000000-0000-0000-0000-000000000001', 'David', 'Chen',    'self',   'MEM004', 'GRP001', '2026-06-01', true);
