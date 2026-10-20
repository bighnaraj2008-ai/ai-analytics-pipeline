-- ============================================================================
-- staging/__init__.sql
-- Staging layer module initialization.
--
-- The staging layer cleans, casts, and renames raw ingestion tables with a 1:1
-- relationship to raw sources, applying standardized column casing and typing.
-- ============================================================================

SELECT 'Staging layer initialized' AS status;
