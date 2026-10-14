-- duckdb dw_marts.duckdb -c ".read build_marts.sql"  

-- step1 - create star schema tables for data warehouse
.read 1_create_table_dw.sql

-- step2 - load data from csv files into tables
.read 2_load_schema_dw.sql

-- step 3 - create flat mart table
.read 3_create_flat_mart.sql

-- step 4 - create data marts for skills
.read 4_create_skills_mart.sql

-- step 5 - create priority mart
.read 5_create_priority_mart.sql

-- step 6 - update priority mart
.read 6_update_priority_mart.sql