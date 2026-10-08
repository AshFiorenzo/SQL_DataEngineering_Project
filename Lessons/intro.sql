select 42 as answer; 

select * from information_schema.tables where table_catalog='data_jobs'; 

select * from information_schema.table_constraints  where table_catalog='data_jobs';

PRAGMA show_tables;

PRAGMA show_tables_expanded;

DESCRIBE job_postings_fact;