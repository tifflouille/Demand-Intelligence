USE ecomm_demand;

-- Monthly Demand Aggregation
-- One month per row
CREATE TABLE monthly_demand AS
SELECT
    order_month AS month,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(*) AS items_sold,
    SUM(price) AS revenue,
    COUNT(DISTINCT product_id) AS active_products
FROM clean_order_items_with_products
GROUP BY order_month
ORDER BY month;
-- Zero-demand periods are not generated in the aggregation tables.
-- They will be explicitly introduced where required for time-series
-- analysis and forecasting.

SELECT
    (SELECT SUM(price)
     FROM clean_order_items_with_products) AS transaction_revenue,
    (SELECT SUM(revenue)
     FROM monthly_demand) AS monthly_revenue; 

SELECT
    ROUND(
        (SELECT SUM(price)
         FROM clean_order_items_with_products),
        2
    ) AS transaction_revenue,

    ROUND(
        (SELECT SUM(revenue)
         FROM monthly_demand),
        2
    ) AS monthly_revenue;
-- Result:
-- Revenue reconciles after rounding to two decimal places.
-- The negligible raw difference is due to floating-point precision.  

SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM clean_order_items_with_products) AS transaction_orders,
    (SELECT SUM(orders)
     FROM monthly_demand) AS monthly_orders;
-- Result: 
-- Order number reconciles. 

-- Category-month demand aggregation.
-- Grain: one row per product category per month.
CREATE TABLE category_month_demand AS
SELECT
    order_month AS month,
    product_category_name AS category,
    COUNT(*) AS items_sold,
    SUM(price) AS revenue,
    COUNT(DISTINCT order_id) AS orders
FROM clean_order_items_with_products
GROUP BY
    order_month,
    product_category_name
ORDER BY
    month,
    category;

-- Product-month demand aggregation.
-- Grain: one row per product per month.
CREATE TABLE product_month_demand AS
SELECT
    order_month AS month,
    product_id,
    COUNT(*) AS items_sold,
    SUM(price) AS revenue
FROM clean_order_items_with_products
GROUP BY
    order_month,
    product_id
ORDER BY
    month,
    product_id;

-- Checking how many missing product categories there are. 
SELECT
    COUNT(*) AS missing_category_items,
    SUM(price) AS missing_category_revenue,
    COUNT(DISTINCT order_id) AS affected_orders
FROM clean_order_items_with_products
WHERE product_category_name IS NULL;

-- 
SELECT
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM clean_order_items_with_products),
        2
    ) AS pct_items,
    ROUND(
        SUM(price) * 100.0 /
        (SELECT SUM(price) FROM clean_order_items_with_products),
        2
    ) AS pct_revenue
FROM clean_order_items_with_products
WHERE product_category_name IS NULL;
-- Result: 
-- 1.42% of item rows and 1.34% of revenue have no product category.
-- NULL categories are retained rather than excluded to preserve total demand.
-- Category-level analysis may exclude NULL categories where appropriate.
