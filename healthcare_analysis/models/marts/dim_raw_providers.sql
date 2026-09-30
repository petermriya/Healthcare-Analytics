WITH source AS (SELECT * FROM {{ref('stg_raw_providers')}})
SELECT specialty, COUNT(provider_name) AS total_providers
FROM source
GROUP BY specialty