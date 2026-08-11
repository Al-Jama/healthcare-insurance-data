SELECT payer, SUM(paid_amount) AS total_paid
FROM fact_claims
GROUP BY payer;

SELECT p.first_name, p.last_name, COUNT(*) AS claim_count
FROM fact_claims f
JOIN dim_patient p ON f.patient_key = p.patient_key
GROUP BY p.first_name, p.last_name
ORDER BY claim_count DESC
LIMIT 5;
