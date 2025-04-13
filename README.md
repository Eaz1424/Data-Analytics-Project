# Introduction

Welcome to the SQL Job Market Analysis Project! 

This project is designed to analyze job market trends by leveraging SQL to extract meaningful insights from job postings and skills data. It focuses on identifying top-paying jobs, highly demanded skills, and the optimal skill sets required for specific roles. By combining advanced SQL techniques such as **Common Table Expressions (CTEs), joins, aggregations, and window functions**, this project provides a comprehensive view of the job market landscape.

Whether you're a data scientist, recruiter, or someone exploring career opportunities, this project offers valuable insights to help you make informed decisions.


# Background

The job market is rapidly evolving, with new roles and skills emerging as industries adapt to technological advancements. Staying competitive requires understanding these trends, which is equally important for **job seekers**, **recruiters**, and **organizations**.

This project bridges the gap between job postings and actionable insights by analyzing real-world data to answer critical questions:
- **Which jobs offer the highest salaries?**
- **What skills are most in demand?**
- **How can job seekers align their skills with market needs?**

Using a dataset containing job postings, companies, salaries, and skills, this project applies **SQL** to uncover patterns and trends. While the focus is on roles like **Data Scientist**, the queries are adaptable for other roles, industries, or regions, making it a versatile tool for exploring the modern job market.

# Tools Used

For my deep dive into the data scientist job market, I harnessed the power of several key tools:

- **SQL**: The foundation of this project, enabling powerful querying and analysis to extract meaningful insights from the data.
- **PostgreSQL**: A robust and reliable database management system, perfectly suited for handling and managing the job postings dataset.
- **Visual Studio Code**: A versatile and efficient code editor, used for writing and executing SQL queries with ease.
- **Git & GitHub**: Essential tools for version control and collaboration, ensuring seamless tracking and sharing of SQL scripts and project progress.

# Analysis

Each query in this project was designed to explore specific aspects of the data scientist job market, providing targeted insights to answer key questions.

### 1. Top Paying Data Scientist Jobs
To uncover the highest-paying roles, I analyzed data scientist positions by filtering based on average yearly salary and location, with a focus on opportunities in India. This query sheds light on lucrative job prospects within the field.

```sql
SELECT 
    JOB_TITLE_SHORT, NAME, SALARY_YEAR_AVG, JOB_LOCATION
FROM 
    COMPANY_DIM AS COMP 
LEFT JOIN JOB_POSTINGS_FACT AS JOB 
ON COMP.COMPANY_ID = JOB.COMPANY_ID
WHERE 
    SALARY_YEAR_AVG IS NOT NULL 
    AND JOB_TITLE_SHORT = 'Data Scientist' 
    AND JOB_LOCATION = 'India'  
ORDER BY 
    SALARY_YEAR_AVG DESC
LIMIT 10;
```
Here's the breakdown of the top data scientist jobs:
- GSK offers significantly higher compensation compared to other companies
- There's a cluster of companies offering around $170,000/year
- The difference between the highest and lowest salary in the top 10 is approximately $42,000/year
- Multiple companies appear twice in the list with slightly different salary ranges


### 2. Skills for Top Paying Jobs
To identify the skills needed for top-paying jobs, I joined job postings with skills data, uncovering what employers prioritize for high-salary roles.
```sql
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
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```


Here's the breakdown of the most demanded skills 
for High-Paying Data Scientist Roles in India:

- Skills like Python, SQL, AWS, R, and Docker are highly sought after, appearing across multiple job postings with high demand counts (e.g., Python with a demand count of 16 at HRS).
Skill Demand by Company:

- Companies like HRS, Micron Technology, and Shell prioritize a diverse range of skills, including cloud platforms (AWS, Azure, GCP), data tools (Tableau, Databricks), and programming languages (Python, R, Java).
Salary and Skill Correlation:

- High-paying roles (e.g., $170,575 at Micron Technology) often require advanced skills like PyTorch, TensorFlow, and Spark, indicating that specialized technical expertise is rewarded with higher compensation.



