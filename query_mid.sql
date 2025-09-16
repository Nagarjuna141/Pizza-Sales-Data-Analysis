--Basic:

--Retrieve the total number of orders placed.

SELECT COUNT(order_id) AS total_orders FROM orders

--Calculate the total revenue generated from pizza sales.

SELECT ROUND(SUM(od.quantity *price),2) AS total_revenu FROM pizzas AS p
	JOIN order_details AS od
	ON od.pizza_id = p.pizza_id 

--Identify the highest-priced pizza
SELECT name,prices FROM (
SELECT pt.name,ROUND(MAX(p.price),2) AS prices,
RANK() OVER(ORDER BY ROUND(MAX(p.price),2) DESC) AS Ranks
FROM pizza_types AS pt
	JOIN pizzas as p
	ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
)
AS sub
WHERE ranks = 1
--Identify the most common pizza size ordered.


SELECT p.size,COUNT(od.order_details_id) as number_in_size
FROM pizzas as p
	JOIN order_details AS od
	ON od.pizza_id = p.pizza_id 
GROUP BY size


--List the top 5 most ordered pizza types along with their quantities.

SELECT name,quantitie FROM
(
SELECT name,SUM(od.quantity) AS quantitie,
DENSE_RANK() OVER(ORDER BY count(od.quantity) DESC) as ranks
FROM order_details AS od
	JOIN pizzas as p
	ON od.pizza_id = p.pizza_id 
	JOIN pizza_types as pt
	ON pt.pizza_type_id = p.pizza_type_id 
GROUP BY name
) AS sub 
WHERE ranks <= 5


--Intermediate:
--Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT category,SUM(od.quantity) AS quantitie
FROM order_details AS od
	JOIN pizzas as p
	ON od.pizza_id = p.pizza_id 
	JOIN pizza_types as pt
	ON pt.pizza_type_id = p.pizza_type_id 
GROUP BY category
ORDER BY quantitie DESC

--Determine the distribution of orders by hour of the day.

--SELECT HOUR(time) as hours,Count(order_id) FROM orders
--GROUP BY hours;

--Join relevant tables to find the category-wise distribution of pizzas.

SELECT category,COUNT(name) AS distribution
FROM  pizza_types 
GROUP BY category
ORDER BY 2 DESC

--Group the orders by date and calculate the average number of pizzas ordered per day.


SELECT AVG(count_pizzas) as avg_pizzas_per_day
FROM
(
SELECT o.date,SUM(od.quantity)AS count_pizzas FROM orders as o
	JOIN order_details as od
	ON o.order_id =od.order_id
GROUP BY o.date
) AS sub


--Determine the top 3 most ordered pizza types based on revenue.
SELECT name,total_revenu FROM 
(
SELECT pt.name,ROUND(SUM(od.quantity *price),2) AS total_revenu,
RANK() OVER(ORDER BY ROUND(SUM(od.quantity *price),2) DESC) as ranks
FROM pizzas AS p
	JOIN pizza_types as pt
	ON pt.pizza_type_id = p.pizza_type_id
	JOIN order_details AS od
	ON od.pizza_id = p.pizza_id
GROUP BY pt.name
) AS sub
WHERE ranks <=3


--Advanced:
--Calculate the percentage contribution of each pizza type to total revenue.

SELECT pt.category,ROUND(SUM(od.quantity *price)/(SELECT ROUND(SUM(od.quantity *price),2) AS total_revenu FROM pizzas AS p
	JOIN order_details AS od
	ON od.pizza_id = p.pizza_id)*100 ,2)  AS per_revenu
FROM pizzas AS p
	JOIN pizza_types as pt
	ON pt.pizza_type_id = p.pizza_type_id
	JOIN order_details AS od
	ON od.pizza_id = p.pizza_id
	GROUP BY pt.category

--Analyze the cumulative revenue generated over time.
SELECT date,SUM(total_revenu)over(ORDER BY date) as cumlative FROM
(
SELECT o.date,ROUND(SUM(od.quantity *price),2)AS total_revenu
FROM order_details AS od
	JOIN orders as o
	ON o.order_id = od.order_id
	JOIN pizzas AS p
	ON od.pizza_id = p.pizza_id
GROUP BY o.date
) AS sub
GROUP BY date




--Determine the top 3 most ordered pizza types based on revenue for each pizza category.	
SELECT name,category,total_revenu FROM
(
SELECT pt.name,pt.category,ROUND(SUM(od.quantity *price),2)AS total_revenu,
DENSE_RANK() OVER(PARTITION BY pt.category  ORDER BY ROUND(SUM(od.quantity *price),2)DESC) AS ranks
FROM pizzas AS p
	JOIN pizza_types as pt
	ON pt.pizza_type_id = p.pizza_type_id
	JOIN order_details AS od
	ON od.pizza_id = p.pizza_id
GROUP BY pt.name,pt.category
) AS sub
WHERE ranks <=3




SELECT * FROM orders
SELECT * FROM order_details
SELECT * FROM pizza_types
SELECT * FROM pizzas