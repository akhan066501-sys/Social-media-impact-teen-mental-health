-- ============================================================
-- SOCIAL MEDIA & TEEN MENTAL HEALTH — COMPLETE ANALYSIS
-- Database: PostgreSQL
-- ============================================================


-- ============================================================
-- 1. TABLE CREATION
-- ============================================================

CREATE TABLE social_media_data (
    id                        SERIAL PRIMARY KEY,
    age                       INTEGER,
    gender                    VARCHAR(10),
    daily_social_media_hours  NUMERIC(4,2),
    platform_usage            VARCHAR(20),
    sleep_hours               NUMERIC(4,2),
    screen_time_before_sleep  NUMERIC(4,2),
    academic_performance      NUMERIC(5,2),
    physical_activity         NUMERIC(4,2),
    social_interaction_level  VARCHAR(10),
    stress_level              INTEGER,
    anxiety_level             INTEGER,
    addiction_level           INTEGER,
    depression_label          INTEGER   -- 0 = No, 1 = Yes
);


-- ============================================================
-- 2. BASIC OVERVIEW QUERIES
-- ============================================================

-- Q1: View all records
SELECT * FROM social_media_data;

-- Q2: Total number of teens in dataset
SELECT COUNT(*) AS total_teens FROM social_media_data;

-- : Overall summary stats
SELECT
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 2)     AS avg_sm_hours,
    ROUND(AVG(sleep_hours)::NUMERIC, 2)                  AS avg_sleep_hours,
    ROUND(AVG(screen_time_before_sleep)::NUMERIC, 2)     AS avg_screen_before_sleep,
    ROUND(AVG(academic_performance)::NUMERIC, 2)         AS avg_academic_perf,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 2)              AS avg_addiction,
    SUM(depression_label)                       AS total_depressed,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)       AS depression_rate_pct
FROM social_media_data;

-- : Gender distribution
SELECT
    gender,
    COUNT(*) AS total_teens,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM social_media_data), 1) AS pct
FROM social_media_data
GROUP BY gender;

-- : Platform usage distribution
SELECT
    platform_usage,
    COUNT(*) AS total_teens,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM social_media_data), 1) AS pct
FROM social_media_data
GROUP BY platform_usage
ORDER BY total_teens DESC;

-- : Age distribution
SELECT
    age,
    COUNT(*) AS total_teens
FROM social_media_data
GROUP BY age
ORDER BY age;


-- ============================================================
-- 3. PLATFORM-WISE MENTAL HEALTH ANALYSIS
-- ============================================================

-- : Platform vs all mental health metrics
SELECT
    platform_usage,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 2)     AS avg_sm_hours,
    ROUND(AVG(sleep_hours)::NUMERIC, 2)                  AS avg_sleep,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 2)              AS avg_addiction,
    SUM(depression_label)                       AS depressed_count,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)       AS depression_rate_pct
FROM social_media_data
GROUP BY platform_usage
ORDER BY avg_anxiety DESC;

-- : Which platform has highest stress?
SELECT
    platform_usage,
    ROUND(AVG(stress_level)::NUMERIC, 2) AS avg_stress
FROM social_media_data
GROUP BY platform_usage
ORDER BY avg_stress DESC
LIMIT 1;

-- : Platform vs academic performance
SELECT
    platform_usage,
    ROUND(AVG(academic_performance)::NUMERIC, 2) AS avg_academic_perf,
    ROUND(AVG(physical_activity)::NUMERIC, 2)    AS avg_physical_activity
FROM social_media_data
GROUP BY platform_usage
ORDER BY avg_academic_perf DESC;


-- ============================================================
-- 4. SOCIAL MEDIA USAGE BUCKETS ANALYSIS
-- ============================================================

