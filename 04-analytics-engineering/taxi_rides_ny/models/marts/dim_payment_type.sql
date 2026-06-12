with payment_type_list as (
    select * from {{ ref('payment_type_lookup')}}
),

renamed as (
    select
        payment_type,
        description as payment_type_description
    from payment_type_list
    where payment_type not in (0)
)

select * from renamed