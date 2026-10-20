-- ============================================================================
-- agg_monthly_costs.sql
-- Mart layer: executive monthly financial and usage summary.
-- ============================================================================

CREATE OR REPLACE VIEW agg_monthly_costs AS
SELECT
    DATE_TRUNC('month', event_date)::date                       AS report_month,
    COUNT(DISTINCT event_date)                                  AS active_days,
    SUM(dau)                                                    AS total_daily_active_user_instances,
    SUM(total_requests)                                         AS total_requests,
    SUM(total_tokens)                                           AS total_tokens,
    SUM(estimated_token_cost_usd)                               AS total_estimated_cost_usd,
    ROUND(AVG(model_error_rate_pct)::numeric, 2)                AS avg_daily_error_rate_pct,
    ROUND(AVG(p95_latency_ms)::numeric, 2)                      AS avg_p95_latency_ms
FROM fct_ai_usage_daily
GROUP BY DATE_TRUNC('month', event_date)::date;

SELECT 'agg_monthly_costs view created' AS status;
