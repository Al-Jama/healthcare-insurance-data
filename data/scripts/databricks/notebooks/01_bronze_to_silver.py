# Databricks notebook source
# 01_bronze_to_silver: Ingest raw CSVs and write clean Parquet

from pyspark.sql.functions import col, lit, to_date

bronze_base = "abfss://bronze@yourstorageaccount.dfs.core.windows.net/"
silver_path = "abfss://silver@yourstorageaccount.dfs.core.windows.net/claims/"

medicare_raw = spark.read.option("header", True).csv(f"{bronze_base}medicare/*.csv")
medicaid_raw = spark.read.option("header", True).csv(f"{bronze_base}medicaid/*.csv")
commercial_raw = spark.read.option("header", True).csv(f"{bronze_base}commercial/*.csv")

medicare = medicare_raw.select(
    col("claim_id"),
    col("member_id"),
    col("first_name"),
    col("last_name"),
    to_date(col("service_start"), "yyyy-MM-dd").alias("service_start"),
    to_date(col("service_end"), "yyyy-MM-dd").alias("service_end"),
    col("paid_amount").cast("double"),
    col("diagnosis_code"),
    col("provider_id"),
    lit("Medicare").alias("payer")
)

medicaid = medicaid_raw.select(
    col("claim_id"),
    col("member_id"),
    col("first_name"),
    col("last_name"),
    to_date(col("service_start"), "yyyy-MM-dd").alias("service_start"),
    to_date(col("service_end"), "yyyy-MM-dd").alias("service_end"),
    col("paid_amount").cast("double"),
    col("diagnosis_code"),
    col("provider_id"),
    lit("Medicaid").alias("payer")
)

commercial = commercial_raw.select(
    col("claim_id"),
    col("member_id"),
    col("first_name"),
    col("last_name"),
    to_date(col("service_start"), "yyyy-MM-dd").alias("service_start"),
    to_date(col("service_end"), "yyyy-MM-dd").alias("service_end"),
    col("paid_amount").cast("double"),
    col("diagnosis_code"),
    col("provider_id"),
    lit("Commercial").alias("payer")
)

all_claims = medicare.unionByName(medicaid).unionByName(commercial)
clean_claims = all_claims.dropna(subset=["member_id", "claim_id"])
clean_claims.write.mode("overwrite").parquet(silver_path)
print(f"Silver claims written to {silver_path}")
