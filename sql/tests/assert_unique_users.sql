-- ============================================================================
-- assert_unique_users.sql
-- Schema test: verifies primary key uniqueness in dim_users.
-- ============================================================================

\set ON_ERROR_STOP on

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM (
        SELECT user_id FROM dim_users GROUP BY user_id HAVING COUNT(*) > 1
    ) dupes) > 0 THEN
        RAISE EXCEPTION 'assert_unique_users failed: duplicate user_id found in dim_users';
    END IF;
END $$;

SELECT 'PASS: assert_unique_users' AS status;
