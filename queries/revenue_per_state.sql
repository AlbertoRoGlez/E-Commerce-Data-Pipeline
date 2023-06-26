-- TODO: This query will return a table with two columns; customer_state, and
-- Revenue. The first one will have the letters that identify the top 10 states
-- with most revenue and the second one the total revenue of each.
SELECT
  olist_customers.customer_state AS customer_state,
  ROUND(SUM(olist_order_payments.payment_value), 2) AS Revenue
FROM
  olist_customers 
LEFT JOIN olist_orders ON olist_customers.customer_id = olist_orders.customer_id 
                     AND olist_orders.order_status != "canceled" 
                     AND olist_orders.order_delivered_customer_date IS NOT NULL
LEFT JOIN olist_order_payments USING (order_id)
GROUP BY
  olist_customers.customer_state
ORDER BY
  Revenue DESC
LIMIT 10;