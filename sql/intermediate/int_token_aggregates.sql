-- ============================================================================
-- int_token_aggregates.sql
-- Intermediate layer: token consumption and cost aggregations by user and model.
-- ============================================================================

CREATE OR REPLACE VIEW int_token_aggregates AS
SELECT
    user_id,
    DATE_TRUNC('day', event_timestamp)::date                AS event_date,
    model_name,
    COUNT(*)                                                AS request_count,
    SUM(tokens_used)                                        AS total_tokens,
    ROUND(CAST(SUM(tokens_used) AS NUMERIC) * 0.000002, 6)  AS estimated_cost_usd,
    AVG(latency_ms)                                         AS avg_latency_ms
FROM stg_model_requests
GROUP BY user_id, DATE_TRUNC('day', event_timestamp)::date, model_name;

SELECT 'int_token_aggregates view created' AS status;
