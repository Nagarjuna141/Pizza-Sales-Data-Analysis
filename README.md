# Pizza Sales Analysis

##  Project Level
Intermediate to Advanced SQL Project

##  Project Overview  
This project analyzes pizza sales data using SQL.
The analysis includes exploring total sales, revenue, top-performing pizzas, category distribution, and revenue contribution.
It demonstrates data cleaning, joins, grouping, and advanced SQL techniques like window functions and ranking.
  

##  Objective   
- To understand pizza sales performance by analyzing order data.  
- To find top-performing pizzas, revenue contribution by category, and customer purchasing trends.
- To apply SQL queries (basic → intermediate → advanced) for real-world business insights.


---

##  SQL Basic Analysis 

```--Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_orders FROM orders;

--Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(od.quantity * price),2) AS total_revenu
FROM pizzas AS p
JOIN order_details AS od ON od.pizza_id = p.pizza_id;

--Identify the highest-priced pizza
SELECT name, prices
FROM (
    SELECT pt.name, ROUND(MAX(p.price),2) AS prices,
           RANK() OVER(ORDER BY ROUND(MAX(p.price),2) DESC) AS Ranks
    FROM pizza_types AS pt
    JOIN pizzas as p ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pt.name
) AS sub
WHERE ranks = 1;

--Identify the most common pizza size ordered.
SELECT p.size, COUNT(od.order_details_id) as number_in_size
FROM pizzas as p
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY size;

--List the top 5 most ordered pizza types along with their quantities.
SELECT name, quantitie
FROM (
    SELECT name, SUM(od.quantity) AS quantitie,
           DENSE_RANK() OVER(ORDER BY COUNT(od.quantity) DESC) as ranks
    FROM order_details AS od
    JOIN pizzas as p ON od.pizza_id = p.pizza_id
    JOIN pizza_types as pt ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY name
) AS sub
WHERE ranks <= 5;
```
---

## SQL Intermediate Analysis

```sql

--Find the total quantity of each pizza category ordered.
SELECT category, SUM(od.quantity) AS quantitie
FROM order_details AS od
JOIN pizzas as p ON od.pizza_id = p.pizza_id
JOIN pizza_types as pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY category
ORDER BY quantitie DESC;

--Category-wise distribution of pizzas.
SELECT category, COUNT(name) AS distribution
FROM pizza_types
GROUP BY category
ORDER BY 2 DESC;

--Average number of pizzas ordered per day.
SELECT AVG(count_pizzas) as avg_pizzas_per_day
FROM (
    SELECT o.date, SUM(od.quantity) AS count_pizzas
    FROM orders as o
    JOIN order_details as od ON o.order_id = od.order_id
    GROUP BY o.date
) AS sub;

--Top 3 most ordered pizza types based on revenue.
SELECT name, total_revenu
FROM (
    SELECT pt.name, ROUND(SUM(od.quantity * price),2) AS total_revenu,
           RANK() OVER(ORDER BY ROUND(SUM(od.quantity * price),2) DESC) as ranks
    FROM pizzas AS p
    JOIN pizza_types as pt ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY pt.name
) AS sub
WHERE ranks <= 3;

```


## SQL Advanced Analysis
```sql
--Percentage contribution of each pizza category to total revenue.
SELECT pt.category,
       ROUND(SUM(od.quantity * price) /
             (SELECT ROUND(SUM(od.quantity * price),2)
              FROM pizzas AS p
              JOIN order_details AS od ON od.pizza_id = p.pizza_id) * 100, 2) AS per_revenu
FROM pizzas AS p
JOIN pizza_types as pt ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category;

--Cumulative revenue generated over time.
SELECT date, SUM(total_revenu) OVER(ORDER BY date) as cumlative
FROM (
    SELECT o.date, ROUND(SUM(od.quantity * price),2) AS total_revenu
    FROM order_details AS od
    JOIN orders as o ON o.order_id = od.order_id
    JOIN pizzas AS p ON od.pizza_id = p.pizza_id
    GROUP BY o.date
) AS sub
GROUP BY date;

--Top 3 most ordered pizza types based on revenue for each category.
SELECT name, category, total_revenu
FROM (
    SELECT pt.name, pt.category,
           ROUND(SUM(od.quantity * price),2) AS total_revenu,
           DENSE_RANK() OVER(PARTITION BY pt.category
                             ORDER BY ROUND(SUM(od.quantity * price),2) DESC) AS ranks
    FROM pizzas AS p
    JOIN pizza_types as pt ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY pt.name, pt.category
) AS sub
WHERE ranks <= 3;

```

## Conclusion  
- Analyzed peak order times and daily sales distribution.
- Identified total revenue, order trends, and customer preferences using SQL.


