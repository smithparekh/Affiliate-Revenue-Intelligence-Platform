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
