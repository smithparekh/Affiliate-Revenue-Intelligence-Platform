{{ config(
    materialized='table'
) }}

select
    c.click_id,
    c.user_id,
    c.session_id,
    c.clicked_at,

    p.product_key,
    p.source_asin,
    p.product_title,
    p.brand,
    p.category,
    p.subcategory,

    c.product_price,
    c.country,
    c.device_type,
    c.click_position,
    c.page_scroll_depth,
    c.time_on_page_before_click,

    c.utm_source,
    c.utm_medium,
    c.utm_campaign

from {{ ref('fct_clicks') }} c

left join {{ ref('dim_product') }} p
    on c.source_asin = p.source_asin
   and c.product_title = p.product_title
