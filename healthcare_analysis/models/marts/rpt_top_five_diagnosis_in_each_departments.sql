WITH wide_department_counts AS (
    SELECT
        d.department_name, 
        COUNT(CASE WHEN ied.diagnosis_category = 'Endocrine' THEN 1 END) AS endocrine_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Circulatory' THEN 1 END) AS circulatory_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Respiratory' THEN 1 END) AS respiratory_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Symptoms' THEN 1 END) AS symptoms_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Injury' THEN 1 END) AS injury_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Digestive' THEN 1 END) AS digestive_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Pregnancy' THEN 1 END) AS pregnancy_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Wellness' THEN 1 END) AS wellness_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Mental Health' THEN 1 END) AS mental_health_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Musculoskeletal' THEN 1 END) AS musculoskeletal_count,
        COUNT(CASE WHEN ied.diagnosis_category = 'Genitourinary' THEN 1 END) AS genitourinary_count
    FROM {{ ref('int_encounter_diagnoses') }} AS ied
    JOIN {{ ref('dim_raw_departments') }} AS d
        ON ied.department_id = d.department_id
    GROUP BY d.department_name
),

long_department_counts AS (
    SELECT department_name, diagnosis_category, diagnosis_count
    FROM wide_department_counts
    UNPIVOT(diagnosis_count FOR diagnosis_category IN (
        endocrine_count AS 'Endocrine', circulatory_count AS 'Circulatory', 
        respiratory_count AS 'Respiratory', symptoms_count AS 'Symptoms', 
        injury_count AS 'Injury', digestive_count AS 'Digestive', 
        pregnancy_count AS 'Pregnancy', wellness_count AS 'Wellness', 
        mental_health_count AS 'Mental Health', musculoskeletal_count AS 'Musculoskeletal', 
        genitourinary_count AS 'Genitourinary'
    ))
)

SELECT 
    department_name,
    diagnosis_category,
    diagnosis_count
FROM long_department_counts
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY department_name 
    ORDER BY diagnosis_count DESC
) <= 5
ORDER BY department_name ASC, diagnosis_count DESC;
