# Troubleshooting Guide

Common operational errors and remediation steps:

### 1. Connection Refused on `localhost:5432`
- Verify Docker is running: `docker compose ps` in `docker/`.
- Ensure port 5432 is not occupied by an existing local PostgreSQL service. Change port mapping in `docker/docker-compose.yml` to `"5433:5432"` if necessary.

### 2. Schema Assertion Failures (`ON_ERROR_STOP=1`)
- Run `psql -f scripts/smoke_test.sql` to verify raw seeds were loaded.
- Execute `bash scripts/reset_db.sh` to recreate schema from scratch.
