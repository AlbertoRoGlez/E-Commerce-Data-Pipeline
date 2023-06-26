-- TODO: This query will return a table with two columns; State, and
-- Delivery_Difference. The first one will have the letters that identify the
-- states, and the second one the average difference between the estimate
-- delivery date and the date when the items were actually delivered to the
-- customer.
WITH subquery AS (
    SELECT customer_state as State,
           JULIANDAY(STRFTIME('%Y-%m-%d', order_estimated_delivery_date)) AS Estimated_Delivery_Date,
           JULIANDAY(STRFTIME('%Y-%m-%d', order_delivered_customer_date)) AS Customer_Delivered_Date
    FROM olist_orders
    JOIN olist_customers
    ON olist_orders.customer_id = olist_customers.customer_id
    WHERE order_status != 'canceled'
)
SELECT State,
       CAST(AVG(Estimated_Delivery_Date - Customer_Delivered_Date) AS INTEGER) as Delivery_Difference
FROM subquery
GROUP BY State
ORDER BY Delivery_Difference;