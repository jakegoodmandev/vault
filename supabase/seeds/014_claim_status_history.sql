-- Scenario 1: Jane Smith -- Visit 1 (Aviva SABS)
insert into claim_status_history (id, claim_id, status, status_date, status_code, status_description) values
  ('ad000000-0000-0000-0000-000000000001', 'ab000000-0000-0000-0000-000000000001', 'draft',    '2026-05-16', null,        'Claim created'),
  ('ad000000-0000-0000-0000-000000000002', 'ab000000-0000-0000-0000-000000000001', 'submitted','2026-05-17', null,        'Submitted electronically via HCAI'),
  ('ad000000-0000-0000-0000-000000000003', 'ab000000-0000-0000-0000-000000000001', 'paid',     '2026-05-30', null,        'Payment received under SABS medical benefit');

-- Scenario 1: Jane Smith -- Visit 2 (Aviva SABS)
insert into claim_status_history (id, claim_id, status, status_date, status_code, status_description) values
  ('ad000000-0000-0000-0000-000000000004', 'ab000000-0000-0000-0000-000000000002', 'draft',    '2026-05-20', null,    'Claim created'),
  ('ad000000-0000-0000-0000-000000000005', 'ab000000-0000-0000-0000-000000000002', 'submitted','2026-05-21', null,    'Submitted electronically via HCAI'),
  ('ad000000-0000-0000-0000-000000000006', 'ab000000-0000-0000-0000-000000000002', 'paid',     '2026-06-02', null,    'Payment received');

-- Scenario 2: Robert Johnson OHIP
insert into claim_status_history (id, claim_id, status, status_date, status_code, status_description) values
  ('ad000000-0000-0000-0000-000000000007', 'ab000000-0000-0000-0000-000000000003', 'draft',    '2026-06-01', null,    'Claim created'),
  ('ad000000-0000-0000-0000-000000000008', 'ab000000-0000-0000-0000-000000000003', 'submitted','2026-06-01', null,    'Submitted via OHIP teleplan'),
  ('ad000000-0000-0000-0000-000000000009', 'ab000000-0000-0000-0000-000000000003', 'paid',     '2026-06-15', null,    'Direct deposit received (patient portion billed separately)');

-- Scenario 3: Maria Garcia Canada Life
insert into claim_status_history (id, claim_id, status, status_date, status_code, status_description) values
  ('ad000000-0000-0000-0000-000000000010', 'ab000000-0000-0000-0000-000000000004', 'draft',    '2026-06-10', null,      'Claim created'),
  ('ad000000-0000-0000-0000-000000000011', 'ab000000-0000-0000-0000-000000000004', 'submitted','2026-06-11', null,      'Submitted electronically'),
  ('ad000000-0000-0000-0000-000000000012', 'ab000000-0000-0000-0000-000000000004', 'denied',   '2026-06-25', 'CL-30',  'Exceeded annual chiropractic maximum ($500 limit)'),
  ('ad000000-0000-0000-0000-000000000013', 'ab000000-0000-0000-0000-000000000004', 'appealed', '2026-07-01', null,      'Appeal filed -- requesting medical exception for extended benefits');

-- Scenario 4: David Chen Sun Life (draft)
insert into claim_status_history (id, claim_id, status, status_date, status_description) values
  ('ad000000-0000-0000-0000-000000000014', 'ab000000-0000-0000-0000-000000000005', 'draft', '2026-06-18', 'Claim created -- awaiting review');
