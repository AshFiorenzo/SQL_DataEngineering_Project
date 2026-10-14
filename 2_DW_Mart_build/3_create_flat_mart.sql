-- step 3 - create flat mart table

DROP SCHEMA IF EXISTS flat_mart CASCADE;
CREATE SCHEMA flat_mart;

SELECT '==loading flat mart table==' as info;
-- use ctas
CREATE OR REPLACE TABLE flat_mart.job_postings as 
SELECT 
    jpf.job_id,
    jpf.company_id,
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
    array_agg(
        struct_pack(
            type:=sd.type,
            name:=sd.skills
    )) as skills_and_types
FROM 
    job_postings_fact as jpf 
LEFT JOIN 
    company_dim as cd 
ON jpf.company_id = cd.company_id
LEFT JOIN 
    skills_job_dim as sjd
ON jpf.job_id = sjd.job_id 
LEFT JOIN 
    skills_dim as sd
ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

select 'flat_mart_job_postings' as table_name, count(*) as record_count from flat_mart.job_postings;
select * from flat_mart.job_postings LIMIT 5;