# Synthetic Affiliate Event Schema

## Purpose

Extend the public affiliate dataset with realistic production-scale
records while preserving the business concepts required for analytics.

Synthetic records are portfolio data and are not real company data.

## Affiliate Click Event

### Grain

One row = one affiliate click event.

### Columns

| Column | Description |
|---|---|
| click_id | Unique click event identifier |
| affiliate_id | Affiliate responsible for the click |
| merchant_id | Merchant associated with the click |
| campaign_id | Marketing campaign associated with the click |
| customer_id | Customer who generated the click |
| session_id | Customer session |
| product_id | Product associated with the click |
| clicked_at | Click timestamp |
| traffic_source | Traffic source |
| traffic_medium | Traffic medium |
| device_type | Device used |
| country | Customer country |

## Conversion Event

### Grain

One row = one conversion/order event.

### Columns

| Column | Description |
|---|---|
| conversion_id | Unique conversion event identifier |
| click_id | Click that generated the conversion |
| affiliate_id | Affiliate responsible for the conversion |
| merchant_id | Merchant associated with the conversion |
| campaign_id | Campaign associated with the conversion |
| customer_id | Customer who converted |
| product_id | Product purchased |
| converted_at | Conversion timestamp |
| order_id | Order identifier |
| quantity | Quantity purchased |
| order_value | Order value |
| commission_rate | Affiliate commission rate |
| commission_earned | Affiliate commission earned |
| order_status | Order status |
| return_status | Return status |

## Design Principles

- Every event has an explicit business key.
- Foreign-key relationships must be testable.
- Event grain must remain stable.
- Raw events will remain immutable.
- Warehouse models will use surrogate keys where appropriate.
- Synthetic data will be clearly separated from public source data.
