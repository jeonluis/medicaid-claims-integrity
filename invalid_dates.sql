
-- Rule 003: Invalid Service Dates
-- Detect malformed or impossible calendar dates.
-- Dataset: Synthetic Medicaid claims.

WITH date_parts AS (
    SELECT
        claim_id,
        member_id,
        service_date,
        CAST(SUBSTR(service_date, 1, 4) AS INTEGER) AS yr,
        CAST(SUBSTR(service_date, 6, 2) AS INTEGER) AS mo,
        CAST(SUBSTR(service_date, 9, 2) AS INTEGER) AS dy
    FROM claims
)
SELECT
    claim_id,
    member_id,
    service_date,
    'INVALID_SERVICE_DATE' AS risk_flag
FROM date_parts
WHERE service_date IS NULL
   OR service_date NOT GLOB
      '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
   OR yr < 1
   OR mo NOT BETWEEN 1 AND 12
   OR dy < 1
   OR dy > CASE
       WHEN mo IN (1,3,5,7,8,10,12) THEN 31
       WHEN mo IN (4,6,9,11) THEN 30
       WHEN mo = 2 THEN
           CASE
               WHEN yr % 400 = 0
                 OR (yr % 4 = 0 AND yr % 100 != 0)
               THEN 29
               ELSE 28
           END
       ELSE 0
   END;
