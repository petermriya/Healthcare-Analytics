WITH source AS (SELECT * FROM `healthcare-analytics-510014.Raw.raw_encounters`)
SELECT encounter_id,
patient_id,
provider_id,
department_id,
encounter_date,
TRIM(INITCAP(encounter_type)) AS encounter_type,
TRIM(INITCAP(status)) AS encounter_status,
admission_date,
discharge_date,
TRIM(chief_complaint) AS chief_complaint
FROM source




