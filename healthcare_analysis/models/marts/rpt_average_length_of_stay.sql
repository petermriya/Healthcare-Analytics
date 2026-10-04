SELECT 
    DATE_TRUNC(encounter_date, month) AS encounter_month,
    AVG(DATE_DIFF(discharge_date, admission_date, DAY)) AS avg_length_of_stay
FROM {{ ref ('fct_all_encounters') }}
WHERE encounter_type = 'Emergency'
  AND discharge_date IS NOT NULL
  AND admission_date IS NOT NULL
GROUP BY encounter_month
ORDER BY encounter_month
