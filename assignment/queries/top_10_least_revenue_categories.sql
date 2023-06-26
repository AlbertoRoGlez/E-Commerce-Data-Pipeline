-- TODO: This query will return a table with the top 10 least revenue categories
-- in English, the number of orders and their total revenue. The first column
-- will be Category, that will contain the top 10 least revenue categories; the
-- second one will be Num_order, with the total amount of orders of each
-- category; and the last one will be Revenue, with the total revenue of each
-- catgory.
SELECT
  pcnt.product_category_name_english AS Category,
  COUNT(DISTINCT ooi.order_id) AS Num_order,
  SUM(pay.payment_value) AS Revenue
FROM
  olist_products op
  JOIN olist_order_items ooi ON op.product_id = ooi.product_id
  LEFT JOIN product_category_name_translation pcnt ON op.product_category_name = pcnt.product_category_name
  JOIN olist_orders oo ON ooi.order_id = oo.order_id
  JOIN (
    SELECT order_id, SUM(payment_value) AS payment_value
    FROM olist_order_payments
    GROUP BY order_id
  ) pay ON ooi.order_id = pay.order_id
WHERE
  oo.order_status = 'delivered'
GROUP BY
  pcnt.product_category_name_english
ORDER BY
  Revenue ASC
LIMIT 10;
