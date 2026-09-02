{{ config(
    materialized='table'
) }}

with clicks as (

    select
        merchant_id,
        to_date(clicked_at) as activity_date,
        count(distinct click_id) as clicks
    from {{ ref('fct_synthetic_clicks') }}
    group by
        merchant_id,
        to_date(clicked_at)

),

conversions as (

    select
        merchant_id,
        to_date(converted_at) as activity_date,
        count(distinct conversion_id) as conversions,
        count(distinct click_id) as converted_clicks,
        sum(order_value) as order_value,
        sum(commission_earned) as commission_earned
    from {{ ref('fct_synthetic_conversions') }}
    group by
        merchant_id,
        to_date(converted_at)

)

select
    c.merchant_id,
    m.merchant_key,
    m.merchant_name,
    m.merchant_category,
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
    on c.merchant_id = v.merchant_id
   and c.activity_date = v.activity_date

left join {{ ref('dim_merchant') }} m
    on c.merchant_id = m.merchant_id
