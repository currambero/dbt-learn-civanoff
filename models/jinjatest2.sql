{% set result_list = dbt_utils.get_column_values(table =ref('bs_stripedata'), column='paymentMethod') %}

--{% set payment_methods = ['credit_card','coupon','gift_card','bank_transfer'] %}



with payments as (
    select * 
    from {{ ref('bs_stripedata') }}
), final as (
    select
        order_id, 
        {%- for payment_method in result_list %}
        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount
        {%- if not loop.last -%},
        {%- endif -%}
        {% endfor %}
    from payments
    group by order_id
)
select *
from final