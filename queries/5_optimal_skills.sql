WITH skills_demand AS (
    SELECT
        sd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM
        job_postings_fact jpf
    INNER JOIN
        skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN
        skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst'
        AND jpf.salary_year_avg IS NOT NULL
        AND jpf.job_work_from_home = TRUE
    GROUP BY
        sd.skill_id,
        sd.skills
),
average_salary AS (
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact jpf
    INNER JOIN
        skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN
        skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst'
        AND jpf.salary_year_avg IS NOT NULL
        AND jpf.job_work_from_home = TRUE
    GROUP BY
        sd.skill_id,
        sd.skills
    HAVING
        COUNT(sjd.job_id) > 10
)
SELECT
    sd.skill_id,
    sd.skills,
    sd.demand_count,
    avg_s.avg_salary
FROM
    skills_demand sd
INNER JOIN
    average_salary avg_s ON sd.skill_id = avg_s.skill_id
ORDER BY
    avg_s.avg_salary DESC,
    sd.demand_count DESC
LIMIT 25;
