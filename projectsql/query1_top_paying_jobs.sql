-- top 10 highest paying Data Scientist jobs in India 

select job_title_short,name,salary_year_avg,job_location
from company_dim as comp left join job_postings_fact as job on comp.company_id=job.company_id
where salary_year_avg is not null and job_title_short ='Data Scientist' AND job_location = 'India'  
order by 
salary_year_avg DESC
limit 10;