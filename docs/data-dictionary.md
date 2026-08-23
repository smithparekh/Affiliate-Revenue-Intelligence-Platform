# Data Dictionary

## amazon_affiliate_clicks

### Grain

One row represents one affiliate click event.

### Primary Key

`click_id`

### Row Count

200

### Column Count

21

### Columns

| Column | Description |
|---|---|
| click_id | Unique identifier for the affiliate click |
| user_id | Identifier of the user |
| session_id | Identifier of the user session |
| timestamp | Timestamp when the click occurred |
| product_asin | Product identifier |
| product_title | Product name |
| product_category | Product category |
| product_price | Product price at the time of the click |
| affiliate_link | Affiliate tracking URL |
| source_page | Page where the affiliate link appeared |
| user_agent | Browser/device user-agent string |
| ip_address | IP address associated with the click |
| country | User country |
| device_type | Device category |
| click_position | Position of the clicked affiliate link |
| page_scroll_depth | Page scroll depth before the click |
| time_on_page_before_click | Time spent on page before clicking |
| referrer_url | Referring page |
| utm_source | Marketing source |
| utm_medium | Marketing medium |
| utm_campaign | Marketing campaign |


## amazon_affiliate_conversions

### Grain

One row represents one affiliate conversion/order event.

### Primary Key

`conversion_id`

### Foreign Key

`click_id` → `amazon_affiliate_clicks.click_id`

### Row Count

150

### Column Count

20

### Columns

| Column | Description |
|---|---|
| conversion_id | Unique identifier for the conversion |
| click_id | Affiliate click associated with the conversion |
| user_id | Identifier of the user |
| order_id | Identifier of the order |
| timestamp | Timestamp when the conversion occurred |
| product_asin | Product identifier |
| product_title | Product name |
| product_category | Product category |
| order_value | Value of the order |
| commission_rate | Affiliate commission rate |
| commission_earned | Commission earned from the order |
| quantity_purchased | Quantity purchased |
| conversion_time_hours | Time between click and conversion |
| customer_type | New or returning customer |
| payment_method | Payment method used |
| shipping_method | Shipping method used |
| order_status | Current order status |
| return_status | Return status |
| customer_lifetime_value | Customer lifetime value |
| previous_orders_count | Number of previous orders |


## amazon_products_catalog_clean

### Grain

One row represents one product.

### Primary Key

`product_asin`

### Row Count

64

### Column Count

24

### Columns

| Column | Description |
|---|---|
| product_asin | Unique product identifier |
| product_title | Product name |
| brand | Product brand |
| category | Product category |
| subcategory | Product subcategory |
| price | Current product price |
| original_price | Original product price before discount |
| discount_percentage | Discount percentage |
| rating | Product rating |
| review_count | Number of product reviews |
| prime_eligible | Whether the product is Prime eligible |
| bestseller_rank | Product bestseller ranking |
| release_date | Product release date |
| dimensions | Product dimensions |
| weight | Product weight |
| color_options | Available product colors |
| size_options | Available product sizes |
| commission_rate | Affiliate commission rate |
| affiliate_fee_structure | Affiliate fee structure |
| product_description | Product description |
| key_features | Main product features |
| target_audience | Intended customer audience |
| seasonal_trend | Seasonal demand pattern |
| inventory_status | Current inventory status |


## user_behavior_analytics

### Grain

One row represents one page-level behavior event within a user session.

### Primary Key

No single source primary key is present.

A practical event key will need to be created during the staging/modeling layer.

### Session Key

`session_id`

### User Key

`user_id`

### Row Count

308

### Column Count

21

### Columns

| Column | Description |
|---|---|
| session_id | Identifier of the user session |
| user_id | Identifier of the user |
| timestamp | Timestamp of the page interaction |
| page_url | URL/page visited |
| page_title | Page title |
| page_type | Type of page |
| time_on_page_seconds | Time spent on the page |
| scroll_depth_percentage | Percentage of page scrolled |
| bounce_rate | Bounce rate indicator/value |
| exit_rate | Exit rate indicator/value |
| page_views_in_session | Number of page views in the session |
| session_duration_minutes | Session duration |
| traffic_source | Source of traffic |
| device_type | Device category |
| browser | Browser |
| operating_system | Operating system |
| screen_resolution | Screen resolution |
| geographic_location | User geographic location |
| new_vs_returning | New or returning visitor |
| user_engagement_score | Engagement score |
| conversion_funnel_stage | Funnel stage at the time of the event |



## Source Relationships

### Clicks → Conversions

`amazon_affiliate_clicks.click_id`
→ `amazon_affiliate_conversions.click_id`

Relationship:

One click can have zero, one, or multiple conversion events.

Observed in source data:

- 200 click records
- 150 conversion records
- 130 distinct converted click IDs

### Clicks → Products

`amazon_affiliate_clicks.product_asin`
→ `amazon_products_catalog_clean.product_asin`

All 200 click records have a matching product.

### Conversions → Products

`amazon_affiliate_conversions.product_asin`
→ `amazon_products_catalog_clean.product_asin`

All 150 conversion records have a matching product.

### Clicks → User Behavior

`amazon_affiliate_clicks.session_id`
→ `user_behavior_analytics.session_id`

Observed in source data:

- 200 click records
- 110 clicks have matching sessions
- 90 clicks do not have matching behavior records

Missing behavior records will be preserved during modeling rather than dropping the corresponding click events.

### User Behavior Grain

`user_behavior_analytics` contains multiple records per session.

Therefore:

`session_id` is not a primary key.

One session can contain multiple page-behavior events.
