-- Analysis queries for Olist Project 1 (Postgres)
-- KPI scope: delivered orders only
-- Gross revenue definition: price + freight_value

-- 1) Monthly KPI table (revenue, orders, AOV, MoM growth)
WITH delivered AS (
  SELECT order_id, order_purchase_timestamp
  FROM orders
  WHERE order_status = 'delivered'
),
order_revenue AS (
  SELECT
    d.order_id,
    DATE_TRUNC('month', d.order_purchase_timestamp) AS order_month,
    SUM(oi.price + oi.freight_value) AS revenue
  FROM delivered d
  JOIN order_items oi ON oi.order_id = d.order_id
  GROUP BY 1,2
),
monthly AS (
  SELECT
    order_month,
    COUNT(DISTINCT order_id) AS orders,
    SUM(revenue) AS revenue,
    AVG(revenue) AS aov
  FROM order_revenue
  GROUP BY 1
)
SELECT
  order_month,
  orders,
  revenue,
  aov,
  (revenue / NULLIF(LAG(revenue) OVER (ORDER BY order_month), 0)) - 1 AS mom_growth
FROM monthly
ORDER BY order_month;

-- 2) Top categories by revenue
WITH delivered AS (
  SELECT order_id
  FROM orders
  WHERE order_status = 'delivered'
)
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue,
  COUNT(DISTINCT oi.order_id) AS orders,
  COUNT(*) AS items
FROM delivered d
JOIN order_items oi ON oi.order_id = d.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_translation t ON t.product_category_name = p.product_category_name
GROUP BY 1
ORDER BY revenue DESC
LIMIT 25;

-- 3) Revenue by customer state
WITH delivered AS (
  SELECT order_id, customer_id
  FROM orders
  WHERE order_status = 'delivered'
),
order_rev AS (
  SELECT
    d.order_id,
    d.customer_id,
    SUM(oi.price + oi.freight_value) AS revenue
  FROM delivered d
  JOIN order_items oi ON oi.order_id = d.order_id
  GROUP BY 1,2
)
SELECT
  c.customer_state AS state,
  ROUND(SUM(o.revenue), 2) AS revenue,
  COUNT(DISTINCT o.order_id) AS orders,
  ROUND(AVG(o.revenue), 2) AS aov
FROM order_rev o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY revenue DESC;

-- 4) Top customers
WITH delivered AS (
  SELECT order_id, customer_id
  FROM orders
  WHERE order_status = 'delivered'
),
order_rev AS (
  SELECT
    d.order_id,
    d.customer_id,
    SUM(oi.price + oi.freight_value) AS revenue
  FROM delivered d
  JOIN order_items oi ON oi.order_id = d.order_id
  GROUP BY 1,2
)
SELECT
  customer_id,
  ROUND(SUM(revenue), 2) AS revenue,
  COUNT(DISTINCT order_id) AS orders
FROM order_rev
GROUP BY 1
ORDER BY revenue DESC
LIMIT 50;

-- 5) Payment type mix (delivered orders)
WITH delivered AS (
  SELECT order_id
  FROM orders
  WHERE order_status = 'delivered'
),
order_pay AS (
  SELECT
    p.payment_type,
    SUM(p.payment_value) AS payment_value
  FROM delivered d
  JOIN order_payments p ON p.order_id = d.order_id
  GROUP BY 1
)
SELECT
  payment_type,
  ROUND(payment_value, 2) AS payment_value,
  ROUND(payment_value / NULLIF(SUM(payment_value) OVER (), 0), 4) AS share_of_payments
FROM order_pay
ORDER BY payment_value DESC;
