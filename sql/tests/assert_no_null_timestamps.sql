-- ============================================================================
-- assert_no_null_timestamps.sql
-- Schema test: verifies non-null event timestamps across daily fact reporting.
-- ============================================================================

\set ON_ERROR_STOP on

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM fct_ai_usage_daily WHERE event_date IS NULL) > 0 THEN
        RAISE EXCEPTION 'assert_no_null_timestamps failed: null dates detected in fct_ai_usage_daily';
    END IF;
END $$;

SELECT 'PASS: assert_no_null_timestamps' AS status;
