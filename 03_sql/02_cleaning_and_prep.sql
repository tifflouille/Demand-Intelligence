USE ecomm_demand;

SELECT
    order_purchase_timestamp,
    STR_TO_DATE(order_purchase_timestamp, '%d/%m/%y %H:%i') AS order_purchase_datetime
FROM orders
LIMIT 10;

SELECT
    order_purchase_timestamp,
    STR_TO_DATE(order_purchase_timestamp, '%d/%m/%y %H:%i') AS converted_date
FROM orders
WHERE STR_TO_DATE(order_purchase_timestamp, '%d/%m/%y %H:%i') IS NULL
LIMIT 20;

-- Convert the raw purchase timestamp from TEXT to DATETIME.
-- The source data uses the M/D/YY HH:MM format.
SELECT
    order_purchase_timestamp,
    STR_TO_DATE(order_purchase_timestamp, '%m/%d/%y %H:%i') AS order_purchase_datetime
FROM orders
LIMIT 20;

SELECT
    order_status,
    COUNT(*) AS number_of_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY order_status
ORDER BY number_of_orders DESC;

SELECT
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price
FROM order_items;

SELECT COUNT(*) AS non_positive_prices
FROM order_items
WHERE price <= 0;

SELECT
    COUNT(*) AS unmatched_item_rows,
    SUM(oi.price) AS unmatched_revenue,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_items),
        2
    ) AS percentage_of_item_rows,
    ROUND(
        SUM(oi.price) * 100.0 / (SELECT SUM(price) FROM order_items),
        2
    ) AS percentage_of_revenue
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    product_category_name,
    COUNT(*) AS number_of_products
FROM products
GROUP BY product_category_name
ORDER BY number_of_products DESC;
-- Result: 
-- Product category names are in Portuguese. 
-- They will be translated during the Python analysis phase
-- in order to keep the original category values.

SELECT
    COUNT(*) AS missing_or_blank_categories
FROM products
WHERE product_category_name IS NULL
   OR TRIM(product_category_name) = '';
-- Result: 
-- No missing or blank categories. 

-- Create cleaned orders table with standardized purchase date fields.
CREATE TABLE clean_orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    STR_TO_DATE(order_purchase_timestamp, '%m/%d/%y %H:%i')
        AS order_purchase_datetime,
    DATE(
        STR_TO_DATE(order_purchase_timestamp, '%m/%d/%y %H:%i')
    ) AS order_date,
    DATE_FORMAT(
        STR_TO_DATE(order_purchase_timestamp, '%m/%d/%y %H:%i'),
        '%Y-%m'
    ) AS order_month
FROM orders;

SELECT *
FROM clean_orders
LIMIT 10;

SELECT
    MIN(order_purchase_datetime) AS earliest_purchase,
    MAX(order_purchase_datetime) AS latest_purchase
FROM clean_orders;

-- Create cleaned order-items table by joining order-level information.
CREATE TABLE clean_order_items AS
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.price,
    co.order_status,
    co.order_purchase_datetime,
    co.order_date,
    co.order_month
FROM order_items oi
JOIN clean_orders co
    ON oi.order_id = co.order_id;

SELECT COUNT(*) AS total_rows
FROM clean_order_items;

-- Join product category information while preserving all order-item rows.
-- A LEFT JOIN keeps transactions whose product ID is missing from the products table.
CREATE TABLE clean_order_items_with_products AS
SELECT
    coi.order_id,
    coi.order_item_id,
    coi.product_id,
    coi.price,
    coi.order_status,
    coi.order_purchase_datetime,
    coi.order_date,
    coi.order_month,
    p.product_category_name
FROM clean_order_items coi
LEFT JOIN products p
    ON coi.product_id = p.product_id;

SELECT COUNT(*) AS total_rows
FROM clean_order_items_with_products;

SELECT
    COUNT(*) AS missing_categories
FROM clean_order_items_with_products
WHERE product_category_name IS NULL;

SELECT
    (SELECT SUM(price) FROM order_items) AS source_revenue,
    (SELECT SUM(price) FROM clean_order_items_with_products) AS cleaned_revenue;
