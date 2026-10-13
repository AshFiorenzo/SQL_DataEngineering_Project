
drop database jobs_mart; 

create database if not exists jobs_mart;

show databases;

use jobs_mart; 

create schema if not exists staging;

drop schema staging; 

select * from information_schema.schemata; 

DROP TABLE IF EXISTS preferred_roles; 

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

select * from information_schema.tables where table_catalog = 'jobs_mart'; 

INSERT INTO staging.preferred_roles (role_id, role_name) 
VALUES 
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer');

SELECT * from staging.preferred_roles;

INSERT INTO staging.preferred_roles (role_id, role_name) 
VALUES 
    (3, 'Software Engineer');

ALTER TABLE staging.preferred_roles
ADD Column preferred_role BOOLEAN; 

-- ALTER TABLE staging.preferred_roles
-- DROP Column preferred_role; 

UPDATE staging.preferred_roles 
SET preferred_role = TRUE 
WHERE role_id = 1 OR role_id = 2; 

UPDATE staging.preferred_roles 
SET preferred_role = FALSE 
WHERE role_id = 3;

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

SELECT * from staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN priority_level TO priority_lvl; 

ALTER TABLE staging.priority_roles
ALTER Column priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3; 
