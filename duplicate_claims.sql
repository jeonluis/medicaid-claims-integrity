
-- Rule 002: Potential Duplicate Claims
-- Identify repeated combinations of claim attributes.
-- Synthetic dataset only.

SELECT
    member_id,
    provider_id,
    service_date,
    service_code,
    paid_amount,
    claim_status,
    COUNT(*) AS duplicate_count
FROM claims
GROUP BY
    member_id,
    provider_id,
    service_date,
    service_code,
    paid_amount,
    claim_status
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
