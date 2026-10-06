
-- Paid revenue per encounter by department
SELECT
    d.department_name,
    SUM(fc.paid_amount) AS total_paid_revenue,
    COUNT(DISTINCT fc.encounter_id) AS total_encounters,
    ROUND(
        SUM(fc.paid_amount)
        / NULLIF(COUNT(DISTINCT fc.encounter_id), 0),
        2
    ) AS paid_revenue_per_encounter
FROM {{ ref('fct_raw_claims') }} AS fc
JOIN {{ ref('fct_all_encounters') }} AS e
    ON fc.encounter_id = e.encounter_id
JOIN {{ ref('dim_raw_departments') }} AS d
    ON e.department_id = d.department_id
WHERE fc.claim_status = 'Paid'
GROUP BY d.department_name
ORDER BY paid_revenue_per_encounter DESC