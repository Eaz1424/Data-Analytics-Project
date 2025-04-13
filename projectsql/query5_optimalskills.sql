-- What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
-- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis


-- TABLE1: Identifies the most in-demand skills for Data Scientist roles in India
WITH table1 AS (
    SELECT
        skills, 
        COUNT(skills) AS demand_count, 
        sk.skill_id -- Skill ID for joining with other tables
    FROM
        (JOB_POSTINGS_FACT AS job INNER JOIN SKILLS_JOB_DIM AS skills ON job.job_id = skills.job_id) -- Joins job postings with job-skill mapping
        INNER JOIN SKILLS_DIM AS sk ON sk.skill_id = skills.skill_id -- Joins the result with skills data
    WHERE
        job_title_short = 'Data Scientist' 
        AND job_location = 'India'
        AND salary_year_avg IS NOT NULL 
    GROUP BY 
        sk.skill_id 
    ORDER BY 
        demand_count DESC 
),

-- TABLE2: Calculates the average salary associated with each skill for Data Scientist roles in India
table2 AS (
    SELECT
        skills, 
        ROUND(AVG(salary_year_avg), 0) AS average_salary, 
        skill1.skill_id -- Skill ID for joining with other tables
    FROM
        SKILLS_DIM AS skill1 INNER JOIN SKILLS_JOB_DIM AS skill2 ON skill1.skill_id = skill2.skill_id -- Joins skills data with job-skill mapping
        INNER JOIN JOB_POSTINGS_FACT AS job1 ON skill2.job_id = job1.job_id -- Joins the result with job postings data
    WHERE
        job_title_short = 'Data Scientist' 
        AND salary_year_avg IS NOT NULL 
        AND job_location = 'India' 
    GROUP BY 
        skill1.skill_id 
    ORDER BY 
        average_salary DESC 
)

-- Combines TABLE1 and TABLE2 to identify skills that are both in-demand and associated with high salaries
SELECT table1.skills, table1.demand_count, table2.average_salary
FROM
    table1 INNER JOIN table2 ON table1.skill_id = table2.skill_id -- Joins the two tables on skill ID;



-- Concise version: Combines demand and salary analysis in a single query
SELECT
    skill1.skill_id, 
    skills, 
    COUNT(skill2.job_id) AS skill_demand, 
    ROUND(AVG(salary_year_avg)) AS average_salary 
FROM
    SKILLS_DIM AS skill1 INNER JOIN SKILLS_JOB_DIM AS skill2 ON skill1.skill_id = skill2.skill_id -- Joins skills data with job-skill mapping
    INNER JOIN JOB_POSTINGS_FACT AS job1 ON skill2.job_id = job1.job_id -- Joins the result with job postings data
WHERE
    job_title_short = 'Data Scientist' 
    AND salary_year_avg IS NOT NULL 
    AND job_location = 'India' 
GROUP BY 
    skill1.skill_id 
ORDER BY 
    skill_demand DESC;