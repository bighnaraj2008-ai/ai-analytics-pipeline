# Frequently Asked Questions (FAQ)

### 1. Why Pure SQL instead of Python / Pandas?
PostgreSQL execution engines process relational sets and window functions natively with indexed scans, eliminating memory serialization bottlenecks and multi-language stack maintenance.

### 2. How is sessionization computed without dbt?
Sessionization is calculated using SQL CTEs with `LAG(event_timestamp)` partitioned by `user_id`. When the difference exceeds 30 minutes, an increment flag triggers a windowed cumulative sum assigning an immutable `session_num`.

### 3. Can this pipeline run in production databases (e.g., RDS / Cloud SQL)?
Yes. All queries adhere to standard ANSI/PostgreSQL 14+ syntax, compatible with AWS Aurora, RDS, Google Cloud SQL, and Azure PostgreSQL.
