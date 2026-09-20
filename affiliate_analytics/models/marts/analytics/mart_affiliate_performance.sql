{{ config(
    materialized='table'
) }}

with affiliate_activity as (

    select
        c.affiliate_id,
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
        affiliate_id,
        activity_date,

        count(distinct click_id) as clicks,

        count(distinct conversion_id) as conversions,

        count(distinct case
            when conversion_id is not null
            then click_id
        end) as converted_clicks,

        coalesce(sum(order_value), 0) as order_value,

        coalesce(sum(commission_earned), 0) as commission_earned

    from affiliate_activity

    group by
        affiliate_id,
        activity_date

)

select
    a.affiliate_id,
    d.affiliate_key,
    d.affiliate_name,
    a.activity_date,

    a.clicks,
    a.converted_clicks,
    a.conversions,
    a.order_value,
    a.commission_earned,

    round(
        a.converted_clicks
        / nullif(a.clicks, 0) * 100,
        2
    ) as conversion_rate_pct

from aggregated a

left join {{ ref('dim_affiliate') }} d
    on a.affiliate_id = d.affiliate_id
