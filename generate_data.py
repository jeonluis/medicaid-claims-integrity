"""Create a reproducible synthetic claims database; no external dependencies."""
import random
import sqlite3
from datetime import date, timedelta
from pathlib import Path

DB = Path(__file__).with_name('claims_demo.sqlite')
random.seed(42)
conn = sqlite3.connect(DB)
conn.executescript('''
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS hospital_stays;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS providers;
CREATE TABLE members(member_id TEXT PRIMARY KEY, age INTEGER NOT NULL);
CREATE TABLE providers(provider_id TEXT PRIMARY KEY, facility_name TEXT NOT NULL);
CREATE TABLE hospital_stays(stay_id INTEGER PRIMARY KEY, member_id TEXT NOT NULL, admission_date TEXT NOT NULL, discharge_date TEXT NOT NULL, FOREIGN KEY(member_id) REFERENCES members(member_id));
CREATE TABLE claims(claim_id INTEGER PRIMARY KEY, member_id TEXT NOT NULL, provider_id TEXT NOT NULL, service_date TEXT NOT NULL, service_code TEXT NOT NULL, paid_amount REAL NOT NULL, claim_status TEXT NOT NULL, FOREIGN KEY(member_id) REFERENCES members(member_id), FOREIGN KEY(provider_id) REFERENCES providers(provider_id));
''')
conn.executemany('INSERT INTO members VALUES (?,?)', [(f'M{i:03}',random.randint(55,90)) for i in range(1,101)])
conn.executemany('INSERT INTO providers VALUES (?,?)', [(f'P{i:02}',f'Fictional Day Center {i}') for i in range(1,6)])
start=date(2026,1,1)
claims=[]
for i in range(1,301):
    d=start+timedelta(days=random.randint(0,89))
    claims.append((i,f'M{random.randint(1,100):03}',f'P{random.randint(1,5):02}',d.isoformat(),'DAYCARE',round(random.uniform(65,155),2),'PAID'))
# Deliberate exact service-level duplicate of the first claim (distinct claim ID).
claims.append((301,*claims[0][1:]))
# Deliberate inpatient overlap for M001 on 2026-02-11.
claims.append((302,'M001','P01','2026-02-11','DAYCARE',120.00,'PAID'))
# Deliberate invalid date (not a real calendar date).
claims.append((303,'M002','P02','2026-02-30','DAYCARE',100.00,'PAID'))
conn.executemany('INSERT INTO claims VALUES (?,?,?,?,?,?,?)',claims)
conn.execute('INSERT INTO hospital_stays VALUES (1,?,?,?)',('M001','2026-02-10','2026-02-13'))
conn.commit()
conn.close()
print(f'Created {DB} with {len(claims)} synthetic claims')
