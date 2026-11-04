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

## Project Results

Analyzed 303 synthetic Medicaid adult day care claims across five fictional providers using SQL, Python, and SQLite.

**Data-quality findings:**
- Identified one claim overlapping a recorded inpatient hospitalization.
- Detected two potentially duplicate claim records.
- Identified one claim containing an invalid service date.
- Generated a consolidated audit worklist with standardized exception flags and review statuses.
- Exported the findings to CSV for downstream analysis and reporting.

**Key metrics:**
- Total claims analyzed: 303
- Claims flagged: 4
- Flag rate: 1.32%
- Payment value associated with flagged claims: $366.36

All findings are based on synthetic data. Flagged payments do not represent confirmed overpayments, fraud, or recoverable funds.

## Future Enhancements

- Provider-level data-quality scorecards and normalized exception rates.
- Public NYC social adult day care facility registry analysis.
- Enrollment and authorization validation using synthetic eligibility data.
- HEDIS-inspired data completeness and eligibility checks.
- Automated testing and reproducible reporting.
