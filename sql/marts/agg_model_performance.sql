-- ============================================================================
-- agg_model_performance.sql
-- Mart layer: aggregated LLM model SLA and quality comparison.
-- ============================================================================

CREATE OR REPLACE VIEW agg_model_performance AS
SELECT
    m.model_name,
    COUNT(*)                                                                    AS total_requests,
    COALESCE(SUM(m.tokens_used), 0)                                             AS total_tokens,
    ROUND(AVG(m.latency_ms)::numeric, 2)                                        AS avg_latency_ms,
    percentile_cont(0.95) WITHIN GROUP (ORDER BY m.latency_ms)                 AS p95_latency_ms,
    ROUND(COUNT(*) FILTER (WHERE m.status = 'error')::numeric * 100.0 / NULLIF(COUNT(*), 0), 2) AS error_rate_pct
FROM stg_model_requests m
GROUP BY m.model_name;

SELECT 'agg_model_performance view created' AS status;
