# Data dictionary

All records are fictional and generated locally.

| Table | Field | Meaning |
|---|---|---|
| members | member_id | Fictional member identifier (primary key) |
| members | age | Simulated age |
| providers | provider_id | Fictional facility identifier (primary key) |
| providers | facility_name | Fictional provider name |
| claims | claim_id | Unique claim row identifier |
| claims | member_id | References members |
| claims | provider_id | References providers |
| claims | service_date | Date string, deliberately includes an invalid example |
| claims | service_code | Simplified educational service code, not a billing code |
| claims | paid_amount | Fictional paid amount in USD |
| claims | claim_status | Synthetic claim status |
| hospital_stays | stay_id | Unique stay identifier |
| hospital_stays | member_id | References members |
| hospital_stays | admission_date | Inclusive admission date |
| hospital_stays | discharge_date | Inclusive discharge date for demonstration only |

## Limitations

This prototype does not model adjustments/voids, institutional claims, actual authorization rules, detailed service units, member eligibility, claim lines, or official HEDIS measures. No anomaly establishes fraud or overpayment.
