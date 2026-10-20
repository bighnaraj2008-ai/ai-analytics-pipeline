#!/usr/bin/env bash
set -euo pipefail

PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-analytics}"
PGDATABASE="${PGDATABASE:-ai_analytics}"
export PGPASSWORD="${PGPASSWORD:-analytics}"

echo "=== Validating Data Warehouse Health ==="
psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f scripts/smoke_test.sql
bash scripts/run_tests.sh
echo "=== Warehouse validation completed with zero errors! ==="
