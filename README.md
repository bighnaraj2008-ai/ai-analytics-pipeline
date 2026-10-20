# ai-analytics-pipeline

Production-grade, **pure SQL** analytics pipeline for LLM/AI usage telemetry, built on Dockerized PostgreSQL with dimensional modeling (staging → intermediate → marts), automated SQL schema assertions, and a comprehensive metric dictionary.

> **Pure SQL only.** All transformations and sessionization algorithms are implemented natively in PostgreSQL. No Python or Spark dependencies are required for data transformations.

---

## Documentation

- [Architecture Guide](docs/ARCHITECTURE.md) - Layer transformation flow and dimensional schema design.
- [Metrics Dictionary](docs/METRICS_DICTIONARY.md) - Formal business definitions for DAU, token spend, error rates, and P95 latency.

---

## Local Setup (Docker)

### 1. Start PostgreSQL Container

```bash
cd docker
docker compose up -d
```

### 2. Execute SQL Pipeline in Sequence

```bash
export PGPASSWORD=analytics
psql -h localhost -U analytics -d ai_analytics -f sql/seed_raw_events.sql
psql -h localhost -U analytics -d ai_analytics -f sql/staging/stg_users.sql
psql -h localhost -U analytics -d ai_analytics -f sql/staging/stg_ai_events.sql
psql -h localhost -U analytics -d ai_analytics -f sql/intermediate/int_session_metrics.sql
psql -h localhost -U analytics -d ai_analytics -f sql/marts/dim_users.sql
psql -h localhost -U analytics -d ai_analytics -f sql/marts/fct_ai_usage_daily.sql
```
