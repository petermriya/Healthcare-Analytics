WITH source AS(SELECT * FROM `healthcare-analytics-510014.Raw.raw_departments`)
SELECT department_id, 
TRIM(department_name) AS department_name, 
TRIM(location) AS location,
TRIM(department_type) AS department_type
FROM source