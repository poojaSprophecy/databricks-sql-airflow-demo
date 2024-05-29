WITH customers AS (

  SELECT * 
  
  FROM {{ source('hive_metastore.pooja', 'customers') }}

),

orders_new AS (

  SELECT * 
  
  FROM {{ source('hive_metastore.pooja', 'orders_new') }}

),

Join_1 AS (

  SELECT 
    in0.first_name AS first_name,
    in0.last_name AS last_name,
    in0.phone AS phone,
    in0.email AS email,
    in0.country_code AS country_code,
    in0.account_open_date AS account_open_date,
    in0.account_flags AS account_flags,
    in1.order_id AS order_id,
    in1.order_status AS order_status,
    in1.amount AS amount,
    in1.order_date AS order_date,
    in1.customer_id AS customer_id
  
  FROM customers AS in0
  INNER JOIN orders_new AS in1
     ON in0.customer_id = in1.customer_id

),

Reformat_1 AS (

  SELECT 
    concat(first_name, last_name) AS full_name,
    order_id AS order_id,
    amount AS amount,
    order_date AS order_date,
    customer_id AS customer_id,
    order_status AS order_status,
    account_open_date AS account_open_date
  
  FROM Join_1 AS in0

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
