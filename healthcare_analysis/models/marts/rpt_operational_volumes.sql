SELECT COUNT(fae.encounter_id) AS total_encounters, drd.department_name, DATE_TRUNC(fae.encounter_date, month) AS encounter_month
FROM {{ref ('fct_all_encounters')}} AS fae
JOIN {{ref ('dim_raw_departments')}} AS drd
ON fae.department_id = drd.department_id
GROUP BY drd.department_name, encounter_month
ORDER BY total_encounters DESC
