import csv
import os
from datetime import datetime, timedelta
import random

output_dir = "../sample"
os.makedirs(output_dir, exist_ok=True)

headers = ["claim_id","member_id","first_name","last_name","dob","gender",
           "service_start","service_end","paid_amount","diagnosis_code","provider_id"]

payers = {
    "medicare": ["MCR", 500, 5000],
    "medicaid": ["MCD", 200, 3000],
    "commercial": ["COM", 100, 4000]
}

for payer, (prefix, base_amt, max_amt) in payers.items():
    rows = []
    for i in range(1, 6):
        claim_id = f"{prefix}-CLAIM-{1000+i}"
        member_id = f"{prefix}-MEM-{random.randint(100,200)}"
        start = datetime(2024, 1, 1) + timedelta(days=random.randint(0, 300))
        end = start + timedelta(days=random.randint(0, 10))
        rows.append([
            claim_id,
            member_id,
            f"Patient_{i}",
            f"Test",
            start.strftime("%Y-%m-%d"),
            random.choice(["M","F"]),
            start.strftime("%Y-%m-%d"),
            end.strftime("%Y-%m-%d"),
            round(random.uniform(base_amt, max_amt), 2),
            f"D{random.randint(100,999)}",
            f"PROV-{random.randint(1,20)}"
        ])
    with open(f"{output_dir}/{payer}_claims.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        writer.writerows(rows)
    print(f"Generated {payer}_claims.csv")
