# Metrics Dictionary

This document defines every metric exposed by the AI Analytics Pipeline,
including its business meaning, calculation method, source layer, and example
interpretation.

---

## Table of Contents

1. [Daily Active Users (DAU)](#1-daily-active-users-dau)
2. [Token Cost per User](#2-token-cost-per-user)
3. [Model Error Rate](#3-model-error-rate)
4. [P95 Latency](#4-p95-latency)
5. [Supporting Metrics](#5-supporting-metrics)

---

## 1. Daily Active Users (DAU)

| Property | Value |
|----------|-------|
| **Mart** | `fct_ai_usage_daily` |
| **Column** | `dau` |
| **Definition** | Count of distinct users who generated at least one event on a given calendar day (UTC). |
| **Calculation** | `COUNT(DISTINCT user_id)` grouped by `DATE_TRUNC('day', event_timestamp)` from `stg_ai_events`. |
| **Grain** | One row per day. |
| **Interpretation** | Measures daily product engagement. A rising DAU indicates growing adoption; a drop may signal an outage or degradation. |

---

## 2. Token Cost per User

| Property | Value |
|----------|-------|
| **Mart** | `fct_ai_usage_daily` |
| **Column** | `token_cost_per_user_usd` |
| **Definition** | Estimated LLM token cost attributed to each active user on a given day. |
| **Calculation** | `(total_tokens * 0.000002) / NULLIF(dau, 0)`<br>where `total_tokens = SUM(tokens_used)` across all model requests that day, and `0.000002` is the baseline rate ($2 per 1M tokens). |
| **Grain** | One row per day. |
| **Interpretation** | Helps track cost efficiency and flag days where spend per active user spikes. |

---

## 3. Model Error Rate

| Property | Value |
|----------|-------|
| **Mart** | `fct_ai_usage_daily` |
| **Column** | `model_error_rate_pct` |
| **Definition** | Percentage of model-request events that returned an error status on a given day. |
| **Calculation** | `COUNT(*) FILTER (WHERE status = 'error') * 100.0 / NULLIF(COUNT(*) FILTER (WHERE event_type = 'model_request'), 0)` |
| **Grain** | One row per day. |
| **Interpretation** | Reliability SLA metric. Spikes indicate upstream LLM provider outages or prompt validation failures. |

---

## 4. P95 Latency

| Property | Value |
|----------|-------|
| **Mart** | `fct_ai_usage_daily` |
| **Column** | `p95_latency_ms` |
| **Definition** | 95th percentile response latency (milliseconds) for model requests on a given day. |
| **Calculation** | `percentile_cont(0.95) WITHIN GROUP (ORDER BY latency_ms)` over model-request events where `latency_ms IS NOT NULL`, grouped by day. |
| **Grain** | One row per day. |
| **Interpretation** | Tail-latency SLA metric capturing the user experience of the slowest 5% of requests. |

---

## 5. Supporting Metrics

| Metric | Column | Layer | Definition |
|--------|--------|-------|------------|
| Session count per user | `total_sessions` | `dim_users` | Distinct `(user_id, session_num)` pairs per user. |
| Lifetime tokens per user | `lifetime_tokens` | `dim_users` | `SUM(total_tokens)` across all user sessions. |
| Session duration | `session_duration_min` | `int_session_metrics` | Elapsed minutes between first and last event in session. |
| Requests per session | `request_count` | `int_session_metrics` | Count of `model_request` events in session. |
| Feedback rating | `avg_feedback_rating` | `int_session_metrics` | Mean user feedback rating (1–5) per session. |

### Sessionization Rule

A new session begins when either:
- The user has no prior recorded event, or
- The elapsed interval from the user's previous event exceeds **30 minutes**.
