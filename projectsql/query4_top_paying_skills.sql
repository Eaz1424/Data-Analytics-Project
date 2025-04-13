-- This query identifies the skills associated with the highest average salaries for data scientist roles in India
-- Why? It reveals how different skills impact salary levels for Data Scientists and helps identify the most financially rewarding skills to acquire or improve
SELECT
    skills, 
    ROUND(AVG(salary_year_avg), 0) AS average_salary -- calculates the average salary for each skill, rounded to the nearest whole number
FROM
    skills_dim AS skill1 
    INNER JOIN skills_job_dim AS skill2 ON skill1.skill_id = skill2.skill_id -- joins skills data with job-skill mapping
    INNER JOIN job_postings_fact AS job1 ON skill2.job_id = job1.job_id -- joins the result with job postings data
WHERE
    job_title_short = 'Data Scientist' 
    AND salary_year_avg IS NOT NULL 
    AND job_location = 'India' 
GROUP BY 
    skills
ORDER BY 
    average_salary DESC; 