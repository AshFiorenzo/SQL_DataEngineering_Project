-- duckdb dw_marts.duckdb -c ".read build_marts.sql"  

-- step1 - create star schema tables for data warehouse
.read 1_create_table_dw.sql

-- step2 - load data from csv files into tables
.read 2_load_schema_dw.sql

-- step 3 - create flat mart table
.read 3_create_flat_mart.sql