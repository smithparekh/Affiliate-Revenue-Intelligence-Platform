import random
import pandas as pd

random.seed(42)

merchant_names = [
    "TechWorld",
    "HomePlus",
    "KitchenKart",
    "FitLife",
    "AudioHub",
    "SmartLiving",
    "GadgetZone",
    "FashionPoint",
    "BeautyMart",
    "TravelGear",
]

categories = [
    "Electronics",
    "Home & Garden",
    "Kitchen",
    "Health & Fitness",
    "Fashion",
]

rows = []

for i in range(1, 101):
    category = random.choice(categories)

    rows.append({
        "merchant_id": f"MER{i:04d}",
        "merchant_name": f"{random.choice(merchant_names)} {i}",
        "merchant_category": category,
        "country": random.choice(["US", "CA", "UK", "AU"]),
        "commission_rate": round(random.uniform(0.02, 0.08), 3),
        "status": random.choice(["Active", "Active", "Active", "Paused"]),
    })

df = pd.DataFrame(rows)

df.to_csv(
    "data/merchant_master.csv",
    index=False
)

print(f"Created {len(df)} merchants")
