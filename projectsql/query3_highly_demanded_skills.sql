-- This query identifies the top 10 most in-demand skills for data scientist roles in India
-- Why? Retrieves the top skills with the highest demand in the job market,providing insights into the most valuable skills for job seekers.
SELECT
    skills, 
    COUNT(skills) AS demand_count 

FROM
    (job_postings_fact AS job 
    INNER JOIN skills_job_dim AS skills ON job.job_id = skills.job_id) -- joins job postings with job-skill mapping
    INNER JOIN skills_dim AS sk ON sk.skill_id = skills.skill_id -- joins the result with skills data
WHERE
    job_title_short = 'Data Scientist' 
    AND job_location = 'India' 

GROUP BY 
    skills 

ORDER BY 
    demand_count DESC

LIMIT 10;