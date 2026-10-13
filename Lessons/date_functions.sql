SELECT 
    job_posted_date,
    job_posted_date:: DATE as date, 
    job_posted_date:: TIME as time, 
    job_posted_date:: TIMESTAMPTZ as time_stamp_with_time_zone, 
FROM 
    data_jobs.job_postings_fact
LIMIT 10;

SELECT 
    EXTRACT (year from job_posted_date) as posted_year,
    EXTRACT (month from job_posted_date) as posted_month,
    count(job_id) as job_count
FROM 
    data_jobs.job_postings_fact
WHERE 
    job_title_short = 'Data Engineer'
GROUP BY 
    EXTRACT (year from job_posted_date),
    EXTRACT (month from job_posted_date)
ORDER BY 
    posted_year, posted_month;

SELECT 
    job_posted_date,
    DATE_TRUNC('month', job_posted_date) as job_posted_month
FROM 
    data_jobs.job_postings_fact
ORDER BY RANDOM()
LIMIT 10; 

SELECT 
    DATE_TRUNC('month', job_posted_date) as posted_month,
    count(job_id) as job_count
FROM 
    data_jobs.job_postings_fact
WHERE 
    job_title_short = 'Data Engineer' AND EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY 
    DATE_TRUNC('month', job_posted_date)
ORDER BY 
    posted_month;

SELECT 
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'EST';

SELECT 
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'CST') as job_hour,
    count(job_id) as job_count
FROM 
    data_jobs.job_postings_fact 
WHERE 
    job_location LIKE '%TH%'
Group by 
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'CST')
ORDER BY 
    job_count DESC;
