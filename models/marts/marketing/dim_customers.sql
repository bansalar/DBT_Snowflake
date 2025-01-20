
with customers as (
    select 
        *
        from {{ref('stg_jaffle_shop__customers')}}
),
orders as (
        select 
        *
        from {{ref('stg_jaffle_shop__orders')}}
),
customer_orders as (
    select customer_id,
    MIN(order_date) as first_order_date,
    MAX(order_date) as most_recent_order_date,
    count(order_id) as number_of_orders
    from orders group by 1
),
Final as (
    select
    customers.customer_id,
        customers.first_name,
        customers.last_name,
         customer_orders.first_order_date,
         customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders,0)number_of_orders
        from customer_orders join customers on customers.customer_id=customer_orders.customer_id
)
select * from Final