### 3. In-Demand Skills for Data Scientists

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
-- This query identifies the top 10 most in-demand skills for data scientist roles in India
-- - Why? Retrieves the top skills with the highest demand in the job market,providing insights into the most valuable skills for job seekers.
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
```
Here's the breakdown of the most demanded skills for data scientists:

 🔧 Core Programming & Query Skills Dominate:

- **Python** (1013 mentions) and **SQL** (738) are the most sought-after, reflecting their foundational role in data science and analytics.

☁️ Cloud & BI Tools Are Key Differentiators:

- **AWS** (301) and **Tableau** (300) show strong demand, highlighting the importance of cloud computing and data visualization.

📊 R Still Holds Ground:

- Despite being less dominant than **Python, R** (482) continues to be a relevant skill, especially in statistical modeling and academia-driven roles.


| Skills   | Demand Count |
|----------|--------------|
| Python   | 1013         |
| SQL      |  738         |
| r        |  482         |
| aws      |  301         |
| Tableau  |  300         |
| spark    |  255         |
| azure    |  251         |
| Excel    |  250         |
|TensorFlow|  245         |
| sas      |  196         |

*Table of the demand for the top 10 skills in data scientist job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
-- This query identifies the skills associated with the highest average salaries for data scientist roles in India
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
```
Here's a breakdown of the results for top paying skills for Data Scientists:
- Top-Paying Skills: **Hadoop, Snowflake, Databricks, Shell, Go, Express, C++**, and **Java** lead the list with an average salary of $170,575 USD annually.

- High Salaries for AI and Big Data Tools: **Spark** and **TensorFlow** follow closely with average salaries of $168,497 USD annually, highlighting the demand for expertise in AI frameworks and big data technologies.

- Cloud and DevOps Competencies: **Kubernetes** and **GCP** (Google Cloud Platform) are also highly valued, offering average salaries of $166,500 USD annually.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| hadoop       |            170,575 |
| snowflake     |            170,575 |
| databricks     |            170,575 |
| shell        |            170,538 |
| go     |            170,500 |
| express        |            170,500 |
| c++         |            170,500 |
| java       |            170,500 |
| flow        |            170,000 |
| spark |            168,497 |

*Table of the average salary for the top 10 paying skills for data scientists*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
    average_salary DESC, 
    skill_demand DESC;
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 1        | python         | 27           |            155,534 |
| 0      | sql | 11           |            163,224 |
| 5       | r     | 22           |            142,660 |
| 76       | aws  | 37           |            159,019 |
| 182       | tableau      | 34           |            153,624 |
| 214       | docker   | 13           |            163,500 |
| 181       | excel        | 32           |            115,400 |
| 74        | azure       | 17           |            165,167 |
| 234      | confluence       | 12           |            164,038 |
| 6      | shell       | 20           |            170,538 |

*Table of the most optimal skills for data scientist sorted by demand*

Here's a breakdown of the most optimal skills for Data Scientists: 
### High-Demand and High-Paying Skills:

- Skills like **databricks, snowflake, and hadoop** are associated with the highest average salary of $170,575 while maintaining significant demand.

### Widely Demanded Skills Across Companies:

- Skills such as **sql** (demand count: 7), **python** (demand count: 11), and **docker** (demand count: 3) are highly sought after, making them essential for career growth.

### Specialized Skills with Competitive Salaries:

- Skills like **tensorflow** and **spark** offer competitive average salaries of $168,497, while **aws** and **azure** remain critical for cloud-based roles with salaries around $159,019 and $165,167, respectively
# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Developed expertise in advanced SQL techniques, seamlessly merging tables and utilizing `WITH` clauses to create efficient and modular temporary tables.
- **📊 Data Aggregation:** - **📊 Data Aggregation:** Mastered the use of `GROUP BY` and leveraged aggregate functions like `COUNT()`,`AVG()` , `PARTITION` to efficiently summarize and analyze data.
- **💡 Analytical Wizardry:** Enhanced my problem-solving abilities by transforming complex questions into actionable and insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Scientist Jobs**: The highest-paying roles in India offer salaries up to $204,381 annually, with companies like GSK leading the market
2. **Skills for Top-Paying Jobs**: High-paying roles demand advanced skills like **Databricks, Snowflake, Hadoop, and Shell,** which are associated with the highest average salaries of $170,575..
3. **Most In-Demand Skills**: SQL and Python are the most demanded skilla in the data scientist job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills like **TensorFlow, Spark**, and **PyTorch** are associated with competitive salaries of $168,497 and above, highlighting the value of expertise in AI and big data technologies
5. **Optimal Skills for Job Market Value**: Skills like **SQL, Python**, and **Docker** are both in high demand and offer competitive salaries, making them essential for career advancement in data science.

### Closing Thoughts
This project significantly improved my SQL expertise and offered valuable insights into the data scientist job market. The analysis serves as a roadmap for prioritizing skill development and optimizing job search strategies. By focusing on high-demand and high-paying skills, aspiring data analysts can better position themselves in a competitive landscape. This project underscores the importance of continuous learning and staying adaptable to evolving trends in the field of data analytics.
