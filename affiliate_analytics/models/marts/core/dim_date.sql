{{ config(
    materialized='table'
) }}

with date_spine as (

    select
        dateadd(
            day,
            row_number() over (order by seq4()) - 1,
            '2024-01-01'::date
        ) as date_day
    from table(generator(rowcount => 365 * 3))

)

select
    date_day,
    year(date_day) as year,
    quarter(date_day) as quarter,
    month(date_day) as month,
    monthname(date_day) as month_name,
    week(date_day) as week,
    day(date_day) as day_of_month,
    dayofweek(date_day) as day_of_week,
    dayname(date_day) as day_name,
    case
        when dayofweek(date_day) in (1, 7) then true
        else false
    end as is_weekend

from date_spine
