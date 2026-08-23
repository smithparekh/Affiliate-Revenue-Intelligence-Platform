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
