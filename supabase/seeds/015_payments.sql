-- Payment for Scenario 1: Jane Smith (Aviva Canada -- SABS auto claim, bulk for both visits)
insert into payments (id, practice_id, payer_id, payment_amount, payment_date, payment_method, check_number, era_transaction_id, is_reconciled) values
  ('ae000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000002', 250.00, '2026-06-02', 'eft', 'AVIVA-EFT-0602', 'ERA-001', true);

-- Payment for Scenario 2: Robert Johnson (OHIP)
insert into payments (id, practice_id, payer_id, payment_amount, payment_date, payment_method, check_number, era_transaction_id, is_reconciled) values
  ('ae000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000003', 48.00, '2026-06-15', 'eft', 'OHIP-DD-0615', 'ERA-002', true);
