/*
Restaurant Order Analysis
*/

USE restaurant_db;

/*
Exploring the Items Table
*/

-- 1. 
SELECT DISTINCT 
	COUNT(item_name)
FROM menu_items;

-- 2. 
SELECT
	item_name,
    category,
    price
FROM menu_items
ORDER BY price;

-- 3. 
SELECT
    category,
    COUNT(item_name) AS number_of_dishes
FROM menu_items
GROUP BY
	category
HAVING category = 'Italian';

SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price;

-- 4. 
SELECT
    category,
    COUNT(item_name) AS number_of_dishes,
    AVG(price) AS avg_price
FROM menu_items
GROUP BY
	category;
 
 /*
Exploring the Orders Table
*/

-- 1. 
SELECT *
FROM order_details
ORDER BY order_date DESC;

-- 2. 
SELECT
	COUNT(DISTINCT order_id) AS number_of_orders
FROM order_details;

SELECT
	COUNT(*) AS number_of_items
FROM order_details;

-- 3. 
SELECT
	order_id,
    COUNT(item_id) AS number_of_items
FROM order_details
GROUP BY
	order_id
ORDER BY number_of_items DESC;

-- 4. 
SELECT COUNT(*)
FROM
(SELECT
	order_id,
    COUNT(item_id) AS number_of_items
FROM order_details
GROUP BY
	order_id
HAVING number_of_items > 12) AS num_orders;

/*
Customer Behavious Analysis
*/

-- 1. 
SELECT *
FROM order_details
	LEFT JOIN menu_items
		ON order_details.item_id = menu_items.menu_item_id;

-- 2.         
SELECT
	menu_items.item_name,
    menu_items.category,
    COUNT(order_details.order_details_id) AS ordered_item_count
FROM order_details
	LEFT JOIN menu_items
		ON order_details.item_id = menu_items.menu_item_id
GROUP BY
	menu_items.item_name,
    menu_items.category
ORDER BY ordered_item_count DESC;

-- 3. 
SELECT
	order_details.order_id,
    SUM(menu_items.price) AS total_money_spent
FROM order_details
	LEFT JOIN menu_items
		ON order_details.item_id = menu_items.menu_item_id
GROUP BY
	order_details.order_id
ORDER BY total_money_spent DESC
LIMIT 5;

-- 4. 
SELECT 
	menu_items.item_name,
    menu_items.category,
    COUNT(order_details.item_id) AS num_item
FROM order_details
	LEFT JOIN menu_items
		ON order_details.item_id = menu_items.menu_item_id
WHERE order_id = 440
GROUP BY
	menu_items.item_name,
    menu_items.category;
 
 -- 5. 
SELECT 
	order_details.order_id,
    menu_items.category,
    COUNT(order_details.item_id) AS num_item
FROM order_details
	LEFT JOIN menu_items
		ON order_details.item_id = menu_items.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY
	menu_items.category,
    order_details.order_id;