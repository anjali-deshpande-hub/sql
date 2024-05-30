-- Cross Join
/*1. Suppose every vendor in the `vendor_inventory` table had 5 of each of their products to sell to **every** 
customer on record. How much money would each vendor make per product? 
Show this by vendor_name and product name, rather than using the IDs.

HINT: Be sure you select only relevant columns and rows. 
Remember, CROSS JOIN will explode your table rows, so CROSS JOIN should likely be a subquery. 
Think a bit about the row counts: how many distinct vendors, product names are there (x)?
How many customers are there (y). 
Before your final group by you should have the product of those two queries (x*y).  */
SELECT * FROM

-- subquery 1
(
	SELECT vendor_name, product_name, 5 * original_price AS total_cost FROM
		(
			SELECT 
				DISTINCT 
					v.vendor_name, 
					p.product_name, dense_rank() OVER (PARTITION BY vi.vendor_id ORDER BY vi.product_id) as num,
					vi.original_price
			FROM vendor_inventory vi

			JOIN product p
			ON vi.product_id = p.product_id
			JOIN vendor v
			ON vi.vendor_id = v.vendor_id
		)x
	WHERE num <= 5
)

CROSS JOIN 

-- subquery 2
(SELECT customer_first_name || ' ' || customer_last_name as customer_name FROM customer);


-- INSERT
/*1.  Create a new table "product_units". 
This table will contain only products where the `product_qty_type = 'unit'`. 
It should use all of the columns from the product table, as well as a new column for the `CURRENT_TIMESTAMP`.  
Name the timestamp column `snapshot_timestamp`. */
-- SELECT *, snapshot_timestamp AS CURRENT_TIMESTAMP FROM product 

DROP TABLE IF EXISTS product_units;

CREATE TABLE product_units AS
SELECT *, DATETIME('now') AS snapshot_timestamp
FROM product
WHERE product_qty_type = 'unit';

/*2. Using `INSERT`, add a new row to the product_units table (with an updated timestamp). 
This can be any product you desire (e.g. add another record for Apple Pie). */

INSERT INTO product_units
VALUES(26,'Apple Pie','12"',3,'unit',DATETIME('now'));

-- DELETE
/* 1. Delete the older record for the whatever product you added. 


HINT: If you don't specify a WHERE clause, you are going to have a bad time.*/
DELETE FROM product_units WHERE product_id = 26;


-- UPDATE
/* 1.We want to add the current_quantity to the product_units table. 
First, add a new column, current_quantity to the table using the following syntax.

ALTER TABLE product_units
ADD current_quantity INT;

Then, using UPDATE, change the current_quantity equal to the last quantity value from the vendor_inventory details.

HINT: This one is pretty hard. 
First, determine how to get the "last" quantity per product. 
Second, coalesce null values to 0 (if you don't have null values, figure out how to rearrange your query so you do.) 
Third, SET current_quantity = (...your select statement...), remembering that WHERE can only accommodate one column. 
Finally, make sure you have a WHERE statement to update the right row, 
	you'll need to use product_units.product_id to refer to the correct row within the product_units table. 
When you have all of these components, you can run the update statement. */

ALTER TABLE product_units
ADD current_quantity INT;

DROP TABLE IF EXISTS temp.product_last_qty;
CREATE TEMP TABLE product_last_qty AS
		-- get the last quantity value
		SELECT product_id, quantity FROM 
		(
			SELECT vendor_id, product_id, quantity,
			ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY market_date DESC) as last_qty
			
			FROM vendor_inventory
		) x
		WHERE x. last_qty = 1;

-- set the current_quantity value to the one calculated in the temp table
UPDATE product_units
SET current_quantity = coalesce(t.quantity, 0)
FROM temp.product_last_qty AS t
WHERE product_units.product_id = t.product_id;

-- set the null values to 0
UPDATE product_units
SET current_quantity = 0
WHERE product_units.current_quantity IS NULL  