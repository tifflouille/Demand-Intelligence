USE ecomm_demand;

SELECT COUNT(*) AS total_rows FROM orders;
-- Result: 99,441
SELECT COUNT(*) AS total_rows FROM order_items;
-- Result: 112,650
SELECT COUNT(*) AS total_rows FROM products;
-- Result: 32,340

SELECT
    order_id,
    COUNT(*) AS row_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- Result:
-- No duplicate order_id values found.

SELECT
    product_id,
    COUNT(*) AS row_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
-- Result:
-- No duplicate product_id values found.

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS row_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;
-- Result:
-- No duplicate (order_id, order_item_id) combinations found.

SELECT
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(customer_id) AS missing_customer_id,
    COUNT(*) - COUNT(order_status) AS missing_order_status,
    COUNT(*) - COUNT(order_purchase_timestamp) AS missing_purchase_timestamp
FROM orders;
-- Result: 
-- No NULL values were found in the selected key and analysis columns: order_id, customer_id, order_status, order_purchase_timestamp.

SELECT
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT(*) - COUNT(product_id) AS missing_product_id,
    COUNT(*) - COUNT(price) AS missing_price
FROM order_items;
-- Result: 
-- No NULL values were found in the selected key and analysis columns: order_id, product_id, price.

SELECT
    COUNT(*) - COUNT(product_id) AS missing_product_id,
    COUNT(*) - COUNT(product_category_name) AS missing_category
FROM products;
-- Result: 
-- No NULL values were found in the selected key and analysis columns: product_id, product_category_name.

SELECT
    order_status,
    COUNT(*) AS number_of_orders
FROM orders
GROUP BY order_status
ORDER BY number_of_orders DESC;
-- Result: 
-- Order statuses are: delivered, shipped, canceled, unavailable, invoiced, processing, created, approved.

SELECT
    MIN(order_purchase_timestamp) AS earliest_purchase,
    MAX(order_purchase_timestamp) AS latest_purchase
FROM orders;

SELECT
    order_purchase_timestamp
FROM orders
ORDER BY order_purchase_timestamp DESC
LIMIT 10;
-- Result:
-- order_purchase_timestamp is stored as TEXT.
-- Chronological date validation will be performed after converting the field to DATETIME during the cleaning stage.

SELECT COUNT(*) AS missing_purchase_dates
FROM orders
WHERE order_purchase_timestamp IS NULL;
-- Result: 
-- No NULL values were found for order_purchase_timestamp.

SELECT COUNT(*) AS unmatched_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
-- Result:
-- 0 unmatched order references.
-- Every order-item row is associated with an existing order.

SELECT COUNT(*) AS unmatched_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    COUNT(DISTINCT oi.product_id) AS unmatched_unique_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
-- Finding:
-- 1,604 order-item rows refer to 611 distinct product IDs that are absent from the products table.
-- These records require investigation before category-level analysis.

SELECT
    oi.product_id,
    COUNT(*) AS number_of_rows
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL
GROUP BY oi.product_id
ORDER BY number_of_rows DESC;

SELECT
    order_id,
    COUNT(*) AS number_of_items
FROM order_items
GROUP BY order_id
ORDER BY number_of_items DESC
LIMIT 20;

SELECT
    MAX(number_of_items) AS max_items_per_order
FROM (
    SELECT
        order_id,
        COUNT(*) AS number_of_items
    FROM order_items
    GROUP BY order_id
) AS order_counts;
-- Result: 
-- The biggest order has 21 items. 

SELECT
    COUNT(*) AS multi_item_orders
FROM (
    SELECT
        order_id
    FROM order_items
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS multi_orders;
-- Finding:
-- 9,803 orders contain more than one order-item row. This is expected ecommerce behaviour 
-- and confirms that orders and order items should be analysed at different levels.

