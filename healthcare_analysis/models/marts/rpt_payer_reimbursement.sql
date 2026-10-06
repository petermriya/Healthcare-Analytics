--  What are billed, allowed, and paid totals by payer, and what is the paid-to-allowed ratio?

SELECT dp.payer_id, 
dp.payer_name, 
SUM(fc.billed_amount) AS total_billed,
SUM(fc.allowed_amount) AS total_allowed,
SUM(fc.paid_amount) AS total_paid,
ROUND(100.0 * SUM(fc.paid_amount)/NULLIF(SUM(fc.allowed_amount), 0), 2) AS paid_to_allowed_pct
FROM {{ ref('fct_raw_claims')}} AS fc
JOIN {{ ref('dim_raw_payers')}} AS dp   
ON dp.payer_id = fc.payer_id
WHERE fc.claim_status != 'Pending'
GROUP BY dp.payer_id, dp.payer_name
ORDER BY total_paid DESC
