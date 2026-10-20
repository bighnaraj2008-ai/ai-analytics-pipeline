-- ============================================================================
-- cost_attribution_report.sql
-- Multi-tenant and model attribution cost reporting.
-- ============================================================================

SELECT
    u.user_id,
    u.email,
    u.plan_type,
    t.model_name,
    t.request_count,
    t.total_tokens,
    t.estimated_cost_usd,
    ROUND(t.avg_latency_ms::numeric, 2) AS avg_latency_ms
FROM int_token_aggregates t
JOIN dim_users u ON t.user_id = u.user_id
ORDER BY t.estimated_cost_usd DESC, u.user_id;
