-- ============================================================================
-- stg_ai_events.sql
-- Staging layer: clean, cast, and rename raw AI events.
-- Filters out records missing critical identifiers/timestamps.
-- ============================================================================

CREATE OR REPLACE VIEW stg_ai_events AS
SELECT
    event_id,
    user_id,
    lower(trim(event_type))                                 AS event_type,
    lower(trim(model_name))                                 AS model_name,
    tokens_used                                             AS tokens_used,
    latency_ms                                              AS latency_ms,
    event_timestamp                                         AS event_timestamp,
    lower(trim(status))                                     AS status,
    feedback_rating                                         AS feedback_rating
FROM raw_ai_events
WHERE event_timestamp IS NOT NULL
  AND user_id IS NOT NULL;

SELECT 'stg_ai_events view created' AS status;
