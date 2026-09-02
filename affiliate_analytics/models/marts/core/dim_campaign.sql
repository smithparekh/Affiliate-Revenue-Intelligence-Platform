{{ config(
    materialized='table'
) }}

select
    row_number() over (
        order by campaign_id
    ) as campaign_key,

    campaign_id,
    campaign_name,
    campaign_type,
    channel,
    start_date,
    status

from {{ ref('campaign_master') }}
