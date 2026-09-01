{{ config(
    materialized='table'
) }}

select
    row_number() over (
        order by affiliate_id
    ) as affiliate_key,

    affiliate_id,
    affiliate_name,
    affiliate_type,
    commission_tier,
    country,
    status

from {{ ref('affiliate_master') }}
