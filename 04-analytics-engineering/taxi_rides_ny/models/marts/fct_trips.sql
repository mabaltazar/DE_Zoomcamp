/*
One row per trip — yellow and green combined (the union is already done in the intermediate model)
Add a primary key (trip_id) — it has to be unique
Find and fix duplicates — there are quite a few in this dataset. Some come from the source, some get introduced during the union. Find them, understand why they happen, and fix them
Enrich payment_type (there is a seed for this in the repo).
*/

with trips as (
    select * from {{ ref('int_deduped') }}
),

trips_fare_amount as (
    select
        trip_id,
        vendor_id,
        fare_amount
    from trips
)

select * from trips_fare_amount