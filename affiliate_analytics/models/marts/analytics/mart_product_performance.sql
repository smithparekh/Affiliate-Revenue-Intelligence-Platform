{{ config(
    materialized='table'
) }}

with click_activity as (

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

conversion_activity as (

    select
        c.product_id,
        c.product_title,
        to_date(c.clicked_at) as activity_date,

        count(distinct v.conversion_id) as conversions,

        coalesce(sum(v.order_value), 0) as order_value,

        coalesce(sum(v.commission_earned), 0) as commission_earned

    from {{ ref('fct_synthetic_clicks') }} c

    inner join {{ ref('fct_synthetic_conversions') }} v
        on c.click_id = v.click_id

    group by
        c.product_id,
        c.product_title,
        to_date(c.clicked_at)

),

combined as (

    select
        c.product_id,
        c.product_title,
        c.activity_date,
        c.clicks,

        coalesce(v.conversions, 0) as conversions,
        coalesce(v.order_value, 0) as order_value,
        coalesce(v.commission_earned, 0) as commission_earned

    from click_activity c

    left join conversion_activity v
        on c.product_id = v.product_id
       and c.product_title = v.product_title
       and c.activity_date = v.activity_date

)

select
    c.product_id,
    p.product_key,
    p.source_asin,
    c.product_title,
    p.brand,
    p.category,
    c.activity_date,

    c.clicks,
    c.conversions,
    c.order_value,
    c.commission_earned

from combined c

left join {{ ref('dim_product') }} p
    on c.product_id = p.source_asin
   and c.product_title = p.product_title
