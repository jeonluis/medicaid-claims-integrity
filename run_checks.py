"""Demonstrate transparent claims-integrity checks (not fraud determinations)."""
import csv
import sqlite3
from datetime import date
from pathlib import Path

DB = Path(__file__).with_name('claims_demo.sqlite')
if not DB.exists():
    raise SystemExit('Run python3 generate_data.py first.')
conn = sqlite3.connect(DB)
conn.row_factory = sqlite3.Row
print('\n1) Potential exact duplicates (same member/provider/date/code/amount/status):')
for r in conn.execute('''SELECT member_id,provider_id,service_date,service_code,paid_amount,claim_status,COUNT(*) AS n
FROM claims GROUP BY member_id,provider_id,service_date,service_code,paid_amount,claim_status HAVING COUNT(*) > 1'''):
    print(dict(r))
print('\n2) Claims with inpatient stay overlap (dates inclusive; requires review):')
for r in conn.execute('''SELECT c.claim_id,c.member_id,c.service_date,h.admission_date,h.discharge_date
FROM claims c JOIN hospital_stays h ON c.member_id=h.member_id
WHERE c.service_date BETWEEN h.admission_date AND h.discharge_date'''):
    print(dict(r))
print('\n3) Invalid service dates:')
for r in conn.execute('SELECT claim_id,service_date FROM claims'):
    try:
        date.fromisoformat(r['service_date'])
    except ValueError:
        print(dict(r))



# Export consolidated audit worklist to CSV
sql_file = Path(__file__).with_name("audit_worklist.sql")
output_file = Path(__file__).with_name("audit_worklist.csv")

# Read the existing SQL query
sql_query = sql_file.read_text(encoding="utf-8")

# Execute the query against the SQLite database
cursor = conn.execute(sql_query)
results = cursor.fetchall()

# Retrieve column names from the SQL results
columns = [column[0] for column in cursor.description]

# Write the audit worklist to a CSV file
with output_file.open("w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(columns)

    for row in results:
        writer.writerow(row)

print(f"\nAudit worklist exported: {output_file.name}")
print(f"Total flagged records: {len(results)}")

conn.close()
