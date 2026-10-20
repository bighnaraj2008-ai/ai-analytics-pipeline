# Changelog

All notable changes to the `ai-analytics-pipeline` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-20

### Added
- Pure SQL dimensional warehouse architecture (staging, intermediate, marts).
- Automated sessionization logic using 30-minute event partition windows.
- Daily usage facts (`fct_ai_usage_daily`) and user dimensions (`dim_users`).
- Modular schema assertion test suite (`sql/tests/assert_*.sql`).
- Docker Compose configuration for local PostgreSQL 15 environment.
- CI pipeline running automated schema and test assertions on GitHub Actions.
