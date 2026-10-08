select 
    job_id,
    job_title_short, 
    name as company_name, 
    job_location
from 
    job_postings_fact as jpf 
LEFT JOIN company_dim as cd 
    on jpf.company_id = cd.company_id
LIMIT 10; 