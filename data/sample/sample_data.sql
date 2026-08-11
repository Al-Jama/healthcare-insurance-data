-- ============================================================
-- 1. Load  sample data 
-- ============================================================


WITH medicare_raw AS (
    SELECT * FROM (VALUES
        ('MCR-CLAIM-1001','MCR-MEM-150','Patient_1','Test','1980-01-01','F','2024-03-15','2024-03-20',2500.75,'D100','PROV-1'),
        ('MCR-CLAIM-1002','MCR-MEM-175','Patient_2','Test','1975-06-10','M','2024-04-01','2024-04-05',3200.00,'D205','PROV-3')
    ) AS t(claim_id,member_id,first_name,last_name,dob,gender,service_start,service_end,paid_amount,diagnosis_code,provider_id)
),
medicaid_raw AS (
    SELECT * FROM (VALUES
        ('MCD-CLAIM-1001','MCD-MEM-105','Patient_A','Test','1990-02-20','F','2024-05-10','2024-05-10',450.00,'D310','PROV-2'),
        ('MCD-CLAIM-1002','MCD-MEM-120','Patient_B','Test','2000-11-05','M','2024-06-01','2024-06-03',890.50,'D410','PROV-4')
    ) AS t(claim_id,member_id,first_name,last_name,dob,gender,service_start,service_end,paid_amount,diagnosis_code,provider_id)
),
commercial_raw AS (
    SELECT * FROM (VALUES
        ('COM-CLAIM-1001','COM-MEM-180','Patient_X','Test','1988-12-12','F','2024-07-01','2024-07-02',1100.00,'D500','PROV-5'),
        ('COM-CLAIM-1002','COM-MEM-190','Patient_Y','Test','1995-04-25','M','2024-08-01','2024-08-05',2100.25,'D610','PROV-6')
    ) AS t(claim_id,member_id,first_name,last_name,dob,gender,service_start,service_end,paid_amount,diagnosis_code,provider_id)
),
-- ============================================================
-- 2. Combine all raw claims into one staging table
-- ============================================================
staging AS (
    SELECT 'Medicare' AS payer, * FROM medicare_raw
    UNION ALL
    SELECT 'Medicaid' AS payer, * FROM medicaid_raw
    UNION ALL
    SELECT 'Commercial' AS payer, * FROM commercial_raw
),
-- ============================================================
-- 3. Populate dimension tables 
-- ============================================================

patient_dim AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY MIN(claim_id)) AS patient_key,
        member_id,
        first_name,
        last_name,
        dob,
        gender
    FROM staging
    GROUP BY member_id, first_name, last_name, dob, gender
),
provider_dim AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY provider_id) AS provider_key,
        provider_id
    FROM (SELECT DISTINCT provider_id FROM staging) p
),
-- ============================================================
-- 4. Create the fact table by joining to dimension keys
-- ============================================================
fact_claims AS (
    SELECT
        s.claim_id,
        p.patient_key,
        pr.provider_key,
        s.service_start,
        s.service_end,
        s.paid_amount,
        s.payer,
        s.diagnosis_code
    FROM staging s
    JOIN patient_dim p ON s.member_id = p.member_id
    JOIN provider_dim pr ON s.provider_id = pr.provider_id
)

-- ============================================================
-- 5. sample output views
-- ============================================================

-- === dim_patient (first 3 rows) ===
-- SELECT TOP 3 * FROM patient_dim ORDER BY patient_key;
/*
patient_key  member_id    first_name  last_name  dob        gender
1            MCR-MEM-150  Patient_1   Test       1980-01-01 F
2            MCR-MEM-175  Patient_2   Test       1975-06-10 M
3            MCD-MEM-105  Patient_A   Test       1990-02-20 F
*/

-- === dim_provider (first 3 rows) ===
-- SELECT TOP 3 * FROM provider_dim ORDER BY provider_key;
/*
provider_key  provider_id
1             PROV-1
2             PROV-3
3             PROV-2
*/

-- === fact_claims (first 3 rows) ===
-- SELECT TOP 3 * FROM fact_claims ORDER BY claim_id;
/*
claim_id        patient_key  provider_key  service_start  service_end  paid_amount  payer      diagnosis_code
MCR-CLAIM-1001  1            1             2024-03-15     2024-03-20    2500.75      Medicare   D100
MCR-CLAIM-1002  2            2             2024-04-01     2024-04-05    3200.00      Medicare   D205
MCD-CLAIM-1001  3            3             2024-05-10     2024-05-10    450.00       Medicaid   D310
*/

-- === Total paid amount by payer ===
-- SELECT payer, SUM(paid_amount) AS total_paid FROM fact_claims GROUP BY payer;
/*
payer      total_paid
Medicare   5700.75
Medicaid   1340.50
Commercial 3200.25
*/

