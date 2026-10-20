-- ============================================================================
-- indexes_tuning.sql
-- Performance indexing script for high-volume analytics workloads.
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_raw_ai_events_user_id
    ON raw_ai_events (user_id);

CREATE INDEX IF NOT EXISTS idx_raw_ai_events_timestamp
    ON raw_ai_events (event_timestamp);

CREATE INDEX IF NOT EXISTS idx_raw_ai_events_user_ts
    ON raw_ai_events (user_id, event_timestamp);

CREATE INDEX IF NOT EXISTS idx_raw_ai_events_type_model
    ON raw_ai_events (event_type, model_name);

CREATE INDEX IF NOT EXISTS idx_raw_users_created_at
    ON raw_users (created_at);

SELECT 'Performance tuning indexes created successfully.' AS status;
