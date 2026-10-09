SELECT provider_id
FROM {{ ref ('stg_raw_providers')}}
WHERE provider_id IS NULL