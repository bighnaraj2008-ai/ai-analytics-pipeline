-- ============================================================================
-- fct_user_sessions.sql
-- Mart layer: session reporting fact table (view).
-- Provides session-level duration, request counts, tokens, and quality scores.
-- ============================================================================

CREATE OR REPLACE VIEW fct_user_sessions AS
SELECT
    user_id || '-' || session_num                               AS session_id,
    user_id,
    session_num,
    session_started_at,
    session_ended_at,
    ROUND(session_duration_min::numeric, 2)                     AS session_duration_min,
    request_count,
    total_tokens,
    ROUND(avg_latency_ms::numeric, 2)                           AS avg_latency_ms,
    max_latency_ms,
    error_count,
    ROUND(avg_feedback_rating::numeric, 2)                     AS avg_feedback_rating
FROM int_session_metrics;

SELECT 'fct_user_sessions view created' AS status;
