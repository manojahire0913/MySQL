/* Q1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)

a.	Fetch the employee number, first name and last name of those employees 
who are working as Sales Rep reporting to employee with employeenumber 1102 (Refer employee table) */
-- Solution:
 
USE classicmodels;
 
SELECT * FROM employees;

SELECT employeeNumber, Firstname, lastname
FROM employees
WHERE reportsTo = 1102;

/*b.	Show the unique productline values containing the word cars at the end from the products table*/

SELECT * FROM products;

SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars%';

/* Q2. CASE STATEMENTS for Segmentation
a. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table)
                        "North America" for customers from USA or Canada
                        "Europe" for customers from UK, France, or Germany
                        "Other" for all remaining countries
     Select the customerNumber, customerName, and the assigned region as "CustomerSegment". */
SELECT customernumber,customerName,
CASE
	WHEN country = 'USA' OR 'CANADA' THEN 'NORTH AMERICA'
	WHEN country = 'UK' OR 'FRANCE' OR 'GERMANY' THEN 'Europe'
ELSE 'OTHERS'
    END AS customer_segment
FROM customers;

/* Q3. Group By with Aggregation functions and Having clause, Date and Time functions

a.	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders. */

SELECT * FROM orderdetails;

SELECT productcode, SUM(quantityOrdered) AS total_ordered
FROM orderdetails
GROUP BY productCode
ORDER BY TOTAL_ORDERED DESC
LIMIT 10;

/* 
b.	Company wants to analyse payment frequency by month. 
Extract the month name from the payment date to count 
the total number of payments for each month and include only those months with a payment count exceeding 20.
 Sort the results by total number of payments in descending order.  (Refer Payments table). */

SELECT * FROM PAYMENTS;
 
SELECT MONTHNAME(paymentDate) AS Month, COUNT(*) AS NUM_Payments
FROM Payments
GROUP BY Month
HAVING NUM_Payments > 20
ORDER BY NUM_Payments DESC; 


/*
Q4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default
Create a new database named and Customers_Orders and add the following tables as per the description
a.Create a table named Customers to store customer information. Include the following columns:
customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
first_name: This should be a VARCHAR(50) to store the customer's first name.
last_name: This should be a VARCHAR(50) to store the customer's last name.
email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
phone_number: This can be a VARCHAR(20) to allow for different phone number formats.

Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value. */

create database Customers_Orders;

use customers_orders;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

desc customers;

/*
b.	Create a table named Orders to store information about customer orders. Include the following columns:
order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
customer_id: This should be an integer referencing the customer_id in the Customers table  (FOREIGN KEY).
order_date: This should be a DATE data type to store the order date.
total_amount: This should be a DECIMAL(10,2) to store the total order amount.
     	
Constraints:
a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
b)	Add a CHECK constraint to ensure the total_amount is always a positive value. */


 
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    order_date DATE,
    total_amount DECIMAL(10 , 2 ) CHECK (total_amount > 0)
);

desc orders;


/*
Q5. JOINS
a. List the top 5 countries (by order count) that Classic Models ships to. (Use the Customers and Orders tables)
*/

Use classicmodels;

SELECT * FROM customers;

SELECT * FROM ORDERS;

SELECT c.country, COUNT(O.orderNumber) AS orderCount
FROM Customers AS C
JOIN Orders AS O ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY orderCount DESC
LIMIT 5;

/*
Q6. SELF JOIN
a. Create a table project with below fields.
●	EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
●	FullName: varchar(50) with no null values
●	Gender : Values should be only ‘Male’  or ‘Female’
●	ManagerID: integer 
*/
use customers_orders;

create table project(Employee_ID int primary key auto_increment,
FullName varchar(50) not null,
Gender enum('male', 'female'),
ManagerID int);

desc project;

insert into project values
(1,"Pranaya", "Male",3),
(2,"priyanka","Female",1),
(3,"Preety","Female",null),
(4,"Anurag","male",1),
(5,"Sambit","male",1),
(6,"Rajesh","male",3),
(7,"Hina","Female",3);


select * from project;

select 
m.fullname AS ManagerName,
e.fullname AS EmployeeName
from project e
join project m
on e.managerid = m.employee_ID
order by managername;


/*
Q7. DDL Commands: Create, Alter, Rename
a. Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.
*/

CREATE TABLE FACILITY 
(
    FACILITY_ID INT,
    NAME VARCHAR(55),
    STATE VARCHAR(120),
    COUNTRY VARCHAR(80)
);
#Answer i)
ALTER table FACILITY
modify column FACILITY_ID
INT primary KEY auto_increment;

DESC FACILITY;

#Answer ii)
ALTER TABLE FACILITY
ADD COLUMN CITY VARCHAR(255) NOT NULL AFTER NAME;

DESC FACILITY;

ALTER TABLE FACILITY
CHANGE FACILITY_ID 
FACILITYid INT auto_increment;

DESC FACILITY;



