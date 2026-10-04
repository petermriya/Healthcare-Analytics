WITH source AS(SELECT * FROM {{ ref('stg_raw_claims')}})
SELECT * FROM source