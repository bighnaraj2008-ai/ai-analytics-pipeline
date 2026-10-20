-- ============================================================================
-- sample_queries.sql
-- Common analytical queries for business reporting and exploratory data analysis.
-- ============================================================================

-- 1. Daily Active Users & Token Consumption Trend
SELECT
    event_date,
    dau,
    total_requests,
    total_tokens,
    token_cost_per_user_usd,
    model_error_rate_pct,
    p95_latency_ms
FROM fct_ai_usage_daily
ORDER BY event_date ASC;

-- 2. User Engagement and Lifetime Consumption
SELECT
    user_id,
    email,
    country,
    plan_type,
    user_created_at,
    total_sessions,
    lifetime_tokens
FROM dim_users
ORDER BY lifetime_tokens DESC;
