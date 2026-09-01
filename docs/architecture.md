# Warehouse Architecture

## dim_product

### Purpose

Provides a conformed product dimension for analytical models and fact tables.

### Grain

One row represents one distinct product record in the warehouse.

### Primary Key

`product_key`

### Source Identifier

`source_asin`

`source_asin` is retained for source-system traceability but is not used
as the warehouse primary key because the source catalog contains multiple
product titles associated with the same ASIN.

### Initial Columns

- product_key
- source_asin
- product_title
- brand
- category
- subcategory
- price
- original_price
- discount_percentage
- rating
- review_count
- prime_eligible
- bestseller_rank
- release_date
- dimensions
- weight
- color_options
- size_options
- commission_rate
- affiliate_fee_structure
- product_description
- key_features
- target_audience
- seasonal_trend
- inventory_status

### Initial History Strategy

The initial dimension will represent the current product state.

SCD Type 2 will be considered later when historical product changes are
introduced into the production-scale dataset.


## dim_customer

### Grain

One row represents one unique user/customer across all available source systems.

### Primary Key

`customer_key`

### Business Key

`user_id`

### Customer Universe

The customer dimension will be constructed from the union of users
appearing in:

- affiliate clicks
- affiliate conversions
- user behavior events

This prevents customers that appear in only one source system from being lost.

### Initial Attributes

- customer_key
- user_id
- first_seen_at
- last_seen_at
- customer_lifetime_value
- previous_orders_count

### Modeling Decision

Event-level and session-level attributes such as `customer_type`,
`new_vs_returning`, `device_type`, and `browser` will remain in the
appropriate fact/event models because their values may vary across
events and sources.



## Production-Scale Extension

The public Kaggle dataset is used as the initial source dataset.

Additional synthetic records will be generated to simulate a larger
affiliate platform while preserving the analytical concepts of the
public source.

Synthetic event records will explicitly include:

- affiliate_id
- merchant_id
- campaign_id
- customer_id
- product_id
- click_id
- session_id
- conversion_id
- event timestamps
- traffic and attribution attributes
- revenue and commission measures

Synthetic records will be clearly identified as generated portfolio data
and will not be represented as real company data.
