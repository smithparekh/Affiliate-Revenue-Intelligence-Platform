import random
from datetime import timedelta

import pandas as pd


RANDOM_SEED = 42
NUM_CONVERSIONS = 2_000

random.seed(RANDOM_SEED)

clicks = pd.read_csv("data/synthetic_affiliate_clicks.csv")
products = pd.read_csv(
    "affiliate_analytics/seeds/amazon_products_catalog_clean.csv"
)

clicks["clicked_at"] = pd.to_datetime(clicks["clicked_at"])

# Select clicks that can generate conversions.
selected_clicks = clicks.sample(
    n=NUM_CONVERSIONS,
    replace=True,
    random_state=RANDOM_SEED,
).reset_index(drop=True)

rows = []

for i, click in selected_clicks.iterrows():

    product = products[
        products["product_asin"] == click["product_id"]
    ].iloc[0]

    quantity = random.choices(
        [1, 2, 3],
        weights=[85, 12, 3],
        k=1,
    )[0]

    order_value = round(
        float(product["price"]) * quantity,
        2,
    )

    commission_rate = float(
        product["commission_rate"]
    )

    conversion_delay_hours = round(
        random.uniform(0.5, 72),
        2,
    )

    converted_at = (
        click["clicked_at"]
        + timedelta(hours=conversion_delay_hours)
    )

    rows.append(
        {
            "conversion_id": f"CONV_SYN_{i + 1:08d}",
            "click_id": click["click_id"],
            "affiliate_id": click["affiliate_id"],
            "merchant_id": click["merchant_id"],
            "campaign_id": click["campaign_id"],
            "customer_id": click["customer_id"],
            "product_id": click["product_id"],
            "session_id": click["session_id"],
            "converted_at": converted_at,
            "order_id": f"ORD_SYN_{i + 1:08d}",
            "quantity": quantity,
            "order_value": order_value,
            "commission_rate": commission_rate,
            "commission_earned": round(
                order_value * commission_rate,
                2,
            ),
            "order_status": random.choice(
                [
                    "Delivered",
                    "Delivered",
                    "Delivered",
                    "Cancelled",
                ]
            ),
            "return_status": random.choice(
                [
                    "Not Returned",
                    "Not Returned",
                    "Not Returned",
                    "Returned",
                ]
            ),
        }
    )


df = pd.DataFrame(rows)

df = df.sort_values("converted_at").reset_index(drop=True)

assert len(df) == NUM_CONVERSIONS
assert df["conversion_id"].is_unique
assert df["order_id"].is_unique
assert df["click_id"].notna().all()
assert df["affiliate_id"].notna().all()
assert df["merchant_id"].notna().all()
assert df["campaign_id"].notna().all()
assert df["customer_id"].notna().all()
assert df["product_id"].notna().all()

output_path = "data/synthetic_affiliate_conversions.csv"

df.to_csv(
    output_path,
    index=False,
)

print(f"Created: {output_path}")
print(f"Rows: {len(df):,}")
print(f"Unique conversions: {df['conversion_id'].nunique():,}")
print(f"Unique orders: {df['order_id'].nunique():,}")
print(f"Unique clicks converted: {df['click_id'].nunique():,}")
print(f"Unique affiliates: {df['affiliate_id'].nunique():,}")
print(f"Unique merchants: {df['merchant_id'].nunique():,}")
print(f"Unique campaigns: {df['campaign_id'].nunique():,}")
print(f"Unique customers: {df['customer_id'].nunique():,}")
