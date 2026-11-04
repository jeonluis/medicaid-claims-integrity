
-- Medicaid Claims Integrity
-- Consolidated Audit Worklist
-- Synthetic data: flags are not fraud determinations

WITH duplicate_groups AS (
    SELECT
        member_id,
        provider_id,
        service_date,
        service_code,
        paid_amount,
        claim_status
    FROM claims
    GROUP BY
        member_id, provider_id, service_date,
        service_code, paid_amount, claim_status
    HAVING COUNT(*) > 1
),
flagged_claims AS (
    -- Rule 001: Hospitalization overlaps
    SELECT DISTINCT
        c.claim_id,
        'HOSPITAL_OVERLAP' AS risk_flag
    FROM claims c
    JOIN hospital_stays h
        ON c.member_id = h.member_id
    WHERE c.service_date BETWEEN
        h.admission_date AND h.discharge_date

    UNION ALL

    -- Rule 002: Potential duplicate claims
    SELECT
        c.claim_id,
        'POTENTIAL_DUPLICATE' AS risk_flag
    FROM claims c
    JOIN duplicate_groups d
        ON c.member_id = d.member_id
       AND c.provider_id = d.provider_id
       AND c.service_date = d.service_date
       AND c.service_code = d.service_code
       AND c.paid_amount = d.paid_amount
       AND c.claim_status = d.claim_status

    UNION ALL

    -- Rule 003: Invalid service dates
    SELECT
        c.claim_id,
        'INVALID_SERVICE_DATE' AS risk_flag
    FROM claims c
    WHERE c.service_date IS NULL
       OR c.service_date NOT GLOB
          '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
       OR CAST(SUBSTR(c.service_date, 1, 4) AS INTEGER) < 1
       OR CAST(SUBSTR(c.service_date, 6, 2) AS INTEGER)
          NOT BETWEEN 1 AND 12
       OR CAST(SUBSTR(c.service_date, 9, 2) AS INTEGER) < 1
       OR CAST(SUBSTR(c.service_date, 9, 2) AS INTEGER) >
          CASE
            WHEN CAST(SUBSTR(c.service_date, 6, 2) AS INTEGER)
                 IN (1,3,5,7,8,10,12) THEN 31
            WHEN CAST(SUBSTR(c.service_date, 6, 2) AS INTEGER)
                 IN (4,6,9,11) THEN 30
            WHEN CAST(SUBSTR(c.service_date, 6, 2) AS INTEGER) = 2
            THEN CASE
                WHEN CAST(SUBSTR(c.service_date, 1, 4) AS INTEGER) % 400 = 0
                  OR (
                    CAST(SUBSTR(c.service_date, 1, 4) AS INTEGER) % 4 = 0
                    AND CAST(SUBSTR(c.service_date, 1, 4) AS INTEGER) % 100 != 0
                  )
                THEN 29 ELSE 28
            END
            ELSE 0
          END
)
SELECT
    f.claim_id,
    c.member_id,
    c.provider_id,
    p.facility_name,
    c.service_date,
    c.paid_amount,
    f.risk_flag,
    'PENDING_REVIEW' AS review_status
FROM flagged_claims f
JOIN claims c
    ON f.claim_id = c.claim_id
LEFT JOIN providers p
    ON c.provider_id = p.provider_id
ORDER BY f.risk_flag, f.claim_id;
