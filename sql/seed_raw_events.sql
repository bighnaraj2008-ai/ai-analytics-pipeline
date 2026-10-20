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
-- Raw AI events: User sessions & Model execution requests
-- ----------------------------------------------------------------------------
INSERT INTO raw_ai_events (user_id, event_type, model_name, tokens_used, latency_ms, event_timestamp, status, feedback_rating) VALUES
    -- Alice: single pro session on 2026-02-01
    (1, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 09:00:00', 'success', NULL),
    (1, 'model_request',  'gpt-4',     1200,       850,  '2026-02-01 09:02:00', 'success', NULL),
    (1, 'model_request',  'gpt-4',      950,       720,  '2026-02-01 09:05:00', 'success', NULL),
    (1, 'session_end',    NULL,        NULL,       NULL, '2026-02-01 09:12:00', 'success', NULL),

    -- Bob: starter session with one errored request on 2026-02-01
    (2, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 10:00:00', 'success', NULL),
    (2, 'model_request',  'claude-3',   800,      1200,  '2026-02-01 10:03:00', 'success', NULL),
    (2, 'model_request',  'claude-3',   600,      3000,  '2026-02-01 10:07:00', 'error',   NULL),

    -- Carol: free user, TWO sessions on 2026-02-01 (gap > 30 min)
    (3, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 11:00:00', 'success', NULL),
    (3, 'model_request',  'gpt-3.5-turbo', 400,    400,  '2026-02-01 11:02:00', 'success', NULL),
    (3, 'model_request',  'gpt-3.5-turbo', 350,    380,  '2026-02-01 11:05:00', 'success', NULL),
    (3, 'session_end',    NULL,        NULL,       NULL, '2026-02-01 11:08:00', 'success', NULL),

    (3, 'session_start',  NULL,        NULL,       NULL, '2026-02-01 14:00:00', 'success', NULL),
    (3, 'model_request',  'gpt-3.5-turbo', 500,    450,  '2026-02-01 14:02:00', 'success', NULL),
    (3, 'session_end',    NULL,        NULL,       NULL, '2026-02-01 14:10:00', 'success', NULL),

    -- Dave: enterprise session with errors on 2026-02-02
    (4, 'session_start',  NULL,        NULL,       NULL, '2026-02-02 09:00:00', 'success', NULL),
    (4, 'model_request',  'claude-3',  2000,      1500,  '2026-02-02 09:02:00', 'success', NULL),
    (4, 'model_request',  'claude-3',  1800,      1400,  '2026-02-02 09:05:00', 'success', NULL),
    (4, 'model_request',  'claude-3',  2100,      5000,  '2026-02-02 09:08:00', 'error',   NULL),
    (4, 'session_end',    NULL,        NULL,       NULL, '2026-02-02 09:15:00', 'success', NULL),

    -- Eve: pro session on 2026-02-02
    (5, 'session_start',  NULL,        NULL,       NULL, '2026-02-02 10:00:00', 'success', NULL),
    (5, 'model_request',  'gpt-4',      700,       900,  '2026-02-02 10:02:00', 'success', NULL),
    (5, 'model_request',  'gpt-4',      650,       800,  '2026-02-02 10:05:00', 'success', NULL),
    (5, 'session_end',    NULL,        NULL,       NULL, '2026-02-02 10:10:00', 'success', NULL);
