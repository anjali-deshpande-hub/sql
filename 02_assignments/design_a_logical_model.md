# Assignment 1: Design a Logical Model

## Question 1
Create a logical model for a small bookstore. 📚

At the minimum it should have employee, order, sales, customer, and book entities (tables). Determine sensible column and table design based on what you know about these concepts. Keep it simple, but work out sensible relationships to keep tables reasonably sized. Include a date table. There are several tools online you can use, I'd recommend [_Draw.io_](https://www.drawio.com/) or [_LucidChart_](https://www.lucidchart.com/pages/).

The Logical model for a small bookstore can be found at 

https://github.com/anjali-deshpande-hub/sql/blob/model-design/02_assignments/book_store_data_model-Question-1.jpg

## Question 2
We want to create employee shifts, splitting up the day into morning and evening. Add this to the ERD.

The Logical model for the bookstore with employee shifts table can be found at 

https://github.com/anjali-deshpande-hub/sql/blob/model-design/02_assignments/book_store_data_model-Question-2.jpg

## Question 3
The store wants to keep customer addresses. Propose two architectures for the CUSTOMER_ADDRESS table, one that will retain changes, and another that will overwrite. Which is type 1, which is type 2?

_Hint, search type 1 vs type 2 slowly changing dimensions._

Bonus: Are there privacy implications to this, why or why not?
```
Design 1:

In design 1 (SCD Type 1) , the existing address is overwritten with the new address when ever there is a modification
to the customer's address. The design only keeps the most recent address for each customer. The previous address
data is overwritten.

CREATE TABLE CUSTOMER_ADDRESS (
	address_id int(12) NOT NULL PRIMARY KEY,
	customer_id int(12) NOT NULL,
	street varchar(255), 
	city varchar(50), 
	state varchar(50), 
	postal_code varchar(7), 
	last_updated DATETIME,
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
); 

This design is simple, requires less storage and does not retain historical data. 

Design 2:

In  design 2 (SCD Type 2), the  CUSTOMER_ADDRESS table retains the historical address data by creating a new record
every time there is modification to any of the fields. It allows us to keep history of all address changes for each
customer.

CREATE TEMP TABLE CUSTOMER_ADDRESS ( 
	address_id int(12) NOT NULL PRIMARY KEY, 
	customer_id int(12), 
	street VARCHAR(255), 
	city VARCHAR(50), 
	state VARCHAR(50), 
	postal_code VARCHAR(7), 
	start_date DATETIME, 
	end_date DATETIME, 
	is_current BOOLEAN NOT NULL ,
   FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
); 

Every time the customer's address changes, there is a new record created in this table. The end_date for the
existing record for the customer is set to CURRENT_TIMESTAMP  and is_current flag is set to FALSE. There is
a new record created for the new address where the start_date is  set to CURRENT_TIMESTAMP and the end_date
is set to NULL and is_current is set to TRUE.

Design 2  is complex as compared to Design 1. There are privacy concerns because there is retention of
historical data. If historical data is no longer necessary, it should be deleted. Since the amount of
data being stored is more, there is all the more need to protect the user data. There is also need to
inform the customers about what data is being stored and the reason for storing historical data.

```

## Question 4
Review the AdventureWorks Schema [here](https://i.stack.imgur.com/LMu4W.gif)

Highlight at least two differences between it and your ERD. Would you change anything in yours?
```

1. The AdventureWorks schema is very complex where in the tables cover a wide range of business functions
like HR, Production, Sales, Purchasing etc. It is suitable for large scale enterprises where there is need for
employee management, sales data management and production management. There is extensive product and production
 tracking including bills and credit card transactions. There is employee and department tracking capabilities
 including shifts.
The bookstore ERD is ideal for a bookstore in small retail space. The bookstore has basic order and customer
details, book inventory with supplier information, employee details including shift management. The date table
can be used to analyze data associated with sales and employee shifts.


2. Adventure Works maintains historical data for sales, production and employee departments. It includes
SCD (Slowly Changing Dimensions) for maintaining historical data in HR and Sales.
In Bookstore ERD, historical tracking is limited to order history and employee shifts.
There is less focus on tracking historical data. 

I would add design for payment via credit card/debit card along with shopping cart capabilities.
```

# Criteria

[Assignment Rubric](./assignment_rubric.md)

# Submission Information

🚨 **Please review our [Assignment Submission Guide](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md)** 🚨 for detailed instructions on how to format, branch, and submit your work. Following these guidelines is crucial for your submissions to be evaluated correctly.

### Submission Parameters:
* Submission Due Date: `June 1, 2024`
* The branch name for your repo should be: `model-design`
* What to submit for this assignment:
    * This markdown (design_a_logical_model.md) should be populated.
    * Two Entity-Relationship Diagrams (preferably in a pdf, jpeg, png format).
* What the pull request link should look like for this assignment: `https://github.com/<your_github_username>/sql/pull/<pr_id>`
    * Open a private window in your browser. Copy and paste the link to your pull request into the address bar. Make sure you can see your pull request properly. This helps the technical facilitator and learning support staff review your submission easily.

Checklist:
- [ ] Create a branch called `model-design`.
- [ ] Ensure that the repository is public.
- [ ] Review [the PR description guidelines](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md#guidelines-for-pull-request-descriptions) and adhere to them.
- [ ] Verify that the link is accessible in a private browser window.

If you encounter any difficulties or have questions, please don't hesitate to reach out to our team via our Slack at `#cohort-3-help`. Our Technical Facilitators and Learning Support staff are here to help you navigate any challenges.
