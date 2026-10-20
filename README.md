# ai-analytics-pipeline

Production-grade, **pure SQL** analytics pipeline for LLM/AI usage telemetry, built on Dockerized PostgreSQL with dimensional modeling (staging → intermediate → marts), automated SQL schema assertions, and a comprehensive metric dictionary.

> **Pure SQL only.** All transformations and sessionization algorithms are implemented natively in PostgreSQL. No Python or Spark dependencies are required for data transformations.

---

## Local Setup (Docker)

### Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose

### 1. Start PostgreSQL Container

```bash
cd docker
docker compose up -d
```

### 2. Execute SQL Pipeline in Sequence

```bash
export PGPASSWORD=analytics

# 1. Seed raw data
psql -h localhost -U analytics -d ai_analytics -f sql/seed_raw_events.sql

# 2. Build staging models
psql -h localhost -U analytics -d ai_analytics -f sql/staging/stg_users.sql
psql -h localhost -U analytics -d ai_analytics -f sql/staging/stg_ai_events.sql
psql -h localhost -U analytics -d ai_analytics -f sql/staging/stg_model_requests.sql
psql -h localhost -U analytics -d ai_analytics -f sql/staging/stg_feedback.sql

# 3. Build intermediate models
psql -h localhost -U analytics -d ai_analytics -f sql/intermediate/int_session_metrics.sql
psql -h localhost -U analytics -d ai_analytics -f sql/intermediate/int_token_aggregates.sql
psql -h localhost -U analytics -d ai_analytics -f sql/intermediate/int_user_activity.sql

# 4. Build marts models
psql -h localhost -U analytics -d ai_analytics -f sql/marts/dim_users.sql
psql -h localhost -U analytics -d ai_analytics -f sql/marts/dim_models.sql
psql -h localhost -U analytics -d ai_analytics -f sql/marts/fct_ai_usage_daily.sql
psql -h localhost -U analytics -d ai_analytics -f sql/marts/fct_user_sessions.sql
psql -h localhost -U analytics -d ai_analytics -f sql/marts/agg_monthly_costs.sql
```
