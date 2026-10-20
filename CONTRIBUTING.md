# Contributing to AI Analytics Pipeline

Thank you for contributing! We welcome contributions to improve models, tests, and documentation.

## Analytics Engineering Standards

1. **Pure SQL**: All transformations must be SQL models executed directly on PostgreSQL.
2. **Layer Discipline**:
   - `sql/staging/`: Only 1:1 clean, cast, and rename models.
   - `sql/intermediate/`: Window functions and domain sessionization logic.
   - `sql/marts/`: Star schema dimension and fact tables.
3. **Data Quality Tests**: Every new model must be accompanied by an assertion test in `sql/tests/`.
4. **Style Consistency**: Keywords uppercase (`SELECT`, `FROM`, `WHERE`), identifiers snake_case.
