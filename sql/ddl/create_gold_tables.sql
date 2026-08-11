CREATE TABLE dim_patient (
    patient_key INT IDENTITY(1,1) PRIMARY KEY,
    member_id VARCHAR(50) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    dob DATE,
    gender CHAR(1)
);

CREATE TABLE dim_provider (
    provider_key INT IDENTITY(1,1) PRIMARY KEY,
    provider_id VARCHAR(50) NOT NULL
);

CREATE TABLE fact_claims (
    claim_id VARCHAR(50) PRIMARY KEY,
    patient_key INT NOT NULL,
    provider_key INT NOT NULL,
    service_start DATE,
    service_end DATE,
    paid_amount DECIMAL(18,2),
    payer VARCHAR(20),
    diagnosis_code VARCHAR(20),
    FOREIGN KEY (patient_key) REFERENCES dim_patient(patient_key),
    FOREIGN KEY (provider_key) REFERENCES dim_provider(provider_key)
);
