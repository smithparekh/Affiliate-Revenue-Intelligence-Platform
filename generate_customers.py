import pandas as pd

rows = []

for i in range(1, 5001):
    rows.append(
        {
            "customer_id": f"CUST{i:06d}",
            "country": ["US", "CA", "UK", "AU", "IN"][i % 5],
        }
    )

df = pd.DataFrame(rows)

df.to_csv(
    "data/synthetic_customer_master.csv",
    index=False,
)

print(f"Created {len(df)} synthetic customers")
print(f"Unique customer_id: {df['customer_id'].nunique()}")
