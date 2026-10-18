WITH encounter_summary AS (    
    SELECT 
        d.department_name, 
        FORMAT_DATE('%A', CAST(fae.admission_date AS DATE)) AS day_of_week,
        COUNT(CASE 
                WHEN fae.encounter_status = 'No-Show' THEN 1 
              END) AS no_show_count,
        COUNT(fae.encounter_id) AS total_encounter_count
    FROM {{ ref('fct_all_encounters') }} AS fae
    JOIN {{ ref('dim_raw_departments') }} AS d    
        ON fae.department_id = d.department_id
    WHERE fae.encounter_status IN ('No-Show', 'Cancelled', 'Completed')
    GROUP BY d.department_name, day_of_week
)

SELECT 
    department_name,
    day_of_week,
    ROUND((no_show_count * 100.0 / NULLIF(total_encounter_count, 0)), 2)::NUMERIC AS no_show_rates
FROM encounter_summary
ORDER BY no_show_rates DESC
