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

This boots PostgreSQL 15 on port `5432` with credentials:
- Database: `ai_analytics`
- User: `analytics`
- Password: `analytics`
