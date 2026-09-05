{{ config(
    materialized='table'
) }}

with public_customers as (

    select
        user_id as customer_id,
        'PUBLIC' as customer_source
    from {{ ref('amazon_affiliate_clicks') }}

    union

    select
        user_id as customer_id,
        'PUBLIC' as customer_source
    from {{ ref('amazon_affiliate_conversions') }}

    union

    select
        user_id as customer_id,
        'PUBLIC' as customer_source
    from {{ ref('user_behavior_analytics') }}

),

synthetic_customers as (

    select
        customer_id,
        'SYNTHETIC' as customer_source
    from {{ ref('synthetic_customer_master') }}

),

all_customers as (

    select
        customer_id,
        customer_source
    from public_customers

    union

    select
        customer_id,
        customer_source
    from synthetic_customers

),

public_click_activity as (

    select
        user_id as customer_id,
        min(timestamp) as first_click_at,
        max(timestamp) as last_click_at
    from {{ ref('amazon_affiliate_clicks') }}
    group by user_id

),

public_conversion_activity as (

    select
        user_id as customer_id,
        max(customer_lifetime_value) as customer_lifetime_value,
        max(previous_orders_count) as previous_orders_count,
        min(timestamp) as first_conversion_at,
        max(timestamp) as last_conversion_at
    from {{ ref('amazon_affiliate_conversions') }}
    group by user_id

),

customer_records as (

    select
        a.customer_id,
        a.customer_source,

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

    from all_customers a

    left join public_click_activity c
        on a.customer_id = c.customer_id

    left join public_conversion_activity v
        on a.customer_id = v.customer_id

),

final as (

    select
        row_number() over (
            order by customer_source, customer_id
        ) as customer_key,

        customer_id,
        customer_source,
        first_seen_at,
        last_seen_at,
        customer_lifetime_value,
        previous_orders_count

    from customer_records

)

select *
from final
