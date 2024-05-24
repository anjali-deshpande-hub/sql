-- COALESCE
/* 1. Our favourite manager wants a detailed long list of products, but is afraid of tables! 
We tell them, no problem! We can produce a list with all of the appropriate details. 

Using the following syntax you create our super cool and not at all needy manager a list:

SELECT 
product_name || ', ' || product_size|| ' (' || product_qty_type || ')'
FROM product

But wait! The product table has some bad data (a few NULL values). 
Find the NULLs and then using COALESCE, replace the NULL with a 
blank for the first problem, and 'unit' for the second problem. 

HINT: keep the syntax the same, but edited the correct components with the string. 
The `||` values concatenate the columns into strings. 
Edit the appropriate columns -- you're making two edits -- and the NULL rows will be fixed. 
All the other rows will remain the same.) */
SELECT 
product_name || ', ' || COALESCE(product_size, ' ') || ' (' || COALESCE(product_qty_type, 'unit')  || ')' AS product
FROM product


--Windowed Functions
/* 1. Write a query that selects from the customer_purchases table and numbers each customer’s  
visits to the farmer’s market (labeling each market date with a different number). 
Each customer’s first visit is labeled 1, second visit is labeled 2, etc. 

You can either display all rows in the customer_purchases table, with the counter changing on
each new market date for each customer, or select only the unique market dates per customer 
(without purchase details) and number those visits. 
HINT: One of these approaches uses ROW_NUMBER() and one uses DENSE_RANK(). */

SELECT ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY c.customer_id, cp.market_date) as row_no
, cp.customer_id, cp.market_date, c.customer_first_name, c.customer_last_name 
FROM customer_purchases cp
LEFT JOIN customer c
ON cp.customer_id = c.customer_id


SELECT DISTINCT DENSE_RANK() OVER (PARTITION BY c.customer_id ORDER BY c.customer_id, cp.market_date) as rank_no, 
cp.customer_id, cp.market_date, c.customer_first_name, c.customer_last_name
FROM customer_purchases cp
LEFT JOIN customer c
ON cp.customer_id = c.customer_id

/* 2. Reverse the numbering of the query from a part so each customer’s most recent visit is labeled 1, 
then write another query that uses this one as a subquery (or temp table) and filters the results to 
only the customer’s most recent visit. */
SELECT customer_id, market_date, customer_first_name, customer_last_name FROM
(
	SELECT DISTINCT cp.customer_id, cp.market_date, c.customer_first_name, c.customer_last_name,
	DENSE_RANK() OVER (PARTITION BY cp.customer_id ORDER BY cp.customer_id, cp.market_date DESC) as rank_no
	FROM customer_purchases cp
	LEFT JOIN customer c
	ON cp.customer_id = c.customer_id

) x
WHERE x.rank_no = 1

/* 3. Using a COUNT() window function, include a value along with each row of the 
customer_purchases table that indicates how many different times that customer has purchased that product_id. */

SELECT DISTINCT customer_id, product_id, COUNT(product_id) OVER(PARTITION BY customer_id, product_id) AS product_count
FROM customer_purchases 

-- Another way to do the same
SELECT customer_id, product_id, COUNT(product_id) AS product_count
FROM customer_purchases 
GROUP BY customer_id, product_id
ORDER BY customer_id, product_id