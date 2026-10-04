WITH source AS (SELECT * FROM {{ref("int_all_encounters")}})
SELECT encounter_id, encounter_type, encounter_date,
encounter_status, patient_id, chief_complaint, admission_date,
discharge_date, procedure_id, procedure_code, procedure_description, 
performed_date, standard_charge, times_performed, provider_id, department_id
FROM source