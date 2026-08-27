{{ config(
    materialized='table'
) }}

select
    click_id,
    user_id,
    session_id,
    timestamp as clicked_at,
    product_asin as source_asin,
    product_title,
    product_category,
    product_price,
    affiliate_link,
    source_page,
    country,
    device_type,
    click_position,
    page_scroll_depth,
    time_on_page_before_click,
    referrer_url,
    utm_source,
    utm_medium,
    utm_campaign

from {{ ref('amazon_affiliate_clicks') }}
