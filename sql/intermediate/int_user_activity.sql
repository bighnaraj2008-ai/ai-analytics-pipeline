-- ============================================================================
-- int_user_activity.sql
-- Intermediate layer: daily engagement roll-up per user.
-- ============================================================================

CREATE OR REPLACE VIEW int_user_activity AS
SELECT
    user_id,
    DATE_TRUNC('day', event_timestamp)::date                AS activity_date,
    COUNT(*)                                                AS total_events,
    COUNT(*) FILTER (WHERE event_type = 'model_request')    AS request_count,
    COALESCE(SUM(tokens_used), 0)                           AS total_tokens,
    COUNT(*) FILTER (WHERE status = 'error')                AS error_count,
    AVG(feedback_rating)                                    AS avg_feedback_rating
FROM stg_ai_events
GROUP BY user_id, DATE_TRUNC('day', event_timestamp)::date;

SELECT 'int_user_activity view created' AS status;
