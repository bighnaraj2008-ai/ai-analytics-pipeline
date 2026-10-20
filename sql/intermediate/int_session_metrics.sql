-- ============================================================================
-- int_session_metrics.sql
-- Intermediate layer: sessionization + token aggregation.
--
-- Logic:
--   1. Order events per user by timestamp.
--   2. Flag a new session when the gap from the previous event exceeds
--      SESSION_GAP_MINUTES (30 minutes) or when no previous event exists.
--   3. Assign a session number via a running sum of the new-session flag.
--   4. Aggregate per user/session: duration, request count, tokens, latency,
--      error count, average feedback rating.
-- ============================================================================

CREATE OR REPLACE VIEW int_session_metrics AS
WITH ordered_events AS (
    SELECT
        e.*,
        LAG(event_timestamp) OVER (
            PARTITION BY user_id ORDER BY event_timestamp
        ) AS prev_ts
    FROM stg_ai_events e
),
session_flags AS (
    SELECT
        *,
        CASE
            WHEN prev_ts IS NULL THEN 1
            WHEN EXTRACT(EPOCH FROM (event_timestamp - prev_ts)) / 60.0 > 30 THEN 1
            ELSE 0
        END AS new_session_flag
    FROM ordered_events
),
sessionized AS (
    SELECT
        *,
        SUM(new_session_flag) OVER (
            PARTITION BY user_id
            ORDER BY event_timestamp
            ROWS UNBOUNDED PRECEDING
        ) AS session_num
    FROM session_flags
),
sessions AS (
    SELECT
        user_id,
        session_num,
        MIN(event_timestamp)                                          AS session_started_at,
        MAX(event_timestamp)                                          AS session_ended_at,
        COUNT(*) FILTER (WHERE event_type = 'model_request')          AS request_count,
        SUM(tokens_used)                                              AS total_tokens,
        AVG(latency_ms) FILTER (WHERE event_type = 'model_request')   AS avg_latency_ms,
        MAX(latency_ms) FILTER (WHERE event_type = 'model_request')   AS max_latency_ms,
        COUNT(*) FILTER (WHERE status = 'error')                      AS error_count,
        AVG(feedback_rating)                                          AS avg_feedback_rating
    FROM sessionized
    GROUP BY user_id, session_num
)
SELECT
    user_id,
    session_num,
    session_started_at,
    session_ended_at,
    EXTRACT(EPOCH FROM (session_ended_at - session_started_at)) / 60.0 AS session_duration_min,
    request_count,
    total_tokens,
    avg_latency_ms,
    max_latency_ms,
    error_count,
    avg_feedback_rating
FROM sessions;

SELECT 'int_session_metrics view created' AS status;
