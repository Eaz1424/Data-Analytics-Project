/*
Question: What are the top-paying data scientist jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available in India
- Focuses on job postings with specified salaries (remove nulls)
- Why? Highlight the top-paying opportunities for Data Scientists, offering insights into employment options
*/

SELECT 
    job_title,job_title_short, name, salary_year_avg, job_location
FROM 
    company_dim AS comp 
LEFT JOIN job_postings_fact AS job 
ON comp.company_id = job.company_id
WHERE 
    salary_year_avg IS NOT NULL 
    AND job_title_short = 'Data Scientist' 
    AND job_location = 'India'  
ORDER BY 
    salary_year_avg DESC
LIMIT 10;