-- ============================================================================
-- assert_positive_token_counts.sql
-- Schema test: asserts all token consumption records are strictly non-negative.
-- ============================================================================

\set ON_ERROR_STOP on

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM raw_ai_events WHERE tokens_used < 0) > 0 THEN
        RAISE EXCEPTION 'assert_positive_token_counts failed: negative tokens detected';
    END IF;
END $$;

SELECT 'PASS: assert_positive_token_counts' AS status;
