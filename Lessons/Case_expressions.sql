SELECT 
    job_title_short,
    salary_hour_avg,
    CASE 
        WHEN salary_hour_avg < 25 THEN 'LOW'
        WHEN salary_hour_avg < 50 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS salary_category
FROM 
    data_jobs.job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10; 

SELECT 
    job_title_short,
    salary_hour_avg,
    CASE 
        WHEN salary_hour_avg IS NULL THEN 'missing'
        WHEN salary_hour_avg < 25 THEN 'LOW'
        WHEN salary_hour_avg < 50 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS salary_category
FROM 
    data_jobs.job_postings_fact 
LIMIT 10; 

SELECT 
    job_title,
    job_title_short,
    CASE 
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
        ELSE 'Others'
    END AS job_tite_category
FROM 
    data_jobs.job_postings_fact 
ORDER BY RANDOM()
LIMIT 10; 

SELECT 
    job_title_short, 
    COUNT(*) AS total_postings, 
    MEDIAN (
        CASE 
            WHEN salary_year_avg < 100_000 THEN salary_year_avg
        END
    ) AS median_low_salary,
    MEDIAN (
        CASE 
            WHEN salary_year_avg >= 100_000 THEN salary_year_avg
        END
    ) AS median_high_salary
FROM 
    data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
group by job_title_short;

WITH salaries as (
    SELECT 
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE 
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2080
        END AS standardized_salary
    FROM 
        data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL 
)
SELECT 
    *,
    CASE
         WHEN standardized_salary IS NULL THEN 'missing'
        WHEN standardized_salary < 75_000 THEN 'low'
        WHEN standardized_salary < 150_000 THEN 'medium'
        ELSE 'high'
    END AS salary_backet 
FROM salaries
ORDER BY standardized_salary DESC
LIMIT 20;