# Project 2 -  Design a Data Warehouse for Reporting and OLAP

## Data Architecture
![data_arch.png](data_arch.png)

## 8 Tables created in Staging
### 6 tables from YELP data + 2 tables from climate data
![tables.png](tables.png)


## SQL queries code that transforms staging to ODS can be found on [script_staging_to_ods.sql](script_staging_to_ods.sql)

## Files and Tables size 
![files_tables_size.png](files_tables_size.png)


## ER Model
![ER_MODEL.png](ER_MODEL.png)


## DWH Start schema
![start_schema.png](start_schema.png)


As the fact table only contains the FKs and the rating I prefer to keep on the fact_review instead of bring a dim_review

## DW Tables 
![dwh_tables.png](dwh_tables.png)

## Report query to associate climate and review
![report_query.png](report_query.png)