-- : SM usage buckets vs mental health
SELECT
    CASE
        WHEN daily_social_media_hours < 3 THEN 'Low (<3 hrs)'
        WHEN daily_social_media_hours < 6 THEN 'Moderate (3-6 hrs)'
        ELSE                                   'High (>=6 hrs)'
    END                                         AS sm_bucket,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 2)     AS avg_sm_hours,
    ROUND(AVG(sleep_hours)::NUMERIC, 2)                  AS avg_sleep,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 2)              AS avg_addiction,
    SUM(depression_label)                       AS depressed_count,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)       AS depression_rate_pct
FROM social_media_data
GROUP BY sm_bucket
ORDER BY avg_sm_hours;

-- : SM usage buckets vs academic performance
SELECT
    CASE
        WHEN daily_social_media_hours < 3 THEN 'Low (<3 hrs)'
        WHEN daily_social_media_hours < 6 THEN 'Moderate (3-6 hrs)'
        ELSE                                   'High (>=6 hrs)'
    END                                         AS sm_bucket,
    ROUND(AVG(academic_performance)::NUMERIC, 2)         AS avg_academic_perf,
    ROUND(AVG(physical_activity)::NUMERIC, 2)            AS avg_physical_activity,
    ROUND(AVG(screen_time_before_sleep)::NUMERIC, 2)     AS avg_screen_before_sleep
FROM social_media_data
GROUP BY sm_bucket
ORDER BY avg_academic_perf DESC;


-- ============================================================
-- 5. GENDER-WISE ANALYSIS
-- ============================================================

-- : Gender vs all mental health metrics
SELECT
    gender,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 2)     AS avg_sm_hours,
    ROUND(AVG(sleep_hours)::NUMERIC, 2)                  AS avg_sleep,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 2)              AS avg_addiction,
    ROUND(AVG(academic_performance)::NUMERIC, 2)         AS avg_academic_perf,
    SUM(depression_label)                       AS depressed_count,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)       AS depression_rate_pct
FROM social_media_data
GROUP BY gender;

-- : Gender + Platform combination
SELECT
    gender,
    platform_usage,
    COUNT(*)                                AS total_teens,
    ROUND(AVG(stress_level)::NUMERIC, 2)            AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)           AS avg_anxiety,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)  AS depression_rate_pct
FROM social_media_data
GROUP BY gender, platform_usage
ORDER BY gender, avg_anxiety DESC;


-- ============================================================
-- 6. AGE GROUP ANALYSIS
-- ============================================================

-- Q14: Age-wise mental health metrics
SELECT
    age,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 2)     AS avg_sm_hours,
    ROUND(AVG(sleep_hours)::NUMERIC, 2)                  AS avg_sleep,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 2)              AS avg_addiction,
    ROUND(AVG(academic_performance)::NUMERIC, 2)         AS avg_academic_perf,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)       AS depression_rate_pct
FROM social_media_data
GROUP BY age
ORDER BY age;

-- : Age + Gender mental health breakdown
SELECT
    age,
    gender,
    ROUND(AVG(stress_level)::NUMERIC, 1)     AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 1)    AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 1)  AS avg_addiction
FROM social_media_data
GROUP BY age, gender
ORDER BY age;


-- ============================================================
-- 7. SLEEP ANALYSIS
-- ============================================================

-- : Sleep buckets vs anxiety & depression
SELECT
    CASE
        WHEN sleep_hours < 5 THEN 'Very Low (<5 hrs)'
        WHEN sleep_hours < 6 THEN 'Low (5-6 hrs)'
        WHEN sleep_hours < 7 THEN 'Moderate (6-7 hrs)'
        ELSE                      'Good (7+ hrs)'
    END                                         AS sleep_bucket,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(academic_performance)::NUMERIC, 2)         AS avg_academic_perf,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)       AS depression_rate_pct
FROM social_media_data
GROUP BY sleep_bucket
ORDER BY avg_anxiety DESC;

-- : Sleep vs anxiety by age (proxy correlation)
SELECT
    age,
    FLOOR(sleep_hours)                      AS sleep_bucket,
    COUNT(*)                                AS total_teens,
    ROUND(AVG(anxiety_level)::NUMERIC, 1)            AS avg_anxiety
