# ai-analytics-pipeline

Production-grade, **pure SQL** analytics pipeline for LLM/AI usage telemetry, built on Dockerized PostgreSQL with dimensional modeling (staging → intermediate → marts), automated SQL schema assertions, and a comprehensive metric dictionary.

> **Pure SQL only.** All transformations and sessionization algorithms are implemented natively in PostgreSQL. No Python or Spark dependencies are required for data transformations.

---

## Documentation

- [Architecture Guide](docs/ARCHITECTURE.md) - Layer transformation flow and dimensional schema design.
- [Metrics Dictionary](docs/METRICS_DICTIONARY.md) - Formal business definitions for DAU, token spend, error rates, and P95 latency.
- [Data Governance](docs/DATA_GOVERNANCE.md) - Quality SLAs, retention schedules, and PII protection policies.
- [Frequently Asked Questions (FAQ)](docs/FAQ.md) - Design rationale and architecture FAQ.
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Resolving connection and assertion issues.
- [Performance Tuning](docs/PERFORMANCE_TUNING.md) - Warehouse index optimization and configuration settings.
- [Metrics Tree Diagram](docs/METRICS_TREE.mmd) - Mermaid KPI tree.

---

## Local Setup (Docker)

```bash
cd docker && docker compose up -d
bash ../scripts/run_pipeline.sh
bash ../scripts/run_tests.sh
```
