{% set payment_methods_query %}
select distinct payment_method from {{ref('bs_stripedata')}}
{% endset %}

{% set payment_methods = run_query(payment_methods_query) %}

{% if execute %}
    {% set result_list = payment_methods.columns[0].values() %}
{%  else %}
{% set result_list=[]%}
{% endif %}


--{% set payment_methods = ['credit_card','coupon','gift_card','bank_transfer'] %}



with payments as (
    select * 
    from {{ ref('bs_stripedata') }}
), final as (
    select
        order_id, 
        {%- for payment_method in payment_methods %}
        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount
        {%- if not loop.last -%},
        {%- endif -%}
        {% endfor %}
    from payments
    group by order_id
)
select *
from final