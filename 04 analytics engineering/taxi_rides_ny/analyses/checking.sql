with green_data as (
    select * from {{ ref('stg_green_tripdata') }}
),

check_key as (
    select
        trip_id,
        vendor_id,
        rate_code_id,
        count(*) as count
    from green_data
    group by trip_id, vendor_id, rate_code_id
)
select * from check_key
where count > 1