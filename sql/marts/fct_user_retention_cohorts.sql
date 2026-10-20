-- ============================================================================
-- fct_user_retention_cohorts.sql
-- Mart layer: weekly cohort retention analysis view.
-- ============================================================================

CREATE OR REPLACE VIEW fct_user_retention_cohorts AS
WITH cohort_sizes AS (
    SELECT
        DATE_TRUNC('week', created_at)::date                   AS cohort_week,
        COUNT(DISTINCT user_id)                                AS cohort_size
    FROM stg_users
    GROUP BY 1
)
SELECT
    r.cohort_week,
    cs.cohort_size,
    r.week_number,
    r.active_users,
    ROUND(r.active_users::numeric * 100.0 / NULLIF(cs.cohort_size, 0), 2) AS retention_rate_pct
FROM int_user_retention r
JOIN cohort_sizes cs
    ON r.cohort_week = cs.cohort_week
ORDER BY r.cohort_week, r.week_number;

SELECT 'fct_user_retention_cohorts view created' AS status;
