# Healthcare Data Warehouse on Azure (Medicare / Medicaid / Commercial)

Full‑cycle data engineering project for healthcare claims.  
Built with **Azure Data Factory**, **Databricks (PySpark)**, **Azure SQL / MySQL**.  
No Airflow needed – ADF pipelines are the simple orchestrator.

## Architecture

1. Raw CSVs land in **Azure Blob Storage** (landing zone)  
2. ADF pipeline triggers on file arrival  
3. Databricks notebooks clean and model data into a star schema  
4. Final tables are loaded into **Azure SQL Database** (or MySQL)  
5. Ready for Power BI / SQL analytics  

## Project Structure
- `data/` – sample data generator and test CSVs  
- `adf/` – Azure Data Factory pipeline & linked service definitions  
- `databricks/` – PySpark notebooks (bronze→silver, silver→gold)  
- `sql/` – DDL, stored procedures, and sample queries  
- `config/` – environment settings  

## Tech Stack
- **Orchestration**: Azure Data Factory (no Airflow)  
- **Transformations**: PySpark on Databricks  
- **Storage**: Azure Data Lake Gen2  
- **Database**: Azure SQL Database / MySQL  
- **Languages**: Python, SQL
