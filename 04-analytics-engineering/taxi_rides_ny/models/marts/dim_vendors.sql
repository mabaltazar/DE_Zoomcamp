with trips_unioned as (
    select * from {{ ref('int_unioned') }}
),

vendors as (
    select
        distinct vendor_id,
        {{ get_vendor_names('vendor_id') }} as vendor_name
    from trips_unioned
)

select * from vendors