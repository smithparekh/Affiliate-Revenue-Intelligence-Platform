{{ config(
    materialized='table'
) }}

select
    row_number() over (
        order by merchant_id
    ) as merchant_key,

    merchant_id,
    merchant_name,
    merchant_category,
    country,
    commission_rate,
    status

from {{ ref('merchant_master') }}
