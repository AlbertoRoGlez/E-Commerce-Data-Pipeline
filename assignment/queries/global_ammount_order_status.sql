-- TODO: This query will return a table with two columns; order_status, and
-- Ammount. The first one will have the different order status classes and the
-- second one the total ammount of each.
SELECT order_status as order_status,
       COUNT(order_status) as Ammount
FROM olist_orders
GROUP BY order_status
ORDER BY order_status;