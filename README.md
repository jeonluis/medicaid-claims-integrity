# Medicaid Claims Data Quality & Payment Integrity Analytics

Portfolio learning project using **synthetic** Medicaid adult day care claims. No real member records or allegations about real facilities.

## Quick start

```bash
python3 generate_data.py
python3 run_checks.py
```

Python 3.9+ required; no external packages.

## What is included

- `generate_data.py`: creates a reproducible SQLite database with 100 fictional members, 5 fictional providers, and 300 baseline claims plus deliberately injected anomalies.
- `run_checks.py`: reports duplicate service records, inpatient-stay overlaps, and invalid service dates.
- `data_dictionary.md`: definitions and caveats.

## Important caveats

This is a demonstration of **risk flags**, not fraud findings. Multiple claims on a day may be legitimate (adjustments, voids, different services); inpatient overlap can require further review. The dataset and payment values are invented. Rules are illustrative, not a representation of New York Medicaid adjudication policy.

## Planned additions

Public NYC SADC registry analysis, provider entity resolution, enrollment/authorization checks, audit worklist, HEDIS-inspired eligibility validation, and automated tests.
