-- Scenario 1: Jane Smith auto accident -- Visit 1 (paid via Aviva SABS)
insert into claims (id, patient_id, patient_policy_id, primary_provider_id, facility_id,
    claim_number, service_date_from, service_date_to, place_of_service_code,
    is_auto_accident, accident_date, accident_state, accident_description,
    total_billed_amount, total_allowed_amount, total_paid_amount, balance_due,
    filing_indicator, status, external_claim_id) values
  ('ab000000-0000-0000-0000-000000000001',
   'a0000000-0000-0000-0000-000000000001',
   'aa000000-0000-0000-0000-000000000002',
   'c0000000-0000-0000-0000-000000000001',
   'd0000000-0000-0000-0000-000000000001',
   'CLM-2026-0001',
   '2026-05-16', '2026-05-16', '11',
   true, '2026-05-15', 'ON', 'Rear-end collision on Hwy 401 westbound near Yonge St',
   180.00, 145.00, 145.00, 0.00,
   'CI', 'paid', 'AVIVA-PAID-001');

-- Scenario 1: Jane Smith auto accident -- Visit 2 (paid via Aviva SABS)
insert into claims (id, patient_id, patient_policy_id, primary_provider_id, facility_id,
    claim_number, service_date_from, service_date_to, place_of_service_code,
    is_auto_accident, accident_date, accident_state, accident_description,
    total_billed_amount, total_allowed_amount, total_paid_amount, balance_due,
    filing_indicator, status, external_claim_id) values
  ('ab000000-0000-0000-0000-000000000002',
   'a0000000-0000-0000-0000-000000000001',
   'aa000000-0000-0000-0000-000000000002',
   'c0000000-0000-0000-0000-000000000001',
   'd0000000-0000-0000-0000-000000000001',
   'CLM-2026-0002',
   '2026-05-20', '2026-05-20', '11',
   true, '2026-05-15', 'ON', 'Rear-end collision on Hwy 401 westbound near Yonge St',
   130.00, 105.00, 105.00, 0.00,
   'CI', 'paid', 'AVIVA-PAID-002');

-- Scenario 2: Robert Johnson OHIP (paid -- senior chiropractic coverage)
insert into claims (id, patient_id, patient_policy_id, primary_provider_id, facility_id,
    claim_number, service_date_from, service_date_to, place_of_service_code,
    total_billed_amount, total_allowed_amount, total_paid_amount, balance_due,
    filing_indicator, status, external_claim_id) values
  ('ab000000-0000-0000-0000-000000000003',
   'a0000000-0000-0000-0000-000000000002',
   'aa000000-0000-0000-0000-000000000003',
   'c0000000-0000-0000-0000-000000000001',
   'd0000000-0000-0000-0000-000000000001',
   'CLM-2026-0003',
   '2026-06-01', '2026-06-01', '11',
   95.00, 60.00, 48.00, 0.00,
   'MC', 'paid', 'OHIP-REF-001');

-- Scenario 3: Maria Garcia Canada Life (denied -> appealed)
insert into claims (id, patient_id, patient_policy_id, primary_provider_id, facility_id,
    claim_number, service_date_from, service_date_to, place_of_service_code,
    total_billed_amount, total_allowed_amount, total_paid_amount, balance_due,
    filing_indicator, status, last_denial_reason, appeal_date, appeal_status) values
  ('ab000000-0000-0000-0000-000000000004',
   'a0000000-0000-0000-0000-000000000003',
   'aa000000-0000-0000-0000-000000000004',
   'c0000000-0000-0000-0000-000000000002',
   'd0000000-0000-0000-0000-000000000001',
   'CLM-2026-0004',
   '2026-06-10', '2026-06-10', '11',
   170.00, 0.00, 0.00, 170.00,
   'CI', 'appealed', 'Exceeded annual chiropractic maximum -- $500/yr plan limit', '2026-07-01', 'pending');

-- Scenario 4: David Chen Sun Life (draft)
insert into claims (id, patient_id, patient_policy_id, primary_provider_id, facility_id,
    claim_number, service_date_from, service_date_to, place_of_service_code,
    total_billed_amount, total_allowed_amount, total_paid_amount, balance_due,
    filing_indicator, status) values
  ('ab000000-0000-0000-0000-000000000005',
   'a0000000-0000-0000-0000-000000000004',
   'aa000000-0000-0000-0000-000000000005',
   'c0000000-0000-0000-0000-000000000001',
   'd0000000-0000-0000-0000-000000000001',
   'CLM-2026-0005',
   '2026-06-18', '2026-06-18', '11',
   85.00, 0.00, 0.00, 85.00,
   'CI', 'draft');
