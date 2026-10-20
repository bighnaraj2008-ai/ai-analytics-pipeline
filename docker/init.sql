-- ============================================================================
-- init.sql
-- PostgreSQL database initialization script for AI Analytics Warehouse.
-- ============================================================================

-- Ensure standard character encoding and timezone
SET client_encoding = 'UTF8';
SET timezone = 'UTC';

-- Install core performance extensions
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS btree_gist;

SELECT 'AI Analytics database initialized successfully' AS init_status;
