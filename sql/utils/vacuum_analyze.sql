-- ============================================================================
-- vacuum_analyze.sql
-- Maintenance script to vacuum and analyze raw tables and statistics.
-- ============================================================================

VACUUM ANALYZE raw_users;
VACUUM ANALYZE raw_ai_events;

SELECT 'VACUUM ANALYZE completed successfully.' AS status;
