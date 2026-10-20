# Pipeline Architecture Guide

The **AI Analytics Pipeline** is engineered following pure SQL dimensional modeling principles (Kimball methodology adapted for modern cloud and containerized analytical warehouses).

---

## Design Principles

1. **Pure SQL Transformations**: All business logic, sessionization windows, and metric calculations run natively inside PostgreSQL. No external data wrangling runtime is required.
2. **Strict Layer Decoupling**: Data moves monotonically through 3 stages: Staging (`stg_`) → Intermediate (`int_`) → Marts (`dim_`, `fct_`, `agg_`).
3. **Idempotence**: All staging, intermediate, and marts definitions use `CREATE OR REPLACE VIEW` or idempotent DDL, enabling continuous deployment and safe re-execution.
