SELECT UNNEST([1,1,1,2])
UNION
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
UNION ALL
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
INTERSECT
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
INTERSECT ALL
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
EXCEPT
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
EXCEPT ALL
SELECT UNNEST([1,1,3]);

CREATE TEMP TABLE jobs_2023 AS 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM data_jobs.job_postings_fact
WHERE EXTRACT(year from job_posted_date) = 2023;

CREATE TEMP TABLE jobs_2024 AS 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM data_jobs.job_postings_fact
WHERE EXTRACT(year from job_posted_date) = 2024;

SELECT * FROM jobs_2023 UNION SELECT * FROM jobs_2024;

SELECT 
    'job_2023' as table_name,
    COUNT(*) as total_jobs 
FROM jobs_2023 
UNION 
SELECT 
    'job_2024' as table_name,
    COUNT(*) as total_jobs 
FROM jobs_2024;

SELECT * FROM jobs_2023 EXCEPT SELECT * FROM jobs_2024;