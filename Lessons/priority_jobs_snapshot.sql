CREATE OR REPLACE TEMP TABLE src_priority_jobs as 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP as updated_at
FROM 
    data_jobs.job_postings_fact as jpf
LEFT JOIN data_jobs.company_dim as cd 
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles as r
    ON jpf.job_title_short = r.role_name;

-- update main.priority_jobs_snapshot as tgt
-- SET
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- FROM src_priority_jobs as src
-- WHERE tgt.job_id = src.job_id 
--     AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;


-- INSERT INTO main.priority_jobs_snapshot(
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
-- ) 
-- SELECT
--     src.job_id,
--     src.job_title_short,
--     src.company_name,
--     src.job_posted_date,
--     src.salary_year_avg,
--     src.priority_lvl,
--     src.updated_at
-- FROM src_priority_jobs as src
-- WHERE NOT EXISTS (
--     SELECT 1 FROM main.priority_jobs_snapshot as tgt
--     WHERE tgt.job_id = src.job_id
-- );

MERGE INTO main.priority_jobs_snapshot as tgt 
USING src_priority_jobs as src 
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN 
    UPDATE SET  
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

WHEN NOT MATCHED THEN 
    INSERT(
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    ) 
    VALUES(
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT
    job_title_short,
    COUNT(*) as job_count,
    MIN(priority_lvl) as priority_lvl,
    MIN(updated_at) as last_updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;

