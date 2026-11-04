
-- Medicaid Claims Integrity Project
-- Rule 001: Identify claims overlapping inpatient stays
-- Dataset: Synthetic Medicaid claims
-- Purpose: Flag records for further review

SELECT
    c.claim_id,
    c.member_id,
    c.provider_id,
    p.facility_name,
    c.service_date,
    h.admission_date,
    h.discharge_date,
    c.paid_amount,
    'HOSPITAL_OVERLAP' AS risk_flag
FROM claims AS c
JOIN hospital_stays AS h
    ON c.member_id = h.member_id
JOIN providers AS p
    ON c.provider_id = p.provider_id
WHERE c.service_date BETWEEN
    h.admission_date AND h.discharge_date
ORDER BY c.claim_id;
