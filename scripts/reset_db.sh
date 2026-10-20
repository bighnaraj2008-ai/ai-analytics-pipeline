#!/usr/bin/env bash
set -euo pipefail

PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-analytics}"
PGDATABASE="${PGDATABASE:-ai_analytics}"
export PGPASSWORD="${PGPASSWORD:-analytics}"

echo "Resetting database schema..."
psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

echo "Running full pipeline from scratch..."
bash scripts/run_pipeline.sh
bash scripts/run_tests.sh

echo "Database reset complete."