/*
Q8. Views in SQL
a. Create a view named product_category_sales that provides insights into sales performance by product category.
 This view should include the following information:
productLine: The category name of the product (from the ProductLines table).

total_sales: The total revenue generated by products within that category 
(calculated by summing the orderDetails.quantity * orderDetails.priceEach for each product in the category).

number_of_orders: The total number of orders containing products from that category.

(Hint: Tables to be used: Products, orders, orderdetails and productlines)
*/
use classicmodels;

CREATE VIEW product_category_sales AS
SELECT pl.productLine, 
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM Products p
JOIN ProductLines pl ON p.productLine = pl.productLine
JOIN OrderDetails od ON p.productCode = od.productCode
JOIN Orders o ON od.orderNumber = o.orderNumber
GROUP BY pl.productLine;

select * from product_category_sales
ORDER BY 
total_sales DESC;

/*
Q9. Stored Procedures in SQL with parameters

a. Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments
*/

#Answer
/*
CREATE PROCEDURE `Get_country_payments` (IN input_year INT, IN input_country VARCHAR(50))
BEGIN
  SELECT 
        YEAR(payments.paymentDate) AS Year,
        customers.country,
        CONCAT(ROUND(SUM(payments.amount)/1000, 0), 'K') AS TotalAmount
    FROM 
        payments
    JOIN 
        customers ON payments.customerNumber = customers.customerNumber
    WHERE 
        YEAR(payments.paymentDate) = input_year
        AND customers.country = input_country
    GROUP BY 
        YEAR(payments.paymentDate), customers.country;
END
select * from customers;
select * from payments;
 */
 
 CALL Get_country_payments(2003, 'France');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Q10. Window functions - Rank, dense_rank, lead and lag

a) Using customers and orders tables, rank the customers based on their order frequency
*/

#Answer

WITH customer_order_count AS (
SELECT c.customerName, 
COUNT(o.orderNumber) AS order_count
FROM customers c
JOIN orders o 
ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
)
SELECT customerName, order_count,
DENSE_RANK() OVER (ORDER BY order_count DESC) AS order_frequency_rnk
FROM customer_order_count
ORDER BY order_frequency_rnk;
/* 
 b) Calculate year wise, month name wise count of orders and month over month (MoM) percentage change. Format the MoM values in no decimals and show in % sign.
Table: Orders
*/
 #Answer

WITH MonthlyOrders AS (SELECT
YEAR(orderDate) AS Year,
MONTHNAME(orderDate) AS Month,
COUNT(orderNumber) AS Total_Orders,
MONTH(orderDate) AS MonthNum
FROM Orders GROUP BY Year, MonthNum, Month
)
SELECT Year,Month,Total_Orders,CONCAT( ROUND(
CASE WHEN LAG(Total_Orders) OVER (ORDER BY Year, MonthNum) IS NULL OR LAG(Total_Orders) OVER (ORDER BY Year, MonthNum) = 0 THEN NULL
ELSE ((Total_Orders - LAG(Total_Orders) OVER (ORDER BY Year, MonthNum)) / LAG(Total_Orders) OVER (ORDER BY Year, MonthNum)) * 100
END,0), '%') AS MoM_Change
FROM MonthlyOrders
ORDER BY Year, MonthNum;

/*
Q11.Subqueries and their applications

a. Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.
*/
use classicmodels;

select * from products;

SELECT Productline, COUNT(*) AS total FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY productLine
ORDER BY total DESC;

/*
Q12. ERROR HANDLING in SQL
      Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.
*/

CREATE TABLE IF NOT EXISTS Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(150)
);

desc emp_eh;

/* Store Procedure
CREATE DEFINER=`root`@`localhost` PROCEDURE `Emp_EH`(EmpID INT ,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(150))

BEGIN
Declare exit handler for sqlexception
Begin 
select "Error occured" as warning;
end;
insert into emp_eh values(empid,empname,emailaddress);

select 'employee record inserted successfully' as message; 
END
desc emp_eh;

use classicmodels;
*/

/*
Q13. TRIGGERS
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.

*/

CREATE TABLE IF NOT EXISTS EMP_BIT
(NAME VARCHAR(50),
OCCUPATION VARCHAR(50),
WORKING_DATE date,
WORKING_HOURS int
);

INSERT INTO EMP_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

drop table exemp_bit;

/*
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
IF WORKING_HOURS < 0 THEN 
SET NEW.WORKING_HOURS = abs(NEW.WORKING_HOURS);
END IF;
END
*/

#INSERT INTO  values ('Antonio', 'Business', '2020-10-04', 11);
use classicmodels;

SELECT * FROM orders;

SELECT orderdate,
YEAR(orderDate) AS Year,
MONTHNAME(orderDate) AS Month,
COUNT(orderNumber) AS Total_Orders,
MONTH(orderDate) AS MonthNum
FROM Orders group by year(orderdate);

SELECT * FROM MYEMP;

SELECT DISTINCT SALARY, DEP_IDFROM MYEMP;

SELECT DISTINCT * FROM  MYEMP;