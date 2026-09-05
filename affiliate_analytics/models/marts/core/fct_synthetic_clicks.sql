{{ config(
    materialized='incremental',
    unique_key='click_id',
    incremental_strategy='merge'
) }}

select
    click_id,
    affiliate_id,
    merchant_id,
    campaign_id,
    customer_id,
    session_id,
    product_id,
    product_title,
    clicked_at,
    traffic_source,
    traffic_medium,
    device_type,
    country

from {{ ref('synthetic_affiliate_clicks') }}

{% if is_incremental() %}

where clicked_at > (
    select coalesce(max(clicked_at), '1900-01-01'::timestamp)
    from {{ this }}
)

{% endif %}
