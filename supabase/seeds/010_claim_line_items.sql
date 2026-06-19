-- Scenario 1: Jane Smith -- Visit 1 (Aviva SABS auto claim)
insert into claim_line_items (id, claim_id, line_number, procedure_code, service_date, diagnosis_pointer, charge_amount, unit_count, allowed_amount, paid_amount, status) values
  ('ac000000-0000-0000-0000-000000000001', 'ab000000-0000-0000-0000-000000000001', 1, '98941', '2026-05-16', '{1,2}',   85.00, 1, 70.00, 70.00, 'paid'),
  ('ac000000-0000-0000-0000-000000000002', 'ab000000-0000-0000-0000-000000000001', 2, '97110', '2026-05-16', '{3}',    35.00, 1, 28.00, 28.00, 'paid'),
  ('ac000000-0000-0000-0000-000000000003', 'ab000000-0000-0000-0000-000000000001', 3, '97035', '2026-05-16', '{3}',    60.00, 2, 47.00, 47.00, 'paid');

-- Scenario 1: Jane Smith -- Visit 2 (Aviva SABS auto claim)
insert into claim_line_items (id, claim_id, line_number, procedure_code, service_date, diagnosis_pointer, charge_amount, unit_count, allowed_amount, paid_amount, status) values
  ('ac000000-0000-0000-0000-000000000004', 'ab000000-0000-0000-0000-000000000002', 1, '98941', '2026-05-20', '{1,2}', 85.00, 1, 70.00, 70.00, 'paid'),
  ('ac000000-0000-0000-0000-000000000005', 'ab000000-0000-0000-0000-000000000002', 2, '97110', '2026-05-20', '{1}',   45.00, 1, 35.00, 35.00, 'paid');

-- Scenario 2: Robert Johnson OHIP (senior chiropractic visit)
insert into claim_line_items (id, claim_id, line_number, procedure_code, service_date, diagnosis_pointer, charge_amount, unit_count, allowed_amount, paid_amount, patient_responsibility, adjustment_amount, adjustment_reason_code, status) values
  ('ac000000-0000-0000-0000-000000000006', 'ab000000-0000-0000-0000-000000000003', 1, '98940', '2026-06-01', '{1,2}', 65.00, 1, 40.00, 32.00, 8.00, 25.00, 'CO-45', 'paid'),
  ('ac000000-0000-0000-0000-000000000007', 'ab000000-0000-0000-0000-000000000003', 2, '97035', '2026-06-01', '{2}',   30.00, 1, 20.00, 16.00, 4.00, 14.00, 'CO-45', 'paid');

-- Scenario 3: Maria Garcia Canada Life (denied -- plan max exceeded)
insert into claim_line_items (id, claim_id, line_number, procedure_code, service_date, diagnosis_pointer, charge_amount, unit_count, allowed_amount, paid_amount, status, denial_reason_code, denial_reason_description) values
  ('ac000000-0000-0000-0000-000000000008', 'ab000000-0000-0000-0000-000000000004', 1, '98941', '2026-06-10', '{1,2}', 85.00, 1, 0.00, 0.00, 'appealed', 'CL-30', 'Exceeded annual chiropractic maximum'),
  ('ac000000-0000-0000-0000-000000000009', 'ab000000-0000-0000-0000-000000000004', 2, '97140', '2026-06-10', '{2}',   45.00, 1, 0.00, 0.00, 'appealed', 'CL-30', 'Exceeded annual chiropractic maximum'),
  ('ac000000-0000-0000-0000-000000000010', 'ab000000-0000-0000-0000-000000000004', 3, '97035', '2026-06-10', '{2}',   40.00, 1, 0.00, 0.00, 'appealed', 'CL-30', 'Exceeded annual chiropractic maximum');

-- Scenario 4: David Chen Sun Life (draft)
insert into claim_line_items (id, claim_id, line_number, procedure_code, service_date, diagnosis_pointer, charge_amount, unit_count, status) values
  ('ac000000-0000-0000-0000-000000000011', 'ab000000-0000-0000-0000-000000000005', 1, '98941', '2026-06-18', '{1,2}', 85.00, 1, 'draft');
