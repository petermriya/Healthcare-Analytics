# Healthcare Analytics with dbt + BigQuery

An end-to-end analytics engineering project that turns ten messy, raw clinic EHR and billing tables into a tested star schema on BigQuery, then automates builds with GitHub Actions.

## Goal

Practise a production-style dbt workflow: staging, intermediate and mart layers, tests, macros, documentation and CI/CD. The marts are designed to answer operational, clinical and financial questions about encounters, diagnoses, procedures and claims.

## Stack

dbt Core (`dbt-bigquery`) · Google BigQuery · GitHub Actions · VS Code

## Data

Ten raw CSVs loaded into a BigQuery `Raw` dataset and referenced with `source()`:

| Group | Tables |
|---|---|
| Reference | `raw_departments`, `raw_payers`, `raw_procedures`, `raw_diagnosis_codes` |
| Entities | `raw_patients`, `raw_providers` |
| Transactions | `raw_encounters`, `raw_claims` |
| Bridges | `raw_encounter_diagnoses`, `raw_encounter_procedures` |

The data is synthetic and deliberately dirty so the staging layer has real cleaning to do.

## Project structure

```
healthcare_analysis/
  models/
    staging/         one view per raw table, 1:1, no joins
    intermediate/    joins and business logic
    marts/           dim_ and fact_ tables (star schema)
  macros/            reusable SQL (status cleanup, date parsing, rates)
  tests/             singular tests for business rules
  analyses/          answers to the business questions
```

## Data quality decisions

| Issue in raw data | How it is handled |
|---|---|
| Duplicate patient row | Deduplicated on `patient_id` in staging |
| Dates of birth in two formats | Parsed with both `YYYY-MM-DD` and `MM/DD/YYYY` |
| Six gender labels (M, m, Male, F, f, Female) | Mapped to `M` / `F` / `U` |
| Mixed casing in status, type, specialty and state columns | Standardised in staging |
| Pending claims with blank amounts | Kept as NULL and flagged, not dropped |
| A claim where paid amount exceeds billed | Kept visible, flagged, and caught by a singular test |
| Denied claims with no denial reason | Flagged by a singular test |

## Business questions

Ten questions are answered from the marts only (see `analyses/`), including readmission-style volume trends, length of stay, top diagnoses, payer reimbursement and denial rates, revenue versus standard charges, and pending claim exposure.

## Setup

1. Install Python 3.11+ and create a virtual environment.
2. Install dbt: `pip install dbt-bigquery`
3. Install the Google Cloud CLI, then run `gcloud auth application-default login`
4. Load the CSVs into BigQuery:
   ```
   bq load --autodetect --skip_leading_rows=1 --source_format=CSV Raw.raw_patients ./raw_patients.csv
   ```
   Repeat for each file.
5. Create `~/.dbt/profiles.yml` with a BigQuery profile using `method: oauth`, your project ID, and a dev dataset.
6. From the `healthcare_analysis` folder, run:
   ```
   dbt deps
   dbt build
   dbt docs generate && dbt docs serve
   ```

## CI/CD

- **Pull requests:** GitHub Actions builds and tests into a temporary dataset, then drops it.
- **Main and nightly:** builds against the production target and uploads dbt artifacts.

## Status

- [x] Staging models
- [ ] Intermediate models
- [ ] Star schema marts with tests
- [ ] Macros
- [ ] Business question analyses
- [ ] GitHub Actions CI and scheduled runs
- [ ] Snapshot on `dim_patient`