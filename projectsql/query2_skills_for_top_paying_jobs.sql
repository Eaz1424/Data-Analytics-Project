with temp1 as
(select 
    job_id,job_title_short,name,job_location,salary_year_avg
from 
    company_dim as comp left join job_postings_fact as job on comp.company_id=job.company_id
where 
    salary_year_avg is not null and job_title_short ='Data Scientist' AND job_location = 'India'  
order by 
    salary_year_avg DESC
),

temp2 as
    (select 
        temp1.*,
        skills,
        count(*) over (PARTITION BY name)
    FROM
      ((skills_job_dim inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id) inner join temp1 on skills_job_dim.job_id=temp1.job_id)
    
    order by 
        salary_year_avg DESC
    )
select * from temp2

