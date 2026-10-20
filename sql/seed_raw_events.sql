-- ============================================================================
-- seed_raw_events.sql
-- Mock raw data insertion script for the AI Analytics Pipeline.
--
-- Creates raw source tables and inserts synthetic data covering:
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

-- Idempotent re-seeding: clear dependent table first
TRUNCATE TABLE raw_ai_events RESTART IDENTITY CASCADE;
TRUNCATE TABLE raw_users RESTART IDENTITY CASCADE;

-- ----------------------------------------------------------------------------
-- Raw users
-- ----------------------------------------------------------------------------
INSERT INTO raw_users (email, created_at, country, plan_type) VALUES
    ('alice@example.com',  '2026-01-10 08:00:00', 'US',  'pro'),
    ('bob@example.com',    '2026-01-12 09:30:00', 'CA',  'starter'),
    ('carol@example.com',  '2026-01-15 10:00:00', 'GB',  'free'),
    ('dave@example.com',   '2026-01-18 11:00:00', 'DE',  'enterprise'),
    ('eve@example.com',    '2026-01-20 12:00:00', 'US',  'pro');

-- ----------------------------------------------------------------------------
-- Raw AI events: User session boundaries
-- ----------------------------------------------------------------------------
INSERT INTO raw_ai_events (user_id, event_type, model_name, tokens_used, latency_ms, event_timestamp, status, feedback_rating) VALUES
    (1, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 09:00:00', 'success', NULL),
    (1, 'session_end',    NULL,        NULL,       NULL, '2026-02-01 09:12:00', 'success', NULL),
    (2, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 10:00:00', 'success', NULL),
    (3, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 11:00:00', 'success', NULL),
    (3, 'session_end',    NULL,        NULL,       NULL, '2026-02-01 11:08:00', 'success', NULL),
    (3, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 14:00:00', 'success', NULL),
    (3, 'session_end',    NULL,        NULL,       NULL, '2026-02-01 14:10:00', 'success', NULL),
    (4, 'session_start',  NULL,        NULL,       NULL, '2026-02-02 09:00:00', 'success', NULL),
    (4, 'session_end',    NULL,        NULL,       NULL, '2026-02-02 09:15:00', 'success', NULL),
    (5, 'session_start',  NULL,        NULL,       NULL, '2026-02-02 10:00:00', 'success', NULL),
    (5, 'session_end',    NULL,        NULL,       NULL, '2026-02-02 10:10:00', 'success', NULL);
