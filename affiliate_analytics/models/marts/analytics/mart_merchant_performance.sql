{{ config(
    materialized='table'
) }}

with merchant_activity as (

    select
        c.merchant_id,
        c.click_id,
        to_date(c.clicked_at) as activity_date,
        v.conversion_id,
        v.order_value,
        v.commission_earned

    from {{ ref('fct_synthetic_clicks') }} c

    left join {{ ref('fct_synthetic_conversions') }} v
        on c.click_id = v.click_id

),

aggregated as (

    select
        merchant_id,
        activity_date,

        count(distinct click_id) as clicks,

        count(distinct conversion_id) as conversions,

        coalesce(sum(order_value), 0) as order_value,

        coalesce(sum(commission_earned), 0) as commission_earned

    from merchant_activity

    group by
        merchant_id,
        activity_date

)

select
    a.merchant_id,
    d.merchant_key,
    d.merchant_name,
    d.merchant_category,
    a.activity_date,

    a.clicks,
    a.conversions,
    a.order_value,
    a.commission_earned

from aggregated a

left join {{ ref('dim_merchant') }} d
    on a.merchant_id = d.merchant_id
