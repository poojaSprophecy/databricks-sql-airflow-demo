WITH customers AS (

  SELECT * 
  
  FROM {{ source('hive_metastore.pooja', 'customers') }}

),

orders_new AS (

  SELECT * 
  
  FROM {{ source('hive_metastore.pooja', 'orders_new') }}

),

by_customer_id AS (

  SELECT 
    orders_new.order_id AS order_id,
    orders_new.order_status AS order_status,
    orders_new.order_date AS order_date,
    orders_new.amount AS amount,
    customers.customer_id AS customer_id,
    customers.first_name AS first_name,
    customers.last_name AS last_name
  
  FROM customers
  INNER JOIN orders_new
     ON customers.customer_id = orders_new.customer_id

),

Reformat_1 AS (

  SELECT 
    concat(first_name, last_name) AS full_name,
    order_id AS order_id,
    amount AS amount,
    order_date AS order_date,
    customer_id AS customer_id,
    order_status AS order_status
  
  FROM by_customer_id AS in0

),

Aggregate_1 AS (

  SELECT 
    count(order_id) AS total_orders,
    sum(amount) AS total_amount,
    first(customer_id) AS customer_id,
    first(full_name) AS full_name
  
  FROM Reformat_1 AS in0
  
  GROUP BY customer_id

)

SELECT *

FROM Aggregate_1
