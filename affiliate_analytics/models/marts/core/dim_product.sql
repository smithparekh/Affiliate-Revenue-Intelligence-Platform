{{ config(
    materialized='table'
) }}

with source_products as (

    select
        product_asin,
        product_title,
        brand,
        category,
        subcategory,
        price,
        original_price,
        discount_percentage,
        rating,
        review_count,
        prime_eligible,
        bestseller_rank,
        release_date,
        dimensions,
        weight,
        color_options,
        size_options,
        commission_rate,
        affiliate_fee_structure,
        product_description,
        key_features,
        target_audience,
        seasonal_trend,
        inventory_status
    from {{ ref('amazon_products_catalog_clean') }}

),

product_records  as (

    select
        *,
        row_number() over (
            order by product_asin, product_title
        ) as product_key
    from source_products

)

select
    product_key,
    product_asin as source_asin,
    product_title,
    brand,
    category,
    subcategory,
    price,
    original_price,
    discount_percentage,
    rating,
    review_count,
    prime_eligible,
    bestseller_rank,
    release_date,
    dimensions,
    weight,
    color_options,
    size_options,
    commission_rate,
    affiliate_fee_structure,
    product_description,
    key_features,
    target_audience,
    seasonal_trend,
    inventory_status
from product_records 
