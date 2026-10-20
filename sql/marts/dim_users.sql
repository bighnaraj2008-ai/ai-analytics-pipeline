-- ============================================================================
-- dim_users.sql
-- Mart layer: user dimension.
-- One row per user with lifetime session and token aggregations.
-- ============================================================================

CREATE OR REPLACE VIEW dim_users AS
SELECT
    u.user_id,
    u.email,
    u.country,
    u.plan_type,
    u.created_at                                          AS user_created_at,
    COUNT(s.session_num)                                  AS total_sessions,
    COALESCE(SUM(s.total_tokens), 0)                      AS lifetime_tokens
FROM stg_users u
LEFT JOIN int_session_metrics s
    ON s.user_id = u.user_id
GROUP BY
    u.user_id, u.email, u.country, u.plan_type, u.created_at;

SELECT 'dim_users view created' AS status;
