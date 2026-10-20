-- ============================================================================
-- grant_permissions.sql
-- Role and permission management for AI analytics warehouse.
-- ============================================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'analytics_reader') THEN
        CREATE ROLE analytics_reader;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'pipeline_runner') THEN
        CREATE ROLE pipeline_runner;
    END IF;
END $$;

GRANT USAGE ON SCHEMA public TO analytics_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analytics_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO analytics_reader;

GRANT ALL PRIVILEGES ON SCHEMA public TO pipeline_runner;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO pipeline_runner;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO pipeline_runner;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO pipeline_runner;

SELECT 'Permissions granted successfully.' AS status;
