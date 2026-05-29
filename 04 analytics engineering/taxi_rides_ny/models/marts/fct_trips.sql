/*
One row per trip — yellow and green combined (the union is already done in the intermediate model)
Add a primary key (trip_id) — it has to be unique
Find and fix duplicates — there are quite a few in this dataset. Some come from the source, some get introduced during the union. Find them, understand why they happen, and fix them
Enrich payment_type (there is a seed for this in the repo).
*/

with trip_unioned as (
    select * from {{ ref('int_unioned') }}
),

trip_deduped as (
    select
        trip_id,
        vendor_id,
        rate_code_id,
        pickup_location_id,
        dropoff_location_id
    from (
        select
            *,
            row_number() over (partition by trip_id order by pickup_datetime desc) as rn
        from trip_unioned
    ) t
    where rn = 1
)

select * from trip_deduped