with trip_unioned as (
    select * from {{ ref('int_unioned') }}
),

trip_deduped as (
    select
        trip_id,
        vendor_id,
        rate_code_id,
        pickup_location_id,
        dropoff_location_id,
        fare_amount
    from (
        select
            *,
            row_number() over (partition by trip_id order by pickup_datetime desc) as rn
        from trip_unioned
    ) t
    where rn = 1
)

select * from trip_deduped