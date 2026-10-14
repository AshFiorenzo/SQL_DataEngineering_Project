-- 1. create star schema tables

-- this is to make sure we can run this file again and again. if already exists, then delete
DROP TABLE IF EXISTS skills_job_dim;
DROP TABLE IF EXISTS job_postings_fact;
DROP TABLE IF EXISTS company_dim;
DROP TABLE IF EXISTS skills_dim;

-- when creating or deleting table, order matters due to foreign keys references. 
-- create company dimension table
CREATE TABLE company_dim (
    company_id INTEGER PRIMARY KEY,
    name VARCHAR
);

-- skills dimension table
CREATE TABLE skills_dim (
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    type VARCHAR
);

-- fact table
CREATE TABLE job_postings_fact (
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER, 
    job_title_short VARCHAR,
    job_title VARCHAR,
    job_location VARCHAR,
    job_via VARCHAR,
    job_schedule_type VARCHAR,
    job_work_from_home BOOLEAN,
    search_location VARCHAR,
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country VARCHAR,
    salary_rate VARCHAR,
    salary_year_avg DOUBLE,
    salary_hour_avg DOUBLE,
    FOREIGN KEY (company_id) REFERENCES company_dim(company_id)
);

CREATE TABLE skills_job_dim (
    skill_id INTEGER,
    job_id INTEGER,
    PRIMARY KEY (skill_id, job_id),
    FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id),
    FOREIGN KEY (job_id) REFERENCES job_postings_fact(job_id)
);

SELECT table_name FROM information_schema.tables where table_schema = 'main';