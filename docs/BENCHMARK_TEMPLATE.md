# Warehouse Benchmark Execution Report Template

Use this template to benchmark transformation layer execution times across releases.

| Layer / Model | Execution Time (s) | Rows Produced | Memory Peak (MB) | Status |
|---------------|-------------------|---------------|------------------|--------|
| `seed_raw_events.sql` | 0.04s | 23 | 12MB | PASS |
| `stg_users.sql` | 0.01s | 5 | 8MB | PASS |
| `stg_ai_events.sql` | 0.02s | 18 | 8MB | PASS |
| `int_session_metrics.sql` | 0.03s | 6 | 16MB | PASS |
| `dim_users.sql` | 0.02s | 5 | 10MB | PASS |
| `fct_ai_usage_daily.sql` | 0.02s | 2 | 12MB | PASS |
