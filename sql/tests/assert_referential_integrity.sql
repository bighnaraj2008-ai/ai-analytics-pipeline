-- ============================================================================
-- assert_referential_integrity.sql
-- Schema test: verifies all events reference valid users in dim_users.
-- ============================================================================

\set ON_ERROR_STOP on

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM stg_ai_events e LEFT JOIN dim_users u ON e.user_id = u.user_id WHERE u.user_id IS NULL) > 0 THEN
        RAISE EXCEPTION 'assert_referential_integrity failed: orphaned events detected';
    END IF;
END $$;

SELECT 'PASS: assert_referential_integrity' AS status;
