-- ============================================================================
-- stg_model_requests.sql
-- Staging layer: specialized staging view for model request events.
-- Filters exclusively for event_type = 'model_request' and normalizes token attributes.
-- ============================================================================

CREATE OR REPLACE VIEW stg_model_requests AS
SELECT
    event_id,
    user_id,
    lower(trim(model_name))                                 AS model_name,
    tokens_used                                             AS tokens_used,
    latency_ms                                              AS latency_ms,
    event_timestamp                                         AS event_timestamp,
    DATE_TRUNC('day', event_timestamp)::date                AS event_date,
    lower(trim(status))                                     AS status
FROM raw_ai_events
WHERE event_type = 'model_request'
  AND event_timestamp IS NOT NULL
  AND user_id IS NOT NULL;

SELECT 'stg_model_requests view created' AS status;
