-- TODO: This query will return a table with the differences between the real
-- and estimated delivery times by month and year. It will have different
-- columns: month_no, with the month numbers going from 01 to 12; month, with
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with
-- the average delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if
-- it doesn't exist); Year2018_real_time, with the average delivery time per
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_estimated_time, with the average estimated delivery time per month
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
SELECT
  STRFTIME('%m', DATE(order_purchase_timestamp)) AS month_no,
  SUBSTR('JanFebMarAprMayJunJulAugSepOctNovDec', 1 + 3 * STRFTIME('%m', DATE(order_purchase_timestamp)), -3) AS month,
  AVG(
    ABS(JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp))
  ) FILTER (WHERE STRFTIME('%Y', DATE(order_purchase_timestamp)) = '2016') AS Year2016_real_time,
  AVG(
    ABS(JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp))
  ) FILTER (WHERE STRFTIME('%Y', DATE(order_purchase_timestamp)) = '2017') AS Year2017_real_time,
  AVG(
    ABS(JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp))
  ) FILTER (WHERE STRFTIME('%Y', DATE(order_purchase_timestamp)) = '2018') AS Year2018_real_time,
  AVG(
    ABS(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp))
  ) FILTER (WHERE STRFTIME('%Y', DATE(order_purchase_timestamp)) = '2016') AS Year2016_estimated_time,
  AVG(
    ABS(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp))
  ) FILTER (WHERE STRFTIME('%Y', DATE(order_purchase_timestamp)) = '2017') AS Year2017_estimated_time,
  AVG(
    ABS(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp))
  ) FILTER (WHERE STRFTIME('%Y', DATE(order_purchase_timestamp)) = '2018') AS Year2018_estimated_time
FROM (
  SELECT * FROM olist_orders
  WHERE
    order_status = 'delivered' AND
    order_estimated_delivery_date IS NOT NULL AND
    order_delivered_customer_date IS NOT NULL AND
    order_purchase_timestamp IS NOT NULL AND
    STRFTIME('%Y', DATE(order_purchase_timestamp)) IN ('2016', '2017', '2018')
)
GROUP BY 1, 2;
