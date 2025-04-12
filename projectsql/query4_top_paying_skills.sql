select
    skills,
    ROUND(AVG(salary_year_avg),0) as average_salary
FROM
    skills_dim as skill1 inner join skills_job_dim as skill2 on skill1.skill_id=skill2.skill_id 
    inner join job_postings_fact as job1 on skill2.job_id=job1.job_id
WHERE
    job_title_short='Data Scientist' and salary_year_avg is not NULL and job_location='India'
group by 
    skills
order by 
    average_salary DESC