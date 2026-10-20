-- ============================================================================
-- stg_users.sql
-- Staging layer: clean, cast, and rename raw user profiles.
-- ============================================================================

CREATE OR REPLACE VIEW stg_users AS
SELECT
    user_id,
    lower(trim(email))                                      AS email,
    created_at                                              AS created_at,
    upper(trim(country))                                    AS country,
    lower(trim(plan_type))                                  AS plan_type
FROM raw_users;

SELECT 'stg_users view created' AS status;
