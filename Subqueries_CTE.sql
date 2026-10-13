
-- subquery in select 
SELECT 
    job_title_short,
    salary_year_avg,
    (SELECT median(salary_year_avg) from job_postings_fact) as market_median_salary
FROM job_postings_fact
WHERE salary_year_avg is not null
LIMIT 10; 

-- subquery in from 
SELECT 
    job_title_short,
    median(salary_year_avg) as median_salary,
    (SELECT median(salary_year_avg) from job_postings_fact where job_work_from_home = TRUE) as market_median_salary
FROM 
    (select job_title_short, salary_year_avg from job_postings_fact where job_work_from_home = TRUE) as clean_jobs
group by job_title_short
LIMIT 10; 

-- subquery in having clause
SELECT 
    job_title_short,
    median(salary_year_avg) as median_salary,
    (
        SELECT median(salary_year_avg) 
        from job_postings_fact 
        where job_work_from_home = TRUE
    ) as market_median_salary
FROM (
    select job_title_short, salary_year_avg 
    from job_postings_fact 
    where job_work_from_home = TRUE
) as clean_jobs
group by job_title_short
having median(salary_year_avg) > (
    SELECT median(salary_year_avg) 
    from job_postings_fact 
    where job_work_from_home = TRUE
)
LIMIT 10; 

-- CTE
WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        median(salary_year_avg)::INT as median_salary
    FROM
        job_postings_fact
    where job_country='United States'
    group by 
        job_title_short,
        job_work_from_home
)
SELECT
    r.job_title_short,
    r.median_salary as remote_median_salary,
    o.median_salary as onsite_media_salary,
    (r.median_salary - o.median_salary) as remote_premium 
FROM title_median as r
INNER JOIN title_median as o 
    ON r.job_title_short = o.job_title_short 
where r.job_work_from_home = TRUE 
and o.job_work_from_home = FALSE
order by remote_premium desc;

-- where exists 
select * 
from range(5) as src(key);
select * 
from range(5) as tgt(key);
select * 
from range(5) as src(key)
where not exists (
    select 1 
    from range(3) as tgt(key)
    where tgt.key = src.key
);

select * 
from job_postings_fact as tgt
where not exists (
    select 1 
    from skills_job_dim as src 
    where tgt.job_id =src.job_id
)
order by job_id;