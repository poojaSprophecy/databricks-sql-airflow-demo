WITH orders_new AS (

  SELECT * 
  
  FROM {{ source('hive_metastore.pooja', 'orders_new') }}

),

Aggregate_1 AS (

  SELECT 
    count(DISTINCT (order_id)) AS total_orders,
    sum(amount) AS total_amount,
    order_date AS date,
    count(DISTINCT (customer_id)) AS unique_customers
  
  FROM orders_new AS in0
  
  GROUP BY order_date

)

SELECT *

FROM Aggregate_1
