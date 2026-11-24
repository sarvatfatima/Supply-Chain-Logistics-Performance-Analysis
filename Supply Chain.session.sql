CREATE DATABASE supply_chain_analysis;
SELECT current_database();
DROP TABLE orders;
CREATE TABLE orders (
    order_id INT,
    order_item_id INT,
    sales DECIMAL(12,2),
    quantity INT,
    profit_ratio DECIMAL(6,4),
    category_name VARCHAR(100),
    product_name VARCHAR(255),
    shipping_mode VARCHAR(50),
    shipping_delay INT,
    shipping_performance VARCHAR(20),
    actual_shipping_days INT,
    scheduled_shipping_days INT,
    market VARCHAR(100),
    order_region VARCHAR(100),
    order_country VARCHAR(100),
    order_status VARCHAR(100),
    customer_segment VARCHAR(50),
    department_name VARCHAR(100),
    delivery_status VARCHAR(100),
    order_date TIMESTAMP,
    shipping_date TIMESTAMP
);
SELECT COUNT(*) FROM orders;
SELECT * FROM orders
LIMIT 5;
SELECT
    order_id,
    order_item_id,
    sales,
    quantity,
    category_name,
    product_name
FROM orders
LIMIT 5;
# HOW MANY UNIQUE ORDERS WE HAVE?
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

# WHAT IS THE TOTAL SALES REVENUE?
SELECT SUM(sales) AS total_sales
FROM orders;

# HOW MANY SHIPMENTS WERE DELAYED?
SELECT COUNT(*) AS delayed_shipments
FROM orders
WHERE shipping_performance = 'Delayed';

# WHICH SHIPPING MODE HAS THE HIGHEST NUMBER OF DELAYS?
SELECT
    shipping_mode,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN shipping_performance = 'Delayed' THEN 1 ELSE 0 END) AS delayed_shipments,
    ROUND(
        SUM(CASE WHEN shipping_performance = 'Delayed' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS delay_rate
FROM orders
GROUP BY shipping_mode
ORDER BY delay_rate DESC;

# WHICH REGIONS EXPERIENCE THE HIGHEST DELAY RATES IN SHIPPING?
SELECT
    order_region,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN shipping_performance = 'Delayed' THEN 1 ELSE 0 END) AS delayed_shipments,
    ROUND(
        SUM(CASE WHEN shipping_performance = 'Delayed' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS delay_rate
FROM orders
GROUP BY order_region
ORDER BY delay_rate DESC;

# WHICH PRODUCT CATEGORIES GENERATE THE HIGHEST SALES?
SELECT
    category_name,
    SUM(sales) AS total_sales
FROM orders
GROUP BY category_name
ORDER BY total_sales DESC;

# WHICH MARKET GENERATE THE HIGHEST SALES?
SELECT
    market,
    SUM(sales) AS total_sales
FROM orders
GROUP BY market
ORDER BY total_sales DESC;

# WHAT IS THE AVERAGE SHIPPING DELAY?
SELECT
    ROUND(AVG(shipping_delay), 2) AS average_shipping_delay
FROM orders
WHERE shipping_delay > 0;

# WHAT IS THE MOST COMMON ORDER STATUSES?
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

# HOW DOES SHIPPING PERFORMANCE VARY ACROSS DIFFERENT CUSTOMER SEGMENTS?
SELECT
    market,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN shipping_performance = 'Delayed' THEN 1 ELSE 0 END) AS delayed_shipments,
    SUM(CASE WHEN shipping_performance = 'On Time' THEN 1 ELSE 0 END) AS on_time_shipments,
    SUM(CASE WHEN shipping_performance = 'Early' THEN 1 ELSE 0 END) AS early_shipments
FROM orders
GROUP BY market
ORDER BY delayed_shipments DESC;