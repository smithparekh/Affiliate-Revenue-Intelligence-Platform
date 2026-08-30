{{ config(
    materialized='table'
) }}

with all_users as (

    select user_id
    from {{ ref('amazon_affiliate_clicks') }}

    union

    select user_id
    from {{ ref('amazon_affiliate_conversions') }}

    union

    select user_id
    from {{ ref('user_behavior_analytics') }}

),

clicks as (

    select
        user_id,
        min(timestamp) as first_click_at,
        max(timestamp) as last_click_at
    from {{ ref('amazon_affiliate_clicks') }}
    group by user_id

),

conversions as (

    select
        user_id,
        max(customer_lifetime_value) as customer_lifetime_value,
        max(previous_orders_count) as previous_orders_count,
        min(timestamp) as first_conversion_at,
        max(timestamp) as last_conversion_at
    from {{ ref('amazon_affiliate_conversions') }}
    group by user_id

),

customer_records as (

    select
        u.user_id,

        coalesce(
            c.first_click_at,
            v.first_conversion_at
        ) as first_seen_at,

        greatest(
            coalesce(c.last_click_at, '1900-01-01'::timestamp),
            coalesce(v.last_conversion_at, '1900-01-01'::timestamp)
        ) as last_seen_at,

        v.customer_lifetime_value,
        v.previous_orders_count

    from all_users u

    left join clicks c
        on u.user_id = c.user_id

    left join conversions v
        on u.user_id = v.user_id

),

final as (

    select
        row_number() over (
            order by user_id
        ) as customer_key,

        user_id,
        first_seen_at,
        last_seen_at,
        customer_lifetime_value,
        previous_orders_count

    from customer_records

)

select *
from final
