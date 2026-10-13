CREATE OR REPLACE TABLE staging.priority_roles(
    role_id INTEGER,
    role_name VARCHAR,
    priority_lvl INTEGER
); 

INSERT INTO staging.priority_roles(role_id, role_name, priority_lvl)
VALUES
    (1, 'Data Engineer', 2),
    (2, 'Senior Data Engineer', 1),
    (4, 'Data Scientist', 3);


SELECT * FROM staging.priority_roles;