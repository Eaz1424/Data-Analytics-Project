with table1 as(
    select
        --job.job_title_short,
        skills,
        count(skills) as demand_count,sk.skill_id

    FROM
        (job_postings_fact as job inner join skills_job_dim as skills on job.job_id=skills.job_id) 
        inner join skills_dim as sk on sk.skill_id=skills.skill_id
    WHERE
        job_title_short='Data Scientist' and job_location='India' and salary_year_avg is not NULL

    group by 
        sk.skill_id

    order by 
        demand_count DESC
    ),
table2 as
    (select
        skills,
        ROUND(AVG(salary_year_avg),0) as average_salary,skill1.skill_id
    FROM
        skills_dim as skill1 inner join skills_job_dim as skill2 on skill1.skill_id=skill2.skill_id 
        inner join job_postings_fact as job1 on skill2.job_id=job1.job_id
    WHERE
        job_title_short='Data Scientist' and salary_year_avg is not NULL and job_location='India'
    group by 
        skill1.skill_id
    order by 
        average_salary DESC)

select table1.skills,table1.demand_count,table2.average_salary
from
table1 inner join table2 on table1.skill_id=table2.skill_id

-- concise version below
select
    skill1.skill_id,skills,count(skill2.job_id) as skill_demand,
    ROUND(AVG(salary_year_avg)) as average_salary
from
    skills_dim as skill1 inner join skills_job_dim as skill2 on skill1.skill_id=skill2.skill_id 
            inner join job_postings_fact as job1 on skill2.job_id=job1.job_id
WHERE
    job_title_short='Data Scientist' and salary_year_avg is not NULL and job_location='India'
group by 
    skill1.skill_id
order by
    average_salary DESC,
    skill_demand DESC







