with yellow_tripdata as (
    select * from {{ source('raw_data', 'yellow_tripdata') }}
    where vendorid is not null
),

renamed as (
    
    select 
        {{ dbt_utils.generate_surrogate_key(['vendorid', 'ratecodeid','pulocationid', 'dolocationid']) }} as trip_id,
        cast(vendorid as int) as vendor_id,
        cast(ratecodeid as int) as rate_code_id,
        cast(pulocationid as int) as pickup_location_id,
        cast(dolocationid as int) as dropoff_location_id,

        cast(tpep_pickup_datetime as timestamp) as pickup_datetime,
        cast(tpep_dropoff_datetime as timestamp) as dropoff_datetime,

        store_and_fwd_flag,
        cast(passenger_count as int) as passenger_count,
        cast(trip_distance as float) as trip_distance,
        cast(1 as int) as trip_type, -- yellow taxi has only one trip type

        cast(fare_amount as numeric) as fare_amount,
        cast(extra as numeric) as extra,
        cast(mta_tax as numeric) as mta_tax,
        cast(tip_amount as numeric) as tip_amount,
        cast(tolls_amount as numeric) as tolls_amount,
        cast(0 as numeric) as ehail_fee,  -- Yellow doesn't have ehail fee
        cast(improvement_surcharge as numeric) as improvement_surcharge,
        cast(total_amount as numeric) as total_amount,
        cast(payment_type as int) as payment_type,
        {{ get_payment_type_description('payment_type') }} as payment_type_description
    
    from yellow_tripdata
)

select * from renamed