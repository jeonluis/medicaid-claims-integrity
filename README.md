# Medicaid Claims Data Quality & Payment Integrity Analytics

**Python | SQL | SQLite | Healthcare Claims Analytics**

An independent healthcare analytics portfolio project demonstrating how SQL and Python can identify potential billing anomalies in synthetic Medicaid adult day care claims data.

> **Data disclaimer:** All members, providers, claims, and payment amounts are fictional. This project does not analyze real Medicaid beneficiaries or facilities, and analytical flags do not establish fraud or improper payments.

## Business Problem

Healthcare payers and Medicaid programs process large volumes of claims. Data-quality issues and potentially inconsistent billing records can complicate payment review, compliance monitoring, and financial oversight.

This project demonstrates a rules-based approach to identifying claims that may warrant additional review, focusing on:

- Potential duplicate claims
- Services dated during recorded inpatient hospital stays
- Invalid service dates

The objective is to turn raw claims records into a structured audit worklist that can support further investigation and reporting.

## Technologies and Skills

- **Python:** Synthetic data generation, database queries, and automated CSV export
- **SQL / SQLite:** Relational joins, grouping, exception detection, and consolidated reporting
- **Data quality:** Rules-based validation and exception classification
- **Healthcare analytics:** Claims review, payment integrity concepts, and audit workflow design

The project uses Python 3.9+ and the Python standard library. No external packages are required.

## Dataset

The data generator creates a reproducible SQLite database containing:

- 100 fictional Medicaid members
- 5 fictional adult day care providers
- 300 baseline claims plus 3 deliberately injected anomalous claims
- Synthetic hospitalization records used for overlap checks

The resulting dataset contains **303 claims**. All data and payment values are invented.

See [data_dictionary.md](data_dictionary.md) for field definitions and caveats.

## Analytical Methodology

### 1. Potential duplicate claims

Groups claims by member, provider, service date, service code, paid amount, and claim status to identify repeated records.

### 2. Hospitalization overlaps

Joins claims to recorded inpatient hospital stays by member and flags service dates falling between admission and discharge dates, inclusive.

### 3. Invalid service dates

Checks for missing, incorrectly formatted, or invalid calendar dates.

### 4. Consolidated audit worklist

Combines the SQL exception rules into a single worklist, including claim details, exception flags, and review fields. Python exports the query results to a CSV file.

## Results

| Metric | Result |
|---|---:|
| Claims analyzed | 303 |
| Flagged claim records | 4 |
| Flag rate | 1.32% |
| Payment value associated with flagged records | $366.36 |

### Exceptions identified

| Exception category | Flagged records |
|---|---:|
| Potential duplicate | 2 |
| Hospitalization overlap | 1 |
| Invalid service date | 1 |
| **Total** | **4** |

The two potential-duplicate records belong to **one duplicate group**. The $366.36 figure is the sum of payment values associated with all flagged records, **not a confirmed overpayment or recoverable amount**.

See [audit_worklist.csv](audit_worklist.csv) for the example output.

## How to Run

Clone the repository:

```bash
git clone https://github.com/jeonluis/medicaid-claims-integrity.git
cd medicaid-claims-integrity
```

Generate the synthetic dataset:

```bash
python3 generate_data.py
```

Run the validation checks and export the audit worklist:

```bash
python3 run_checks.py
```

The second command prints the rule-based findings and writes the consolidated results to `audit_worklist.csv`.

## Repository Files

| File | Purpose |
|---|---|
| `generate_data.py` | Generate synthetic claims and related data |
| `run_checks.py` | Execute validation checks and export CSV |
| `duplicate_claims.sql` | Identify potential duplicate claims |
| `hospital_overlap.sql` | Identify inpatient stay overlaps |
| `invalid_dates.sql` | Identify invalid service dates |
| `audit_worklist.sql` | Consolidate exception flags |
| `audit_worklist.csv` | Example audit output |
| `data_dictionary.md` | Dataset definitions and caveats |

## Limitations

This is a demonstration of data-quality and payment-integrity concepts, not a production claims adjudication or fraud-detection system.

- Duplicate records may reflect legitimate adjustments, voids, or other billing activity.
- Hospitalization overlaps require clinical and operational context.
- Flagged payment amounts are not verified financial losses.
- The validation rules are illustrative and do not represent official New York Medicaid adjudication requirements.

## Future Enhancements

- Provider-level exception rates and reporting
- Synthetic eligibility and authorization validation
- Automated testing of analytical rules
- Additional reporting and visualizations
- Analysis of publicly available facility registry data, where appropriate

## Project Context

Developed as an independent portfolio project combining clinical healthcare experience, managed care knowledge, and technical interests in healthcare data analytics, economics, and payment integrity.
