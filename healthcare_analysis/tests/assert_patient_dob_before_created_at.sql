SELECT date_of_birth, created_at
FROM {{ ref('stg_raw_patients')}}
WHERE date_of_birth >= created_at