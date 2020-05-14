
{{ config(materialized='view') }}


select 
order_id
,stripe.customer_id
,sum(amount) as amount 
from {{ ref('bs_stripedata') }} stripe
left join {{ref('bs_customers')}} customers
on stripe.customer_id = customers.customer_id
group by 1,2 