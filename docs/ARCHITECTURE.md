# Pipeline Architecture Guide

The **AI Analytics Pipeline** is engineered following pure SQL dimensional modeling principles (Kimball methodology adapted for modern cloud and containerized analytical warehouses).

---

## Data Flow Architecture

```
                 RAW INGESTION LAYER
           ┌─────────────────────────────┐
           │   raw_users, raw_ai_events  │
           └──────────────┬──────────────┘
                          │
                          ▼
                    STAGING LAYER
           ┌─────────────────────────────┐
           │   stg_users, stg_ai_events  │
           │   stg_model_requests        │
           │   stg_feedback              │
           └──────────────┬──────────────┘
                          │
                          ▼
                 INTERMEDIATE LAYER
           ┌─────────────────────────────┐
           │   int_session_metrics       │
           │   int_token_aggregates      │
           │   int_user_activity         │
           │   int_user_retention        │
           └──────────────┬──────────────┘
                          │
                          ▼
                     MARTS LAYER
 ┌───────────────────────┬──────────────────────────┐
 │      DIMENSIONS       │          FACTS           │
 │  dim_users            │  fct_ai_usage_daily      │
 │  dim_models           │  fct_user_sessions       │
 │                       │  fct_user_retention      │
 │                       │  agg_monthly_costs       │
 │                       │  agg_model_performance  │
 └───────────────────────┴──────────────────────────┘
```

---

## Layer Definitions

### 1. Staging (`sql/staging/`)
- Renames, casts, and trims raw source attributes.
- Filters out null timestamps or corrupted event payloads.
- 1:1 row parity with valid source rows.

### 2. Intermediate (`sql/intermediate/`)
- Applies stateful window functions: `LAG()` over timestamp partitions to detect inactivity gaps (> 30 mins).
- Computes session numbers and session duration.
- Aggregates token costs and engagement signals per user/date/session.

### 3. Marts (`sql/marts/`)
- **Dimensions (`dim_*`)**: Slowly changing profile details and lifetime aggregations.
- **Facts (`fct_*`)**: Granular activity logs and daily summarized telemetry.
- **Aggregates (`agg_*`)**: High-level executive views for financial and SLA reporting.
