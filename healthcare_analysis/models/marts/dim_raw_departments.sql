WITH source AS(SELECT * FROM{{ ref('stg_raw_departments')}})
SELECT * FROM source