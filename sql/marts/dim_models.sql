-- ============================================================================
-- dim_models.sql
-- Mart layer: LLM model dimension table.
-- Contains model capabilities, context windows, and base pricing metrics.
-- ============================================================================

CREATE TABLE IF NOT EXISTS dim_models (
    model_name VARCHAR(50) PRIMARY KEY,
    provider VARCHAR(50) NOT NULL,
    model_family VARCHAR(50) NOT NULL,
    cost_per_1k_tokens NUMERIC(8,6) NOT NULL,
    context_window_tokens INTEGER NOT NULL
);

INSERT INTO dim_models (model_name, provider, model_family, cost_per_1k_tokens, context_window_tokens)
VALUES
    ('gpt-4', 'OpenAI', 'Frontier LLM', 0.030000, 128000),
    ('claude-3', 'Anthropic', 'Frontier Multi-modal', 0.015000, 200000),
    ('gpt-3.5-turbo', 'OpenAI', 'High-throughput LLM', 0.001500, 16384)
ON CONFLICT (model_name) DO NOTHING;

SELECT 'dim_models dimension table created' AS status;
