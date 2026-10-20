-- ============================================================================
-- int_user_retention.sql
-- Intermediate layer: cohort-based user retention calculation.
-- Groups users into weekly cohorts based on sign-up and evaluates retention weeks.
-- ============================================================================

CREATE OR REPLACE VIEW int_user_retention AS
WITH user_cohort AS (
    SELECT
        user_id,
        DATE_TRUNC('week', created_at)::date                   AS cohort_week
    FROM stg_users
),
user_activity_weeks AS (
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('week', event_timestamp)::date              AS activity_week
    FROM stg_ai_events
)
SELECT
    c.cohort_week,
    a.activity_week,
    FLOOR((a.activity_week - c.cohort_week) / 7.0)::int        AS week_number,
    COUNT(DISTINCT c.user_id)                                  AS active_users
FROM user_cohort c
JOIN user_activity_weeks a
    ON c.user_id = a.user_id
GROUP BY c.cohort_week, a.activity_week, 3;

SELECT 'int_user_retention view created' AS status;
