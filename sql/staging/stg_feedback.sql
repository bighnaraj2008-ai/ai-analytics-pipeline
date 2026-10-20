-- ============================================================================
-- stg_feedback.sql
-- Staging layer: specialized staging view for user feedback rating events.
-- ============================================================================

CREATE OR REPLACE VIEW stg_feedback AS
SELECT
    event_id,
    user_id,
    event_timestamp,
    DATE_TRUNC('day', event_timestamp)::date                AS event_date,
    feedback_rating                                         AS feedback_rating,
    lower(trim(status))                                     AS status
FROM raw_ai_events
WHERE event_type = 'feedback'
  AND feedback_rating IS NOT NULL;

SELECT 'stg_feedback view created' AS status;
