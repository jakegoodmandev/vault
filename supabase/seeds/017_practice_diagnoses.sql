-- Activate all seeded diagnoses for Main Street Chiropractic Group
insert into practice_diagnoses (practice_id, diagnosis_id, is_active, is_favorite)
select 'd1000000-0000-0000-0000-000000000001', id, true, true
from diagnoses;
