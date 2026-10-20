# Metrics Dictionary

This document defines core metrics exposed by the AI Analytics Pipeline,
including business meanings, calculations, source layers, and grain definitions.

---

## Table of Contents

1. [Daily Active Users (DAU)](#1-daily-active-users-dau)
2. [User Retention & Cohort Metrics](#2-user-retention--cohort-metrics)

---

## 1. Daily Active Users (DAU)

| Property | Value |
|----------|-------|
| **Mart** | `fct_ai_usage_daily` |
| **Column** | `dau` |
| **Definition** | Count of distinct users who generated at least one event on a given calendar day (UTC). |
| **Calculation** | `COUNT(DISTINCT user_id)` grouped by `DATE_TRUNC('day', event_timestamp)` from `stg_ai_events`. |
| **Grain** | One row per day. |
| **Interpretation** | Core product engagement KPI. Rising DAU indicates healthy organic growth or feature adoption. |

---

## 2. User Retention & Cohort Metrics

| Property | Value |
|----------|-------|
| **Mart** | `fct_user_retention_cohorts` |
| **Columns** | `cohort_week`, `week_number`, `active_users`, `retention_rate_pct` |
| **Definition** | Percentage of users from an onboarding cohort who remain active in subsequent weeks. |
| **Calculation** | `active_users * 100.0 / NULLIF(cohort_size, 0)` |
| **Grain** | One row per cohort per elapsed weekly period. |
