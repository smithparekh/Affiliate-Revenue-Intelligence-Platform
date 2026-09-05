{{ config(
    materialized='table'
) }}

select
    f.conversion_id,
    f.click_id,

    c.customer_key,
    c.customer_id,

    f.user_id,
    f.order_id,
    f.converted_at,

    p.product_key,
    p.source_asin,
    p.product_title,
    p.brand,
    p.category,
    p.subcategory,

    f.order_value,
    f.commission_rate,
    f.commission_earned,
    f.quantity_purchased,
    f.conversion_time_hours,
    f.customer_type,
    f.payment_method,
    f.shipping_method,
    f.order_status,
    f.return_status,
    f.customer_lifetime_value,
    f.previous_orders_count

from {{ ref('fct_conversions') }} f

left join {{ ref('dim_customer') }} c
    on f.user_id = c.customer_id

left join {{ ref('dim_product') }} p
    on f.source_asin = p.source_asin
   and f.product_title = p.product_title
