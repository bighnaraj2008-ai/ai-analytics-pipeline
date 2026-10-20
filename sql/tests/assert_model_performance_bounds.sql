-- ============================================================================
-- assert_model_performance_bounds.sql
-- Schema test: verifies model performance error rates and latencies are within bounds.
-- ============================================================================

\set ON_ERROR_STOP on

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM agg_model_performance
        WHERE error_rate_pct < 0 OR error_rate_pct > 100
           OR avg_latency_ms < 0 OR p95_latency_ms < 0) > 0 THEN
        RAISE EXCEPTION 'assert_model_performance_bounds failed: out of bounds metrics';
    END IF;
END $$;

SELECT 'PASS: assert_model_performance_bounds' AS status;
