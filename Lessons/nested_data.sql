SELECT [1,2,3];
SELECT ['python','sql','r'] as skills_array;

WITH skills AS (
    SELECT 'python' as skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT array_agg(skill ORDER BY skill) as skills FROM skills
)
SELECT 
    skills[1] as first_skill, 
    skills[2] as first_skill , 
    skills[3] as first_skill 
from skills_array;


WITH skill_struct AS (
    SELECT
    struct_pack(
        skill:='python',
        type:='programming'
    ) as s
)
SELECT s.skill, s.type from skill_struct;

WITH skill_table AS (
    SELECT 'python' as skills, 'programming' as types
    UNION ALL
    SELECT 'sql', 'query'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT
    struct_pack(
        skill:=skills,
        type:=types
    )
FROM skill_table;

SELECT [
    { skill : 'python', type : 'programming'},
    { skill : 'sql', type : 'query'}
];

WITH skill_table AS (
    SELECT 'python' as skills, 'programming' as types
    UNION ALL
    SELECT 'sql', 'query'
    UNION ALL
    SELECT 'r', 'programming'
), skills_arraystruct AS (
    SELECT
    array_agg(
        struct_pack(
            skill:=skills,
            type:=types
        )
    ) as array_strat
    FROM skill_table
)
SELECT array_strat[1].skill FROM skills_arraystruct;

WITH skill_json as (
    SELECT '{"skill" : "python", "type" : "programming"}':: JSON as skills_json
)
SELECT 
    struct_pack(
        skill:=json_extract_string(skills_json,'$.skill'),
        type:=json_extract_string(skills_json,'$.type')
    ) as struct_from_json
from skill_json;

CREATE OR REPLACE TEMP TABLE job_skill_array as 
SELECT
jpf.job_id,
jpf.job_title_short,
jpf.salary_year_avg,
array_agg(sd.skills) as skills_array
FROM 
    job_postings_fact as jpf 
LEFT JOIN skills_job_dim as sjd 
    ON sjd.job_id = jpf.job_id
LEFT JOIN skills_dim as sd 
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL;

WITH flat_skill as (
    SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array) as skill
    FROM 
        job_skill_array
)
SELECT skill, median(salary_year_avg) as median_salary
FROM flat_skill
where salary_year_avg IS NOT NULL
GROUP BY skill
ORDER BY median_salary DESC;


CREATE OR REPLACE TEMP TABLE job_skill_array_struct as 
SELECT
jpf.job_id,
jpf.job_title_short,
jpf.salary_year_avg,
array_agg(
    struct_pack(
        skill_type:=sd.type,
        skill_name:=sd.skills
    )
) as skills_type
FROM 
    job_postings_fact as jpf 
LEFT JOIN skills_job_dim as sjd 
    ON sjd.job_id = jpf.job_id
LEFT JOIN skills_dim as sd 
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL;

WITH flat_skills AS (
    SELECT 
    job_id, 
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type as skill_type,
    UNNEST(skills_type).skill_name as skill_name
    FROM job_skill_array_struct
)
SELECT 
    skill_type,
    median(salary_year_avg) as median_salary
FROM flat_skills
where salary_year_avg IS NOT NULL
GROUP BY skill_type
ORDER BY median_salary DESC;