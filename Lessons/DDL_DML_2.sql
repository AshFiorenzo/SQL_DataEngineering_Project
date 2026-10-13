--creating flat table as 
CREATE OR REPLACE TABLE staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id,
    cd.name as company_name,
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
;

select * from staging.job_postings_flat limit 10; 

select count(*) from staging.job_postings_flat;

-- creating view 
CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS 
SELECT jpf.*
FROM staging.job_postings_flat as jpf
JOIN staging.priority_roles as r
    ON jpf.job_title_short = r.role_name
WHERE r.priority_lvl = 1;

select 
    job_title_short, 
    count(*) as job_count
from staging.priority_jobs_flat_view
group by job_title_short
order by job_count DESC;

CREATE OR REPLACE TEMPORARY TABLE senior_jobs_flat_temp AS 
SELECT * 
FROM staging.priority_jobs_flat_view
WHERE job_title_short = 'Senior Data Engineer';

select 
    job_title_short, 
    count(*) as job_count
from senior_jobs_flat_temp
group by job_title_short
order by job_count DESC;

SELECT COUNT(*) from staging.job_postings_flat;
SELECT COUNT(*) from staging.priority_jobs_flat_view;
SELECT COUNT(*) from senior_jobs_flat_temp;


DELETE from staging.job_postings_flat
WHERE job_posted_date < '2024-01-01';

SELECT COUNT(*) from staging.job_postings_flat;
SELECT COUNT(*) from staging.priority_jobs_flat_view;
SELECT COUNT(*) from senior_jobs_flat_temp;

TRUNCATE TABLE staging.job_postings_flat;

INSERT INTO staging.job_postings_flat 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id,
    cd.name as company_name,
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_posted_date >= '2024-01-01';
;
