--  Which procedures are most common on encounters with diabetes (E11.9) or hypertension (I10)

SELECT fae.procedure_id, 
fae.procedure_description, 
fed.diagnosis_category, 
fed.diagnosis_description, 
COUNT(DISTINCT fae.encounter_id) AS total_encounters
FROM {{ref('fct_all_encounters')}} AS fae
JOIN {{ref('fct_encounter_diagnoses')}} AS fed
ON fae.encounter_id = fed.encounter_id
WHERE fed.diagnosis_description IN ('Type 2 diabetes mellitus without complications', 'Essential (primary) hypertension')
GROUP BY fae.procedure_id, 
fae.procedure_description,
fed.diagnosis_category,
fed.diagnosis_description
ORDER BY total_encounters DESC