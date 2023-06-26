-- TODO: This query will return a table with the top 10 revenue categories in
-- English, the number of orders and their total revenue. The first column will
-- be Category, that will contain the top 10 revenue categories; the second one
-- will be Num_order, with the total amount of orders of each category; and the
-- last one will be Revenue, with the total revenue of each category.
SELECT
    product_category_name_english AS Category,
    COUNT(DISTINCT olist_orders.order_id) AS Num_order,
    SUM(olist_order_payments.payment_value) AS Revenue
FROM
    olist_orders
    LEFT JOIN olist_order_payments USING(order_id)
    LEFT JOIN olist_order_items USING(order_id)
    LEFT JOIN olist_products USING(product_id)
    LEFT JOIN product_category_name_translation USING(product_category_name)
WHERE
    order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
GROUP BY
    Category
ORDER BY
    Revenue DESC
LIMIT 10;