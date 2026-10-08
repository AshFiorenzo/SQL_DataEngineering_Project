/*
Question: What are the most in-demand skills for data engineers?
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote job 
providing insights into the most valuable skills for data engineers s
*/

SELECT
    sd.skills,
    count(job_postings_fact.*) as demand
FROM
    job_postings_fact as jpf
INNER JOIN  skills_job_dim as sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd 
    ON sd.skill_id = sjd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer' and jpf.job_work_from_home = true
group by sd.skills 
order by demand DESC
LIMIT 10; 

/*
│   skills   │ demand │
│  varchar   │ int64  │
├────────────┼────────┤
│ sql        │  29221 │
│ python     │  28776 │
│ aws        │  17823 │
│ azure      │  14143 │
│ spark      │  12799 │
│ airflow    │   9996 │
│ snowflake  │   8639 │
│ databricks │   8183 │
│ java       │   7267 │
│ gcp        │   6446 │
└────────────┴────────┘
*/
