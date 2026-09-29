WITH source AS (
    SELECT * FROM `healthcare-analytics-510014.Raw.raw_providers`
)
SELECT
    provider_id,
    concat(first_name, ' ', last_name) as provider_name,
    npi_number,
    trim(initcap(specialty)) as specialty,
    department_id,
    hire_date,
    is_active
FROM source
