-- ============================================================================
-- fct_ai_usage_daily.sql
-- Mart layer: daily AI usage fact table (view).
-- One row per day with DAU, token cost, error rate, and P95 latency.
--
-- Metric notes:
--   - estimated_token_cost_usd: total_tokens * $0.000002 per token (example rate)
--   - token_cost_per_user_usd: estimated cost / DAU
--   - model_error_rate_pct: errored requests / total requests * 100
--   - p95_latency_ms: 95th percentile latency across model requests
-- ============================================================================

CREATE OR REPLACE VIEW fct_ai_usage_daily AS
WITH daily_agg AS (
    SELECT
        DATE_TRUNC('day', event_timestamp)::date AS event_date,
        COUNT(DISTINCT user_id)                  AS dau,
        COUNT(*) FILTER (WHERE event_type = 'model_request') AS total_requests,
        SUM(tokens_used)                         AS total_tokens,
        COUNT(*) FILTER (WHERE status = 'error') AS error_requests,
        AVG(latency_ms) FILTER (WHERE event_type = 'model_request') AS avg_latency_ms
    FROM stg_ai_events
    GROUP BY 1
),
latency_p95 AS (
    SELECT
        DATE_TRUNC('day', event_timestamp)::date AS event_date,
        percentile_cont(0.95) WITHIN GROUP (ORDER BY latency_ms) AS p95_latency_ms
    FROM stg_ai_events
    WHERE event_type = 'model_request'
      AND latency_ms IS NOT NULL
    GROUP BY 1
)
SELECT
    d.event_date,
    d.dau,
    d.total_requests,
    d.total_tokens,
    ROUND(CAST(d.total_tokens AS NUMERIC) * 0.000002, 4)                          AS estimated_token_cost_usd,
    ROUND(CAST(d.total_tokens AS NUMERIC) * 0.000002 / NULLIF(d.dau, 0), 6)      AS token_cost_per_user_usd,
    ROUND(CAST(d.error_requests AS NUMERIC) * 100.0 / NULLIF(d.total_requests, 0), 2) AS model_error_rate_pct,
    d.avg_latency_ms,
    l.p95_latency_ms
FROM daily_agg d
LEFT JOIN latency_p95 l
    ON l.event_date = d.event_date
ORDER BY d.event_date;

SELECT 'fct_ai_usage_daily view created' AS status;
