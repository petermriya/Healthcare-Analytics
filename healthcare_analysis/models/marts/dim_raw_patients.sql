WITH source AS (SELECT * FROM {{ref('stg_raw_patients')}})
SELECT county, gender, COUNT(patient_id) AS total_patients
FROM source
GROUP BY county, gender
ORDER BY total_patients DESC