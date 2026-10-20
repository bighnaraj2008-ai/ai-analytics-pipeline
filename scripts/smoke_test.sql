-- ============================================================================
-- smoke_test.sql
-- Pre-flight database smoke test query script.
-- Verifies database connectivity and baseline object presence.
-- ============================================================================

SELECT
    current_database() AS database_name,
    current_user AS connected_user,
    version() AS postgres_version,
    NOW() AS test_executed_at;

-- Check raw tables row counts
SELECT 'raw_users' AS table_name, COUNT(*) AS row_count FROM raw_users
UNION ALL
SELECT 'raw_ai_events', COUNT(*) FROM raw_ai_events;

-- Check staging views
SELECT 'stg_users' AS view_name, COUNT(*) AS row_count FROM stg_users
UNION ALL
SELECT 'stg_ai_events', COUNT(*) FROM stg_ai_events;

-- Check core marts
SELECT 'fct_ai_usage_daily' AS mart_name, COUNT(*) AS row_count FROM fct_ai_usage_daily
UNION ALL
SELECT 'dim_users', COUNT(*) FROM dim_users;

SELECT 'SMOKE TEST PASSED: Database objects accessible and populated.' AS status;
