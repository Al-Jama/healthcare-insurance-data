# Sample Results – Healthcare Data Warehouse

After the pipeline runs, the silver and gold layers contain clean, structured data.  

### dim_patient (first 3 rows)

| patient_key | member_id   | first_name | last_name | dob        | gender |
|-------------|-------------|------------|-----------|------------|--------|
| 1           | MCR-MEM-150 | Patient_1  | Test      | 1980-01-01 | F      |
| 2           | MCR-MEM-175 | Patient_2  | Test      | 1975-06-10 | M      |
| 3           | MCD-MEM-105 | Patient_A  | Test      | 1990-02-20 | F      |

### dim_provider (first 3 rows)

| provider_key | provider_id |
|--------------|-------------|
| 1            | PROV-1      |
| 2            | PROV-3      |
| 3            | PROV-2      |

### fact_claims (first 3 rows)

| claim_id       | patient_key | provider_key | service_start | service_end | paid_amount | payer     | diagnosis_code |
|----------------|-------------|--------------|---------------|-------------|-------------|-----------|----------------|
| MCR-CLAIM-1001 | 1           | 1            | 2024-03-15    | 2024-03-20  | 2500.75     | Medicare  | D100           |
| MCR-CLAIM-1002 | 2           | 2            | 2024-04-01    | 2024-04-05  | 3200.00     | Medicare  | D205           |
| MCD-CLAIM-1001 | 3           | 3            | 2024-05-10    | 2024-05-10  | 450.00      | Medicaid  | D310           |


