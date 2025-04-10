
select comb.job_location,comb.salary_year_avg
from (
select *
from january_jobs

UNION ALL

select *
from february_jobs

UNION ALL
select *
from march_jobs
) as comb

where comb.salary_year_avg>70000j