FROM social_media_data
GROUP BY age, sleep_bucket
ORDER BY age, sleep_bucket;

-- : Screen time before sleep vs sleep quality
SELECT
    CASE
        WHEN screen_time_before_sleep < 1 THEN 'Very Low (<1 hr)'
        WHEN screen_time_before_sleep < 2 THEN 'Low (1-2 hrs)'
        WHEN screen_time_before_sleep < 3 THEN 'Moderate (2-3 hrs)'
        ELSE                                   'High (3+ hrs)'
    END                                         AS screen_bucket,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(sleep_hours)::NUMERIC, 2)                  AS avg_sleep,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress
FROM social_media_data
GROUP BY screen_bucket
ORDER BY avg_sleep DESC;


-- ============================================================
-- 8. DEPRESSION RISK PROFILE
-- ============================================================

-- : Depression by gender + platform
SELECT
    gender,
    platform_usage,
    ROUND(AVG(sleep_hours)::NUMERIC, 1)              AS avg_sleep,
    ROUND(AVG(stress_level)::NUMERIC, 1)             AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 1)            AS avg_anxiety,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 1) AS avg_sm_hours,
    COUNT(*)                                AS depression_count
FROM social_media_data
WHERE depression_label = 1
GROUP BY gender, platform_usage
ORDER BY depression_count DESC;

-- : Depressed vs Non-depressed comparison
SELECT
    CASE WHEN depression_label = 1 THEN 'Depressed' ELSE 'Not Depressed' END AS status,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 2)     AS avg_sm_hours,
    ROUND(AVG(sleep_hours)::NUMERIC, 2)                  AS avg_sleep,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 2)              AS avg_addiction,
    ROUND(AVG(academic_performance)::NUMERIC, 2)         AS avg_academic_perf
FROM social_media_data
GROUP BY status;

-- : All depressed teens — full profile
SELECT
     age, gender, platform_usage,
    daily_social_media_hours, sleep_hours,
    stress_level, anxiety_level, addiction_level,
    academic_performance, social_interaction_level
FROM social_media_data
WHERE depression_label = 1
ORDER BY stress_level DESC;

-- : Depression rate by age group + gender
SELECT
    CASE
        WHEN age BETWEEN 13 AND 14 THEN '13-14'
        WHEN age BETWEEN 15 AND 16 THEN '15-16'
        WHEN age BETWEEN 17 AND 18 THEN '17-18'
        ELSE '19+'
    END                                              AS age_group,
    gender,
    COUNT(*)                                         AS total_teens,
    SUM(depression_label)                            AS depressed_count,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)   AS depression_rate_pct
FROM social_media_data
GROUP BY
    CASE
        WHEN age BETWEEN 13 AND 14 THEN '13-14'
        WHEN age BETWEEN 15 AND 16 THEN '15-16'
        WHEN age BETWEEN 17 AND 18 THEN '17-18'
        ELSE '19+'
    END,
    gender
ORDER BY age_group, gender;
-- ============================================================
-- 9. SOCIAL INTERACTION LEVEL ANALYSIS
-- ============================================================

-- : Social interaction vs mental health
SELECT
    social_interaction_level,
    COUNT(*)                                    AS total_teens,
    ROUND(AVG(daily_social_media_hours)::NUMERIC, 2)     AS avg_sm_hours,
    ROUND(AVG(stress_level)::NUMERIC, 2)                 AS avg_stress,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)                AS avg_anxiety,
    ROUND(AVG(addiction_level)::NUMERIC, 2)              AS avg_addiction,
    ROUND(AVG(depression_label)::NUMERIC * 100, 2)       AS depression_rate_pct
FROM social_media_data
GROUP BY social_interaction_level
ORDER BY avg_anxiety DESC;

