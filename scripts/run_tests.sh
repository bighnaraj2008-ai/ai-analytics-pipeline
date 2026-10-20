#!/usr/bin/env bash
set -euo pipefail

PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-analytics}"
PGDATABASE="${PGDATABASE:-ai_analytics}"
export PGPASSWORD="${PGPASSWORD:-analytics}"

echo "=== Running Automated SQL Schema & Assertion Tests ==="

for test_file in sql/tests/assert_*.sql; do
    if [ -f "$test_file" ]; then
        echo "Running test: $test_file"
        psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -v ON_ERROR_STOP=1 -f "$test_file"
    fi
done

echo "=== All SQL assertion tests passed successfully! ==="
