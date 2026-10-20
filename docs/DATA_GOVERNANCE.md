# Data Governance and Quality Framework

This policy outlines data management standards, retention policies, and privacy protocols.

---

## 1. PII and Data Masking

- User email addresses are cleaned and lowercased in `stg_users`.
- In production, email domains are segregated from user identifiers (`user_id`).
- No prompt contents, raw completions, or sensitive user inputs are stored in raw event telemetry.

---

## 2. Retention Schedules

- `raw_ai_events`: Retained for 90 days for operational debugging and session re-processing.
- `fct_ai_usage_daily`: Retained permanently for year-over-year growth analytics.
- `fct_user_sessions`: Retained for 365 days.
