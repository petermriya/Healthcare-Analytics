
-- What is the claim denial rate by payer and department?
WITH unique_encounter_departments AS (
    SELECT DISTINCT
        e.encounter_id,
        d.department_name
    FROM {{ ref('fct_all_encounters') }} AS e
    JOIN {{ ref('dim_raw_departments') }} AS d
        ON e.department_id = d.department_id
)

SELECT 
    p.payer_name,
    ed.department_name,
    COUNT(DISTINCT fc.claim_id) AS total_claims_submitted,
    COUNT(DISTINCT CASE WHEN fc.claim_status = 'Denied' THEN fc.claim_id END) AS total_denied_claims,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN fc.claim_status = 'Denied' THEN fc.claim_id END) 
        / NULLIF(COUNT(DISTINCT fc.claim_id), 0),
        2
    ) AS denial_rate_percentage
FROM {{ ref('fct_raw_claims') }} AS fc
INNER JOIN {{ ref('dim_raw_payers') }} AS p
    ON fc.payer_id = p.payer_id
INNER JOIN unique_encounter_departments AS ed
    ON fc.encounter_id = ed.encounter_id
GROUP BY
    p.payer_name,
    ed.department_name
ORDER BY
    denial_rate_percentage DESC
