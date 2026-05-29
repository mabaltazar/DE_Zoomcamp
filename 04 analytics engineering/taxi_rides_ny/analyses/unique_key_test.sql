with green_data as (
    select * from {{ ref('stg_green_tripdata') }}
),

create_key as (
    select
        {{ dbt_utils.generate_surrogate_key(['vendor_id', 'rate_code_id', 'pickup_location_id', 'dropoff_location_id', 'pickup_datetime']) }} as trip_id,
        vendor_id,
        rate_code_id,
        pickup_location_id,
        dropoff_location_id,
        pickup_datetime,
        dropoff_datetime

    from green_data
),

check_key as (
    select
        trip_id,
        count(*) as count
    from create_key
    group by trip_id
)

select * from check_key
where count > 1