{{ config(
    materialized='incremental',
    unique_key='conversion_id',
    incremental_strategy='merge'
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

{% if is_incremental() %}

where converted_at > (
    select coalesce(max(converted_at), '1900-01-01'::timestamp)
    from {{ this }}
)

{% endif %}
