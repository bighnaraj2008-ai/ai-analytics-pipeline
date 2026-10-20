-- ============================================================================
-- seed_raw_events.sql
-- Mock raw data insertion script for the AI Analytics Pipeline.
--
-- Creates raw source tables covering:
--   - raw user profiles
--   - raw AI events (model requests, feedback, session boundaries)
-- ============================================================================

-- Raw source: user profiles
CREATE TABLE IF NOT EXISTS raw_users (
    user_id SERIAL PRIMARY KEY,
    email TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    country TEXT NOT NULL,
    plan_type TEXT NOT NULL
        CHECK (plan_type IN ('free', 'starter', 'pro', 'enterprise'))
);

-- Raw source: AI events (sessions, model requests, feedback)
CREATE TABLE IF NOT EXISTS raw_ai_events (
    event_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES raw_users(user_id),
    event_type TEXT NOT NULL
        CHECK (event_type IN ('model_request', 'feedback', 'session_start', 'session_end')),
    model_name TEXT,
    tokens_used INTEGER,
    latency_ms INTEGER,
    event_timestamp TIMESTAMP NOT NULL,
    status TEXT NOT NULL
        CHECK (status IN ('success', 'error')),
    feedback_rating INTEGER
        CHECK (feedback_rating BETWEEN 1 AND 5)
);

-- Idempotent re-seeding: clear tables first
TRUNCATE TABLE raw_ai_events RESTART IDENTITY CASCADE;
TRUNCATE TABLE raw_users RESTART IDENTITY CASCADE;