-- : Social interaction + platform combination
SELECT
    platform_usage,
    social_interaction_level,
    COUNT(*)                            AS total_teens,
    ROUND(AVG(anxiety_level)::NUMERIC, 2)        AS avg_anxiety,
    ROUND(AVG(stress_level)::NUMERIC, 2)         AS avg_stress
FROM social_media_data
GROUP BY platform_usage, social_interaction_level
ORDER BY platform_usage, avg_anxiety DESC;


-- ============================================================
-- 10. WINDOW FUNCTIONS
-- ============================================================

-- : Rank top 10% most addicted teens
WITH ranked AS (
    SELECT
        age, gender, platform_usage,
        daily_social_media_hours,
        sleep_hours, stress_level, anxiety_level,
        addiction_level, depression_label,
        NTILE(10) OVER (ORDER BY addiction_level DESC) AS decile
    FROM social_media_data
)
SELECT *
FROM ranked
WHERE decile = 1
ORDER BY addiction_level DESC;


-- : Rank teens by stress within each platform

SELECT
    age,
    gender,
    platform_usage,
    daily_social_media_hours,
    sleep_hours,
    stress_level,
    anxiety_level,
    RANK() OVER (PARTITION BY platform_usage ORDER BY stress_level DESC) AS stress_rank
FROM social_media_data
ORDER BY platform_usage, stress_rank;


-- : Top 5 most stressed teens per platform
WITH stress_ranked AS (
    SELECT
        age, gender, platform_usage,
        stress_level, anxiety_level, depression_label,
        ROW_NUMBER() OVER (PARTITION BY platform_usage ORDER BY stress_level DESC) AS rn
    FROM social_media_data
)
SELECT *
FROM stress_ranked
WHERE rn <= 5;


-- ============================================================
-- 11. CORRELATION / RISK QUERIES
-- ============================================================

-- : High-risk teens (high SM + low sleep + high stress)
SELECT
    age, gender, platform_usage,
    daily_social_media_hours, sleep_hours,
    stress_level, anxiety_level, addiction_level, depression_label
FROM social_media_data
WHERE daily_social_media_hours > 6
  AND sleep_hours < 6
  AND stress_level > 7
ORDER BY stress_level DESC;

-- : Count high-risk teens
SELECT COUNT(*) AS high_risk_teens
FROM social_media_data
WHERE daily_social_media_hours > 6
  AND sleep_hours < 6
  AND stress_level >= 7;


-- ============================================================
-- 12. FINAL EXECUTIVE SUMMARY
-- ============================================================

-- : Complete executive summary — one query
SELECT 'Total Teens'           AS metric, CAST(COUNT(*) AS VARCHAR)                                          AS value FROM social_media_data
UNION ALL
SELECT 'Avg SM Hours',          CAST(ROUND(AVG(daily_social_media_hours)::NUMERIC, 2) AS VARCHAR)             FROM social_media_data
UNION ALL
SELECT 'Avg Sleep Hours',       CAST(ROUND(AVG(sleep_hours)::NUMERIC, 2) AS VARCHAR)                         FROM social_media_data
UNION ALL
SELECT 'Avg Stress Level',      CAST(ROUND(AVG(stress_level)::NUMERIC, 2) AS VARCHAR)                        FROM social_media_data
UNION ALL
SELECT 'Avg Anxiety Level',     CAST(ROUND(AVG(anxiety_level)::NUMERIC, 2) AS VARCHAR)                       FROM social_media_data
UNION ALL
SELECT 'Avg Addiction Level',   CAST(ROUND(AVG(addiction_level)::NUMERIC, 2) AS VARCHAR)                     FROM social_media_data
UNION ALL
SELECT 'Depressed Teens',       CAST(SUM(depression_label) AS VARCHAR)                                       FROM social_media_data
UNION ALL
SELECT 'Depression Rate %',     CAST(ROUND(AVG(depression_label)::NUMERIC * 100, 2) AS VARCHAR)              FROM social_media_data;
