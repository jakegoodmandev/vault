CREATE TABLE public.claim_diagnoses (claim_id uuid NOT NULL, diagnosis_id uuid NOT NULL, diagnosis_order smallint NOT NULL);
ALTER TABLE public.claim_diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.claim_diagnoses ADD CONSTRAINT claim_diagnoses_claim_id_diagnosis_order_key UNIQUE (claim_id, diagnosis_order);
ALTER TABLE public.claim_diagnoses ADD CONSTRAINT claim_diagnoses_diagnosis_order_check CHECK (diagnosis_order >= 1 AND diagnosis_order <= 12);
ALTER TABLE public.claim_diagnoses ADD CONSTRAINT claim_diagnoses_pkey PRIMARY KEY (claim_id, diagnosis_id);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_diagnoses TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_diagnoses TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_diagnoses TO service_role;
CREATE TABLE public.claim_line_items (id uuid DEFAULT gen_random_uuid() NOT NULL, claim_id uuid NOT NULL, line_number smallint NOT NULL, procedure_code text NOT NULL, procedure_modifier_1 text, procedure_modifier_2 text, procedure_modifier_3 text, procedure_modifier_4 text, service_date date NOT NULL, place_of_service_code text, diagnosis_pointer smallint[], charge_amount numeric(10,2) NOT NULL, unit_count numeric(5,2) DEFAULT 1 NOT NULL, allowed_amount numeric(10,2) DEFAULT 0, paid_amount numeric(10,2) DEFAULT 0, patient_responsibility numeric(10,2) DEFAULT 0, adjustment_amount numeric(10,2) DEFAULT 0, adjustment_reason_code text, denial_reason_code text, denial_reason_description text, remark_code text, status text DEFAULT 'draft'::text NOT NULL);
ALTER TABLE public.claim_line_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.claim_line_items ADD CONSTRAINT claim_line_items_claim_id_line_number_key UNIQUE (claim_id, line_number);
ALTER TABLE public.claim_line_items ADD CONSTRAINT claim_line_items_pkey PRIMARY KEY (id);
ALTER TABLE public.claim_line_items ADD CONSTRAINT claim_line_items_status_check CHECK (status = ANY (ARRAY['draft'::text, 'submitted'::text, 'paid'::text, 'denied'::text, 'appealed'::text]));
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_line_items TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_line_items TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_line_items TO service_role;
CREATE INDEX idx_claim_line_items_claim ON public.claim_line_items (claim_id);
CREATE TABLE public.claim_status_history (id uuid DEFAULT gen_random_uuid() NOT NULL, claim_id uuid NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, status text NOT NULL, status_date date NOT NULL, status_code text, status_description text, changed_by uuid, notes text);
ALTER TABLE public.claim_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.claim_status_history ADD CONSTRAINT claim_status_history_pkey PRIMARY KEY (id);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_status_history TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_status_history TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claim_status_history TO service_role;
CREATE INDEX idx_claim_status_history_claim ON public.claim_status_history (claim_id);
CREATE TABLE public.claims (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, updated_at timestamp with time zone DEFAULT now() NOT NULL, patient_id uuid NOT NULL, patient_policy_id uuid, primary_provider_id uuid NOT NULL, facility_id uuid NOT NULL, referring_provider_id uuid, supervising_provider_id uuid, claim_number text, external_claim_id text, service_date_from date NOT NULL, service_date_to date NOT NULL, date_received date, place_of_service_code text DEFAULT '11'::text NOT NULL, accident_date date, accident_state text, accident_description text, is_auto_accident boolean DEFAULT false NOT NULL, total_billed_amount numeric(10,2) DEFAULT 0 NOT NULL, total_allowed_amount numeric(10,2) DEFAULT 0, total_paid_amount numeric(10,2) DEFAULT 0, total_patient_responsibility numeric(10,2) DEFAULT 0, total_adjustment_amount numeric(10,2) DEFAULT 0, balance_due numeric(10,2) DEFAULT 0, status text DEFAULT 'draft'::text NOT NULL, filing_indicator text, last_denial_reason text, appeal_date date, appeal_status text, billing_provider_id uuid, pay_to_provider_id uuid, notes text);
ALTER TABLE public.claims ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.claims ADD CONSTRAINT claims_pkey PRIMARY KEY (id);
ALTER TABLE public.claim_diagnoses ADD CONSTRAINT claim_diagnoses_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES public.claims(id) ON DELETE CASCADE;
ALTER TABLE public.claim_line_items ADD CONSTRAINT claim_line_items_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES public.claims(id) ON DELETE CASCADE;
ALTER TABLE public.claim_status_history ADD CONSTRAINT claim_status_history_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES public.claims(id) ON DELETE CASCADE;
ALTER TABLE public.claims ADD CONSTRAINT claims_status_check CHECK (status = ANY (ARRAY['draft'::text, 'ready'::text, 'submitted'::text, 'accepted'::text, 'partial_paid'::text, 'paid'::text, 'denied'::text, 'appealed'::text, 'closed'::text, 'void'::text]));
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claims TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claims TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.claims TO service_role;
CREATE INDEX idx_claims_status ON public.claims (status);
CREATE INDEX idx_claims_service_date ON public.claims (service_date_from, service_date_to);
CREATE INDEX idx_claims_patient ON public.claims (patient_id);
CREATE INDEX idx_claims_provider ON public.claims (primary_provider_id);
CREATE TABLE public.diagnoses (id uuid DEFAULT gen_random_uuid() NOT NULL, code text NOT NULL, description text NOT NULL, category text, is_active boolean DEFAULT true NOT NULL);
ALTER TABLE public.diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diagnoses ADD CONSTRAINT diagnoses_code_key UNIQUE (code);
ALTER TABLE public.diagnoses ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);
ALTER TABLE public.claim_diagnoses ADD CONSTRAINT claim_diagnoses_diagnosis_id_fkey FOREIGN KEY (diagnosis_id) REFERENCES public.diagnoses(id) ON DELETE RESTRICT;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.diagnoses TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.diagnoses TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.diagnoses TO service_role;
CREATE TABLE public.facilities (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, updated_at timestamp with time zone DEFAULT now() NOT NULL, practice_id uuid NOT NULL, name text NOT NULL, registration_number text, taxonomy_code text, address_line_1 text, address_line_2 text, city text, province text, postal_code text, phone text, place_of_service_code text DEFAULT '11'::text, is_active boolean DEFAULT true NOT NULL);
ALTER TABLE public.facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.facilities ADD CONSTRAINT facilities_pkey PRIMARY KEY (id);
ALTER TABLE public.claims ADD CONSTRAINT claims_facility_id_fkey FOREIGN KEY (facility_id) REFERENCES public.facilities(id) ON DELETE RESTRICT;
ALTER TABLE public.facilities ADD CONSTRAINT facilities_registration_number_key UNIQUE (registration_number);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.facilities TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.facilities TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.facilities TO service_role;
CREATE INDEX idx_facilities_practice ON public.facilities (practice_id);
CREATE TABLE public.patient_policies (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, updated_at timestamp with time zone DEFAULT now() NOT NULL, patient_id uuid NOT NULL, payer_id uuid NOT NULL, policy_holder_first_name text NOT NULL, policy_holder_last_name text NOT NULL, policy_holder_date_of_birth date, relationship_to_patient text, member_id text NOT NULL, group_number text, policy_number text, coverage_start_date date, coverage_end_date date, is_primary boolean DEFAULT true NOT NULL, copay_amount numeric(10,2), deductible_amount numeric(10,2), deductible_met numeric(10,2), notes text);
ALTER TABLE public.patient_policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.patient_policies ADD CONSTRAINT patient_policies_pkey PRIMARY KEY (id);
ALTER TABLE public.claims ADD CONSTRAINT claims_patient_policy_id_fkey FOREIGN KEY (patient_policy_id) REFERENCES public.patient_policies(id) ON DELETE RESTRICT;
ALTER TABLE public.patient_policies ADD CONSTRAINT patient_policies_relationship_to_patient_check CHECK (relationship_to_patient = ANY (ARRAY['self'::text, 'spouse'::text, 'child'::text, 'parent'::text, 'other'::text]));
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.patient_policies TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.patient_policies TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.patient_policies TO service_role;
CREATE INDEX idx_patient_policies_payer ON public.patient_policies (payer_id);
CREATE INDEX idx_patient_policies_patient ON public.patient_policies (patient_id);
CREATE TABLE public.patients (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, updated_at timestamp with time zone DEFAULT now() NOT NULL, practice_id uuid NOT NULL, default_facility_id uuid, first_name text NOT NULL, last_name text NOT NULL, date_of_birth date NOT NULL, gender text, sin_last_four text, address_line_1 text, address_line_2 text, city text, province text, postal_code text, phone text, email text, patient_external_id text, is_active boolean DEFAULT true NOT NULL, notes text);
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.patients ADD CONSTRAINT patients_default_facility_id_fkey FOREIGN KEY (default_facility_id) REFERENCES public.facilities(id) ON DELETE SET NULL;
ALTER TABLE public.patients ADD CONSTRAINT patients_gender_check CHECK (gender = ANY (ARRAY['male'::text, 'female'::text, 'other'::text, 'unknown'::text]));
ALTER TABLE public.patients ADD CONSTRAINT patients_pkey PRIMARY KEY (id);
ALTER TABLE public.claims ADD CONSTRAINT claims_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE RESTRICT;
ALTER TABLE public.patient_policies ADD CONSTRAINT patient_policies_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.patients TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.patients TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.patients TO service_role;
CREATE INDEX idx_patients_name ON public.patients (last_name, first_name);
CREATE INDEX idx_patients_active ON public.patients (is_active);
CREATE INDEX idx_patients_practice ON public.patients (practice_id);
CREATE TABLE public.payers (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, updated_at timestamp with time zone DEFAULT now() NOT NULL, practice_id uuid NOT NULL, name text NOT NULL, payer_id text, address_line_1 text, address_line_2 text, city text, province text, postal_code text, phone text, website text, payer_type text, is_active boolean DEFAULT true NOT NULL);
ALTER TABLE public.payers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payers ADD CONSTRAINT payers_payer_type_check CHECK (payer_type = ANY (ARRAY['commercial'::text, 'government'::text, 'auto'::text, 'wsib'::text, 'other'::text]));
ALTER TABLE public.payers ADD CONSTRAINT payers_pkey PRIMARY KEY (id);
ALTER TABLE public.patient_policies ADD CONSTRAINT patient_policies_payer_id_fkey FOREIGN KEY (payer_id) REFERENCES public.payers(id) ON DELETE RESTRICT;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payers TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payers TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payers TO service_role;
CREATE INDEX idx_payers_practice ON public.payers (practice_id);
CREATE TABLE public.payment_allocations (id uuid DEFAULT gen_random_uuid() NOT NULL, payment_id uuid NOT NULL, claim_id uuid NOT NULL, claim_line_item_id uuid, allocated_amount numeric(10,2) NOT NULL);
ALTER TABLE public.payment_allocations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES public.claims(id) ON DELETE RESTRICT;
ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_claim_line_item_id_fkey FOREIGN KEY (claim_line_item_id) REFERENCES public.claim_line_items(id) ON DELETE SET NULL;
ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_payment_id_claim_line_item_id_key UNIQUE (payment_id, claim_line_item_id);
ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_pkey PRIMARY KEY (id);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payment_allocations TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payment_allocations TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payment_allocations TO service_role;
CREATE TABLE public.payments (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, practice_id uuid NOT NULL, payer_id uuid NOT NULL, claim_id uuid, payment_amount numeric(10,2) NOT NULL, payment_date date NOT NULL, payment_method text, check_number text, check_date date, era_transaction_id text, era_file_name text, is_reconciled boolean DEFAULT false NOT NULL, notes text);
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ADD CONSTRAINT payments_claim_id_fkey FOREIGN KEY (claim_id) REFERENCES public.claims(id) ON DELETE SET NULL;
ALTER TABLE public.payments ADD CONSTRAINT payments_payer_id_fkey FOREIGN KEY (payer_id) REFERENCES public.payers(id) ON DELETE RESTRICT;
ALTER TABLE public.payments ADD CONSTRAINT payments_payment_method_check CHECK (payment_method = ANY (ARRAY['check'::text, 'eft'::text, 'credit_card'::text, 'cash'::text, 'other'::text]));
ALTER TABLE public.payments ADD CONSTRAINT payments_pkey PRIMARY KEY (id);
ALTER TABLE public.payment_allocations ADD CONSTRAINT payment_allocations_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(id) ON DELETE CASCADE;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payments TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payments TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.payments TO service_role;
CREATE INDEX idx_payments_claim ON public.payments (claim_id);
CREATE INDEX idx_payments_payer ON public.payments (payer_id);
CREATE INDEX idx_payments_practice ON public.payments (practice_id);
CREATE TABLE public.practice_diagnoses (practice_id uuid NOT NULL, diagnosis_id uuid NOT NULL, is_active boolean DEFAULT true NOT NULL, is_favorite boolean DEFAULT false NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL);
ALTER TABLE public.practice_diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_diagnoses ADD CONSTRAINT practice_diagnoses_diagnosis_id_fkey FOREIGN KEY (diagnosis_id) REFERENCES public.diagnoses(id) ON DELETE CASCADE;
ALTER TABLE public.practice_diagnoses ADD CONSTRAINT practice_diagnoses_pkey PRIMARY KEY (practice_id, diagnosis_id);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practice_diagnoses TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practice_diagnoses TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practice_diagnoses TO service_role;
CREATE TABLE public.practice_procedure_pricing (practice_id uuid NOT NULL, procedure_id uuid NOT NULL, custom_charge numeric(10,2), is_active boolean DEFAULT true NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL);
ALTER TABLE public.practice_procedure_pricing ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_procedure_pricing ADD CONSTRAINT practice_procedure_pricing_pkey PRIMARY KEY (practice_id, procedure_id);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practice_procedure_pricing TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practice_procedure_pricing TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practice_procedure_pricing TO service_role;
CREATE TABLE public.practices (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, updated_at timestamp with time zone DEFAULT now() NOT NULL, name text NOT NULL, registration_number text, taxonomy_code text, address_line_1 text, address_line_2 text, city text, province text, postal_code text, phone text, is_active boolean DEFAULT true NOT NULL);
ALTER TABLE public.practices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practices ADD CONSTRAINT practices_pkey PRIMARY KEY (id);
ALTER TABLE public.facilities ADD CONSTRAINT facilities_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE RESTRICT;
ALTER TABLE public.patients ADD CONSTRAINT patients_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE RESTRICT;
ALTER TABLE public.payers ADD CONSTRAINT payers_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE RESTRICT;
ALTER TABLE public.payments ADD CONSTRAINT payments_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE RESTRICT;
ALTER TABLE public.practice_diagnoses ADD CONSTRAINT practice_diagnoses_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE CASCADE;
ALTER TABLE public.practice_procedure_pricing ADD CONSTRAINT practice_procedure_pricing_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE CASCADE;
ALTER TABLE public.practices ADD CONSTRAINT practices_registration_number_key UNIQUE (registration_number);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practices TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practices TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.practices TO service_role;
CREATE TABLE public.procedures (id uuid DEFAULT gen_random_uuid() NOT NULL, code text NOT NULL, description text NOT NULL, category text, default_charge numeric(10,2), is_active boolean DEFAULT true NOT NULL);
ALTER TABLE public.procedures ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.procedures ADD CONSTRAINT procedures_code_key UNIQUE (code);
ALTER TABLE public.procedures ADD CONSTRAINT procedures_pkey PRIMARY KEY (id);
ALTER TABLE public.practice_procedure_pricing ADD CONSTRAINT practice_procedure_pricing_procedure_id_fkey FOREIGN KEY (procedure_id) REFERENCES public.procedures(id) ON DELETE CASCADE;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.procedures TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.procedures TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.procedures TO service_role;
CREATE TABLE public.providers (id uuid DEFAULT gen_random_uuid() NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL, updated_at timestamp with time zone DEFAULT now() NOT NULL, practice_id uuid NOT NULL, default_facility_id uuid, registration_number text NOT NULL, first_name text NOT NULL, last_name text NOT NULL, credentials text, taxonomy_code text, address_line_1 text, address_line_2 text, city text, province text, postal_code text, phone text, email text, is_active boolean DEFAULT true NOT NULL);
ALTER TABLE public.providers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.providers ADD CONSTRAINT providers_default_facility_id_fkey FOREIGN KEY (default_facility_id) REFERENCES public.facilities(id) ON DELETE SET NULL;
ALTER TABLE public.providers ADD CONSTRAINT providers_pkey PRIMARY KEY (id);
ALTER TABLE public.claims ADD CONSTRAINT claims_billing_provider_id_fkey FOREIGN KEY (billing_provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;
ALTER TABLE public.claims ADD CONSTRAINT claims_pay_to_provider_id_fkey FOREIGN KEY (pay_to_provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;
ALTER TABLE public.claims ADD CONSTRAINT claims_primary_provider_id_fkey FOREIGN KEY (primary_provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;
ALTER TABLE public.claims ADD CONSTRAINT claims_referring_provider_id_fkey FOREIGN KEY (referring_provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;
ALTER TABLE public.claims ADD CONSTRAINT claims_supervising_provider_id_fkey FOREIGN KEY (supervising_provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;
ALTER TABLE public.providers ADD CONSTRAINT providers_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE RESTRICT;
ALTER TABLE public.providers ADD CONSTRAINT providers_registration_number_key UNIQUE (registration_number);
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.providers TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.providers TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.providers TO service_role;
CREATE INDEX idx_providers_practice ON public.providers (practice_id);
CREATE TABLE public.staff (id uuid DEFAULT gen_random_uuid() NOT NULL, auth_user_id uuid NOT NULL, practice_id uuid NOT NULL, default_facility_id uuid, role text NOT NULL, provider_id uuid, is_active boolean DEFAULT true NOT NULL, created_at timestamp with time zone DEFAULT now() NOT NULL);
CREATE POLICY "Staff can manage claim diagnoses at their facility" ON public.claim_diagnoses USING ((claim_id IN ( SELECT c.id
   FROM ((public.claims c
     JOIN public.facilities f ON ((f.id = c.facility_id)))
     JOIN public.staff s ON ((s.practice_id = f.practice_id)))
  WHERE ((s.auth_user_id = auth.uid()) AND (s.is_active = true)))));
CREATE POLICY "Staff can manage line items at their facility" ON public.claim_line_items USING ((claim_id IN ( SELECT c.id
   FROM ((public.claims c
     JOIN public.facilities f ON ((f.id = c.facility_id)))
     JOIN public.staff s ON ((s.practice_id = f.practice_id)))
  WHERE ((s.auth_user_id = auth.uid()) AND (s.is_active = true)))));
CREATE POLICY "Staff can manage status history at their facility" ON public.claim_status_history USING ((claim_id IN ( SELECT c.id
   FROM ((public.claims c
     JOIN public.facilities f ON ((f.id = c.facility_id)))
     JOIN public.staff s ON ((s.practice_id = f.practice_id)))
  WHERE ((s.auth_user_id = auth.uid()) AND (s.is_active = true)))));
CREATE POLICY "Staff can manage claims at their facility" ON public.claims USING ((facility_id IN ( SELECT f.id
   FROM (public.facilities f
     JOIN public.staff s ON ((s.practice_id = f.practice_id)))
  WHERE ((s.auth_user_id = auth.uid()) AND (s.is_active = true)))));
CREATE POLICY "Staff can read diagnoses" ON public.diagnoses FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can view facilities at their practice" ON public.facilities FOR SELECT USING ((practice_id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can manage patient policies at their practice" ON public.patient_policies USING ((patient_id IN ( SELECT patients.id
   FROM public.patients
  WHERE (patients.practice_id IN ( SELECT staff.practice_id
           FROM public.staff
          WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))))));
CREATE POLICY "Staff can manage patients at their practice" ON public.patients USING ((practice_id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can manage payers at their practice" ON public.payers USING ((practice_id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can manage payment allocations at their facility" ON public.payment_allocations USING ((payment_id IN ( SELECT payments.id
   FROM public.payments
  WHERE (payments.practice_id IN ( SELECT staff.practice_id
           FROM public.staff
          WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))))));
CREATE POLICY "Staff can manage payments at their practice" ON public.payments USING ((practice_id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can manage practice diagnoses" ON public.practice_diagnoses USING ((practice_id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can manage procedure pricing" ON public.practice_procedure_pricing USING ((practice_id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can view their practice" ON public.practices FOR SELECT USING ((id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can read procedures" ON public.procedures FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
CREATE POLICY "Staff can manage providers at their practice" ON public.providers USING ((practice_id IN ( SELECT staff.practice_id
   FROM public.staff
  WHERE ((staff.auth_user_id = auth.uid()) AND (staff.is_active = true)))));
ALTER TABLE public.staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.staff ADD CONSTRAINT staff_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE public.staff ADD CONSTRAINT staff_auth_user_id_key UNIQUE (auth_user_id);
ALTER TABLE public.staff ADD CONSTRAINT staff_default_facility_id_fkey FOREIGN KEY (default_facility_id) REFERENCES public.facilities(id) ON DELETE SET NULL;
ALTER TABLE public.staff ADD CONSTRAINT staff_pkey PRIMARY KEY (id);
ALTER TABLE public.staff ADD CONSTRAINT staff_practice_id_fkey FOREIGN KEY (practice_id) REFERENCES public.practices(id) ON DELETE RESTRICT;
ALTER TABLE public.staff ADD CONSTRAINT staff_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE SET NULL;
ALTER TABLE public.staff ADD CONSTRAINT staff_role_check CHECK (role = ANY (ARRAY['admin'::text, 'biller'::text, 'provider'::text, 'front_desk'::text]));
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.staff TO anon;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.staff TO authenticated;
GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON public.staff TO service_role;
CREATE POLICY "Staff can view colleagues at their practice" ON public.staff FOR SELECT USING ((practice_id IN ( SELECT staff_1.practice_id
   FROM public.staff staff_1
  WHERE ((staff_1.auth_user_id = auth.uid()) AND (staff_1.is_active = true)))));
CREATE POLICY "Staff can view their own record" ON public.staff FOR SELECT USING ((auth_user_id = auth.uid()));
