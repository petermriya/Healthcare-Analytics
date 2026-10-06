-- Which denial reasons occur most often?

SELECT
    CASE
        WHEN fc.denial_reason IS NULL OR TRIM(fc.denial_reason) = '' THEN 'Unknown / Unspecified'
        ELSE fc.denial_reason
    END AS clean_denial_reason,
    COUNT(DISTINCT fc.claim_id) AS total_denied_claims
    FROM {{ ref('fct_raw_claims') }} AS fc
    WHERE fc.claim_status = 'Denied'
    GROUP BY clean_denial_reason
    ORDER BY total_denied_claims DESC