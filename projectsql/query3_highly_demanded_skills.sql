select
    --job.job_title_short,
    skills,
    count(skills) as demand_count

FROM
    (job_postings_fact as job inner join skills_job_dim as skills on job.job_id=skills.job_id) 
    inner join skills_dim as sk on sk.skill_id=skills.skill_id
WHERE
    job_title_short='Data Scientist' and job_location='India'

group by 
    skills

order by 
    demand_count DESC

limit 10;