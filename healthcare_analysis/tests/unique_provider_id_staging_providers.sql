SELECT COUNT(provider_id) AS number_of_ids, provider_name
FROM {{ ref('stg_raw_providers')}}
WHERE provider_id IS NOT NULL
GROUP BY provider_name
HAVING COUNT(provider_id) > 1