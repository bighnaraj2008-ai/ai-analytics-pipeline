# Metrics Dictionary

This document defines core metrics exposed by the AI Analytics Pipeline,
including business meanings, calculations, source layers, and grain definitions.

---

## Architecture & Layers Overview

The data warehouse models events through 3 progressive layers:
- **Staging (`stg_*`)**: 1:1 clean representation of raw ingestion sources.
- **Intermediate (`int_*`)**: Sessionization windows, aggregations, and business logic.
- **Marts (`dim_*`, `fct_*`, `agg_*`)**: Dimensional models optimized for business intelligence.

---

## General Modeling Conventions

- All timestamps are standardized in **UTC**.
- Money values are computed in **USD** with standard precision.
- Division operations are protected using `NULLIF(denominator, 0)` to prevent runtime divide-by-zero errors.
