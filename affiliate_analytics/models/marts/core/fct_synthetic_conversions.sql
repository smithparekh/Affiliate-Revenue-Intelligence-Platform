{{ config(
    materialized='table'
) }}

select
    conversion_id,
    click_id,
    affiliate_id,
    merchant_id,
    campaign_id,
    customer_id,
    product_id,
    session_id,
    converted_at,
    order_id,
    quantity,
    order_value,
    commission_rate,
    commission_earned,
    order_status,
    return_status

from {{ ref('synthetic_affiliate_conversions') }}
