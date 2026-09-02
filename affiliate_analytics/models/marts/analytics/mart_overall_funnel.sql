{{ config(
    materialized='table'
) }}

with click_metrics as (

    select
        count(distinct click_id) as total_clicks
    from {{ ref('fct_synthetic_clicks') }}

),

conversion_metrics as (

    select
        count(distinct click_id) as converted_clicks,
        count(distinct conversion_id) as total_conversions
    from {{ ref('fct_synthetic_conversions') }}
    where click_id is not null

)

select
    c.total_clicks,
    v.converted_clicks,
    v.total_conversions,

    round(
        v.converted_clicks
        / nullif(c.total_clicks, 0) * 100,
        2
    ) as click_to_conversion_rate_pct

from click_metrics c
cross join conversion_metrics v
