import random
import pandas as pd

random.seed(42)

campaign_types = [
    "Seasonal",
    "Flash Sale",
    "Evergreen",
    "Clearance",
    "Product Launch",
]

campaign_names = [
    "Winter Deals",
    "Tech Savings",
    "Home Essentials",
    "Kitchen Specials",
    "Fitness Deals",
    "Holiday Offers",
    "Summer Sale",
    "Back to School",
    "Weekend Offers",
    "Best Sellers",
]

rows = []

for i in range(1, 51):
    rows.append({
        "campaign_id": f"CAMP{i:04d}",
        "campaign_name": f"{random.choice(campaign_names)} {i}",
        "campaign_type": random.choice(campaign_types),
        "channel": random.choice([
            "Search",
            "Social",
            "Email",
            "Affiliate",
            "Content"
        ]),
        "start_date": "2024-01-01",
        "status": random.choice([
            "Active",
            "Active",
            "Active",
            "Paused"
        ]),
    })

df = pd.DataFrame(rows)

df.to_csv(
    "data/campaign_master.csv",
    index=False
)

print(f"Created {len(df)} campaigns")
