-- ============================================================================
-- assert_retention_percentages.sql
-- Schema test: verifies retention percentages are strictly within 0% to 100%.
-- ============================================================================

\set ON_ERROR_STOP on

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM fct_user_retention_cohorts
        WHERE retention_rate_pct < 0 OR retention_rate_pct > 100) > 0 THEN
        RAISE EXCEPTION 'assert_retention_percentages failed: invalid retention percentage';
    END IF;
END $$;

SELECT 'PASS: assert_retention_percentages' AS status;
