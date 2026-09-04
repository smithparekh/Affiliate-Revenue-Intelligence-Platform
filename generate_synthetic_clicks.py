import random
from datetime import datetime, timedelta

import pandas as pd


# --------------------------------------------------
# Configuration
# --------------------------------------------------

RANDOM_SEED = 42
NUM_CLICKS = 10_000

random.seed(RANDOM_SEED)


# --------------------------------------------------
# Source / master data
# --------------------------------------------------

BASE_PATH = "data"

affiliates = pd.read_csv(f"{BASE_PATH}/affiliate_master.csv")
merchants = pd.read_csv(f"{BASE_PATH}/merchant_master.csv")
campaigns = pd.read_csv(f"{BASE_PATH}/campaign_master.csv")
products = pd.read_csv(
    "affiliate_analytics/seeds/amazon_products_catalog_clean.csv"
)


# --------------------------------------------------
# Synthetic reference data
# --------------------------------------------------

customer_ids = [
    f"CUST{i:06d}"
    for i in range(1, 5001)
]

countries = ["US", "CA", "UK", "AU", "IN"]

devices = [
    "Desktop",
    "Mobile",
    "Tablet",
]

traffic_sources = [
    "google",
    "facebook",
    "instagram",
    "youtube",
    "reddit",
    "tiktok",
    "email",
    "direct",
]

traffic_mediums = {
    "google": "organic",
    "facebook": "social",
    "instagram": "social",
    "youtube": "video",
    "reddit": "social",
    "tiktok": "social",
    "email": "email",
    "direct": "direct",
}


# --------------------------------------------------
# Helper functions
# --------------------------------------------------

def random_timestamp(
    start: datetime,
    end: datetime,
) -> datetime:
    total_seconds = int((end - start).total_seconds())
    random_seconds = random.randint(0, total_seconds)
    return start + timedelta(seconds=random_seconds)


def random_campaign():
    return campaigns.sample(
        n=1,
        random_state=random.randint(1, 1_000_000),
    ).iloc[0]


def random_affiliate():
    return affiliates.sample(
        n=1,
        random_state=random.randint(1, 1_000_000),
    ).iloc[0]


def random_merchant():
    return merchants.sample(
        n=1,
        random_state=random.randint(1, 1_000_000),
    ).iloc[0]


def random_product():
    return products.sample(
        n=1,
        random_state=random.randint(1, 1_000_000),
    ).iloc[0]


# --------------------------------------------------
# Generate click events
# --------------------------------------------------

start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31, 23, 59, 59)

rows = []

for i in range(1, NUM_CLICKS + 1):

    affiliate = random_affiliate()
    merchant = random_merchant()
    campaign = random_campaign()
    product = random_product()

    customer_id = random.choice(customer_ids)

    session_number = random.randint(1, 3)

    session_id = (
        f"SES{customer_id.replace('CUST', '')}"
        f"{session_number:02d}"
    )

    clicked_at = random_timestamp(
        start_date,
        end_date,
    )

    traffic_source = random.choice(traffic_sources)

    rows.append(
        {
            "click_id": f"CLK_SYN_{i:08d}",
            "affiliate_id": affiliate["affiliate_id"],
            "merchant_id": merchant["merchant_id"],
            "campaign_id": campaign["campaign_id"],
            "customer_id": customer_id,
            "session_id": session_id,
            "product_id": product["product_asin"],
	    "product_title": product["product_title"],
	    "clicked_at": clicked_at,
            "traffic_source": traffic_source,
            "traffic_medium": traffic_mediums[traffic_source],
            "device_type": random.choice(devices),
            "country": random.choice(countries),
        }
    )


# --------------------------------------------------
# Create DataFrame
# --------------------------------------------------

df = pd.DataFrame(rows)

df["clicked_at"] = pd.to_datetime(df["clicked_at"])

df = df.sort_values("clicked_at").reset_index(drop=True)


# --------------------------------------------------
# Validation
# --------------------------------------------------

assert len(df) == NUM_CLICKS
assert df["click_id"].is_unique
assert df["affiliate_id"].notna().all()
assert df["merchant_id"].notna().all()
assert df["campaign_id"].notna().all()
assert df["customer_id"].notna().all()
assert df["product_id"].notna().all()


# --------------------------------------------------
# Save
# --------------------------------------------------

output_path = f"{BASE_PATH}/synthetic_affiliate_clicks.csv"

df.to_csv(
    output_path,
    index=False,
)

print(f"Created: {output_path}")
print(f"Rows: {len(df):,}")
print(f"Columns: {len(df.columns)}")
print()
print("Unique clicks:", df["click_id"].nunique())
print("Unique affiliates:", df["affiliate_id"].nunique())
print("Unique merchants:", df["merchant_id"].nunique())
print("Unique campaigns:", df["campaign_id"].nunique())
print("Unique customers:", df["customer_id"].nunique())
print("Unique products:", df["product_id"].nunique())
print()
print("Date range:")
print(df["clicked_at"].min())
print(df["clicked_at"].max())
