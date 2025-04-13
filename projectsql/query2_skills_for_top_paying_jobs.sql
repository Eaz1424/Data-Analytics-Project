/*
Question: What skills are required for the top-paying data scientist jobs?
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

-- temp1: extracts top-paying data scientist jobs in india, including job details and salary information
WITH temp1 AS (
    SELECT 
        job_id, job_title_short, name, job_location, salary_year_avg
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
    LIMIT 10
),

-- temp2: joins the job data from temp1 with skills data to identify skills associated with top-paying jobs
temp2 AS (
    SELECT 
        temp1.*, -- includes all columns from temp1
        skills, 
        COUNT(*) OVER (PARTITION BY name) 
    FROM
        ((skills_job_dim 
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id)
        INNER JOIN temp1 ON skills_job_dim.job_id = temp1.job_id) 
    ORDER BY
        salary_year_avg DESC 
)

-- final select: outputs the enriched dataset with job details, salary, and associated skills
SELECT * 
FROM 
    temp2;