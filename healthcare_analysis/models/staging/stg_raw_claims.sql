WITH source AS(SELECT * FROM `healthcare-analytics-510014.Raw.raw_claims`)
SELECT
claim_id,
encounter_id,
payer_id, 
claim_date,
billed_amount, 
allowed_amount,
paid_amount,
TRIM(INITCAP(claim_status)) AS claim_status,
TRIM(denial_reason) AS denial_reason
FROM source
