-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
WITH orders AS (
    SELECT customer_id, order_id, order_delivered_customer_date, payment_value,
           STRFTIME('%Y', order_delivered_customer_date) AS year,
           STRFTIME('%m', order_delivered_customer_date) AS month
    FROM olist_orders
    INNER JOIN olist_order_payments USING (order_id)
    WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL
    GROUP BY order_id
)
SELECT month AS month_no,
       CASE
           WHEN month = '01' THEN 'Jan'
           WHEN month = '02' THEN 'Feb'
           WHEN month = '03' THEN 'Mar'
           WHEN month = '04' THEN 'Apr'
           WHEN month = '05' THEN 'May'
           WHEN month = '06' THEN 'Jun'
           WHEN month = '07' THEN 'Jul'
           WHEN month = '08' THEN 'Aug'
           WHEN month = '09' THEN 'Sep'
           WHEN month = '10' THEN 'Oct'
           WHEN month = '11' THEN 'Nov'
           WHEN month = '12' THEN 'Dec'
           ELSE 0
       END AS month,
       COALESCE(SUM(CASE WHEN year = '2016' THEN payment_value END), 0) AS Year2016,
       COALESCE(SUM(CASE WHEN year = '2017' THEN payment_value END), 0) AS Year2017,
       COALESCE(SUM(CASE WHEN year = '2018' THEN payment_value END), 0) AS Year2018
FROM orders
GROUP BY month
ORDER BY month_no ASC;
