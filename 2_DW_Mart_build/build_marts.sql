-- step1 - create star schema tables for data warehouse
.read 1_create_table_dw.sql

-- step2 - load data from csv files into tables
.read 2_load_schema_dw.sql