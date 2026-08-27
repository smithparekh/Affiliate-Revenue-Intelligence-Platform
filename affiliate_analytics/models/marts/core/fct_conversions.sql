{{ config(
    materialized='table'
) }}

select
    conversion_id,
    click_id,
    user_id,
    order_id,
    timestamp as converted_at,
    product_asin as source_asin,
    product_title,
    product_category,
    order_value,
    commission_rate,
    commission_earned,
    quantity_purchased,
    conversion_time_hours,
    customer_type,
    payment_method,
    shipping_method,
    order_status,
    return_status,
    customer_lifetime_value,
    previous_orders_count

from {{ ref('amazon_affiliate_conversions') }}
