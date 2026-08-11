# Databricks notebook source
# 02_silver_to_gold: Create dimensions and fact, write to SQL DB

from pyspark.sql.functions import monotonically_increasing_id, col

silver_path = "abfss://silver@yourstorageaccount.dfs.core.windows.net/claims/"
claims_df = spark.read.parquet(silver_path)

patient_dim = claims_df.select("member_id", "first_name", "last_name", "dob", "gender") \
                       .dropDuplicates(["member_id"])
patient_dim = patient_dim.withColumn("patient_key", monotonically_increasing_id() + 1)

provider_dim = claims_df.select("provider_id").dropDuplicates()
provider_dim = provider_dim.withColumn("provider_key", monotonically_increasing_id() + 1)

fact_claims = claims_df.join(patient_dim, on="member_id", how="left") \
                       .join(provider_dim, on="provider_id", how="left") \
                       .select("claim_id", col("patient_key"), col("provider_key"),
                               "service_start", "service_end", "paid_amount", "payer", "diagnosis_code")

jdbc_url = "jdbc:sqlserver://yourserver.database.windows.net:1433;database=yourdb"
connection_properties = {
    "user": "youruser",
    "password": "yourpassword",
    "driver": "com.microsoft.sqlserver.jdbc.SQLServerDriver"
}

patient_dim.write.jdbc(url=jdbc_url, table="dim_patient", mode="overwrite", properties=connection_properties)
provider_dim.write.jdbc(url=jdbc_url, table="dim_provider", mode="overwrite", properties=connection_properties)
fact_claims.write.jdbc(url=jdbc_url, table="fact_claims", mode="overwrite", properties=connection_properties)

print("Gold layer loaded to SQL Database.")
