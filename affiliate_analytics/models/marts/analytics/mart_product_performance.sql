{{ config(
    materialized='table'
) }}

with clicks as (

    select
        product_id,
        product_title,
        to_date(clicked_at) as activity_date,
        count(distinct click_id) as clicks
    from {{ ref('fct_synthetic_clicks') }}
    group by
        product_id,
        product_title,
        to_date(clicked_at)

),

conversion_events as (

    select
        v.conversion_id,
        v.click_id,
        v.product_id,
        v.converted_at,
        v.order_value,
        v.commission_earned,
        c.product_title
    from {{ ref('fct_synthetic_conversions') }} v
    left join {{ ref('fct_synthetic_clicks') }} c
        on v.click_id = c.click_id

),

conversions as (

    select
        product_id,
        product_title,
        to_date(converted_at) as activity_date,
        count(distinct conversion_id) as conversions,
        count(distinct click_id) as converted_clicks,
        sum(order_value) as order_value,
        sum(commission_earned) as commission_earned
    from conversion_events
    group by
        product_id,
        product_title,
        to_date(converted_at)

)

select
    c.product_id,
    p.product_key,
    p.source_asin,
    p.product_title,
    p.brand,
    p.category,
    c.activity_date,

    c.clicks,

    coalesce(v.converted_clicks, 0) as converted_clicks,
    coalesce(v.conversions, 0) as conversions,
    coalesce(v.order_value, 0) as order_value,
    coalesce(v.commission_earned, 0) as commission_earned,

    round(
        coalesce(v.converted_clicks, 0)
        / nullif(c.clicks, 0) * 100,
        2
    ) as conversion_rate_pct

from clicks c

left join conversions v
    on c.product_id = v.product_id
   and c.product_title = v.product_title
   and c.activity_date = v.activity_date

left join {{ ref('dim_product') }} p
    on c.product_id = p.source_asin
   and c.product_title = p.product_title
