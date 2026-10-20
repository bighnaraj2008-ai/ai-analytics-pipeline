-- ============================================================================
-- executive_dashboard.sql
-- High-level KPI aggregations for executive summary dashboards.
-- ============================================================================

-- Monthly High-level Summary
SELECT
    report_month,
    active_days,
    total_daily_active_user_instances,
    total_requests,
    total_tokens,
    total_estimated_cost_usd,
    avg_daily_error_rate_pct,
    avg_p95_latency_ms
FROM agg_monthly_costs;

-- Revenue Plan vs AI Usage Attribution
SELECT
    u.plan_type,
    COUNT(DISTINCT u.user_id) AS user_count,
    SUM(u.total_sessions) AS total_sessions,
    SUM(u.lifetime_tokens) AS aggregated_tokens,
    ROUND(SUM(u.lifetime_tokens) * 0.000002, 4) AS estimated_plan_cost_usd
FROM dim_users u
GROUP BY u.plan_type
ORDER BY aggregated_tokens DESC;
