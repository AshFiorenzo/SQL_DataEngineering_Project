-- step 4 - create skills data mart
DROP SCHEMA IF EXISTS skills_mart CASCADE;

CREATE SCHEMA skills_mart; 

-- create dim_skills table
SELECT '==loading skills Dimension Table for skill data mart==' as info;
CREATE OR REPLACE TABLE skills_mart.dim_skills(
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);
INSERT INTO skills_mart.dim_skills (skill_id,skills,type)
SELECT 
    skill_id, 
    skills, 
    type 
FROM skills_dim;
-- select * from skills_mart.dim_skills;

-- create dim_date_month table
SELECT '==loading Date_Month Dimension Table for skill data mart==' as info;
CREATE OR REPLACE TABLE skills_mart.dim_date_month(
    month_start_date DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    quarter_name VARCHAR,
    year_quarter VARCHAR
);
INSERT INTO skills_mart.dim_date_month(
    month_start_date,
    year,
    month,
    quarter,
    quarter_name,
    year_quarter
)
SELECT DISTINCT
    DATE_TRUNC ('month', job_posted_date) AS month_start_date,
    EXTRACT(YEAR FROM job_posted_date) AS year,
    EXTRACT (MONTH FROM job_posted_date) AS month,
    EXTRACT (QUARTER FROM job_posted_date) AS quarter,
    'Q-' || EXTRACT (QUARTER FROM job_posted_date):: VARCHAR AS quarter_name,
    EXTRACT(YEAR FROM job_posted_date) ::VARCHAR || '-Q' ||
    EXTRACT (QUARTER FROM job_posted_date) :: VARCHAR AS year_quarter
FROM job_postings_fact
ORDER BY month_start_date;

-- create fact_skill_demand_monthly table 
SELECT '==loading Skill Demond Monthly Fact Table for skill data mart==' as info;
CREATE TABLE skills_mart.fact_skill_demand_monthly(
    skill_id INTEGER,
    month_start_date DATE,
    job_title_short VARCHAR,
    postings_count INTEGER,
    remote_postings_count INTEGER,
    job_health_insurance_postings_count INTEGER,
    no_degree_mention_postings_count INTEGER,
    PRIMARY KEY (skill_id,month_start_date,job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date),
);
INSERT INTO skills_mart.fact_skill_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    job_health_insurance_postings_count,
    no_degree_mention_postings_count
)
WITH job_postings_prep as (
    SELECT 
    sjd.skill_id,
    date_trunc('month', jpf.job_posted_date) as month_start_date,
    jpf.job_title_short,
    CASE WHEN jpf.job_work_from_home = TRUE THEN 1 ELSE 0 END as is_remote,
    CASE WHEN jpf.job_health_insurance = TRUE THEN 1 ELSE 0 END as has_health_insurance,
    CASE WHEN jpf.job_no_degree_mention = TRUE THEN 1 ELSE 0 END as no_degree_mentioned
    FROM 
        job_postings_fact as jpf
    INNER JOIN   
        skills_job_dim as sjd
    ON 
    jpf.job_id = sjd.job_id
)
SELECT 
    skill_id, 
    month_start_date, 
    job_title_short, 
    count(*) as postings_count,
    sum(is_remote) as remote_postings_count,
    sum(has_health_insurance) as job_health_insurance_postings_count,
    sum(no_degree_mentioned) as no_degree_mention_postings_count
FROM 
    job_postings_prep
GROUP BY ALL
ORDER BY skill_id, month_start_date, job_title_short;

SELECT 'skill_dimension' as table_name, count(*) as record_count FROM skills_mart.dim_skills
UNION ALL 
SELECT 'date_month_dimension', count(*) FROM skills_mart.dim_date_month
UNION ALL 
SELECT 'skill_demand_fact', count(*) FROM skills_mart.fact_skill_demand_monthly;

SELECT * from skills_mart.dim_skills limit 5;
SELECT * from skills_mart.dim_date_month limit 5;
SELECT * from skills_mart.fact_skill_demand_monthly limit 5;

