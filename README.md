# ai-analytics-pipeline

Production-grade, **pure SQL** analytics pipeline for LLM/AI usage telemetry, built on Dockerized PostgreSQL with dimensional modeling (staging → intermediate → marts), automated SQL schema assertions, and a comprehensive metric dictionary.

> **Pure SQL only.** All transformations and sessionization algorithms are implemented natively in PostgreSQL. No Python or Spark dependencies are required for data transformations.

---

## Documentation

- [Architecture Guide](docs/ARCHITECTURE.md) - Layer transformation flow and dimensional schema design.
- [Metrics Dictionary](docs/METRICS_DICTIONARY.md) - Formal business definitions for DAU, token spend, error rates, and P95 latency.
- [Data Governance](docs/DATA_GOVERNANCE.md) - Quality SLAs, retention schedules, and PII protection policies.

---

## Local Setup (Docker)

### 1. Start PostgreSQL Container

```bash
cd docker
docker compose up -d
```

### 2. Execute SQL Pipeline in Sequence

```bash
bash scripts/run_pipeline.sh
bash scripts/run_tests.sh
```
