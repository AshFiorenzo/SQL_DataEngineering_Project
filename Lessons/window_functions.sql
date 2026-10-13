SELECT 
    count(*)
FROM    
    job_postings_fact;

SELECT 
    job_id,
    job_title_short,
    company_id, 
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        partition by job_title_short, company_id
    ) as average_sal
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg is not null
LIMIT 10;

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        order by salary_hour_avg DESC
    ) as hour_salary_rank
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg is not null
LIMIT 10;

SELECT 
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        partition by job_title_short
        order by job_posted_date
    ) as avg_hourly_by_title
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg is not null and job_title_short='Data Engineer'
order by job_title_short, job_posted_date
LIMIT 10;

SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        partition by job_title_short
        order by salary_hour_avg DESC
    ) as hour_salary_rank
FROM 
    job_postings_fact
WHERE 
    salary_hour_avg is not null
ORDER BY 
    salary_hour_avg DESC, job_title_short
LIMIT 10;

SELECT 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        partition by company_id
        order by job_posted_date
    ) as previous_salary,
    salary_year_avg - LAG(salary_year_avg) OVER(
        partition by company_id
        order by job_posted_date
    ) as salary_change,
FROM 
    job_postings_fact
WHERE 
    salary_year_avg is not null and job_title_short = 'Data Engineer'
ORDER BY 
    company_id, job_posted_date
LIMIT 40;