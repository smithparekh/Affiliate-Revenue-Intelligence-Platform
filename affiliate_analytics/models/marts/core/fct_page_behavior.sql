{{ config(
    materialized='table'
) }}

select
    session_id,
    user_id,
    timestamp as event_at,
    page_url,
    page_title,
    page_type,
    time_on_page_seconds,
    scroll_depth_percentage,
    bounce_rate,
    exit_rate,
    page_views_in_session,
    session_duration_minutes,
    traffic_source,
    device_type,
    browser,
    operating_system,
    screen_resolution,
    geographic_location,
    new_vs_returning,
    user_engagement_score,
    conversion_funnel_stage

from {{ ref('user_behavior_analytics') }}
