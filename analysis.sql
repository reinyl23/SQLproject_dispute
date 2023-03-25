-- Creating a table

CREATE TABLE invoices
  (country varchar,
  customer_id varchar,
  invoice_number numeric,
  invoice_date date,
  due_date date,
  invoice_amount numeric,
  disputed numeric,
  dispute_lost numeric,
  settled_date date,
  days_settled integer,
  days_late integer
  );
  
-- Importing the table

COPY invoices
FROM '...\invoices.csv'
DELIMITER ','
CSV HEADER;

-- Overview of the Dataset

SELECT *
FROM invoices;

-- Number of Invoices per Country

SELECT country, COUNT(country) AS number_of_invoices
FROM invoices
GROUP BY country
ORDER BY COUNT(country) ASC;

-- Number of Disputes per Country

SELECT country, COUNT(country) AS number_of_disputes
FROM invoices
WHERE disputed = 1
GROUP BY country
ORDER BY COUNT(country) ASC;

-- Number of Lost Disputes per Country

SELECT country, COUNT(country) AS number_of_disputes_lost
FROM invoices
WHERE dispute_lost = 1
GROUP BY country
ORDER BY COUNT(country);

-- Top 10 Customers with the Highest Invoice Amount

SELECT country, invoice_amount
FROM  invoices
WHERE dispute_lost != 1
ORDER BY invoice_amount DESC
LIMIT 10

-- Revenue Lost per Country

SELECT country, SUM(invoice_amount) AS revenue_lost
FROM invoices
WHERE dispute_lost = 1
GROUP BY country
ORDER BY revenue_lost ASC;

-- Revenue per Country

SELECT country, SUM(invoice_amount*(CASE WHEN dispute_lost = 0 THEN 1 ELSE 0 END)) AS revenue
FROM invoices
GROUP BY country
ORDER BY revenue;

-- Average Processing Time Settling Invoices

SELECT ROUND(AVG(days_settled),2) AS average_days_settled
FROM invoices;

SELECT country, ROUND(AVG(days_settled),2) AS average_days_settled
FROM invoices
GROUP BY country
ORDER BY average_days_settled;

-- Average Processing Time Settling Disputes

SELECT ROUND(AVG(days_settled),2) AS average_days_settled
FROM invoices
WHERE disputed = 1;

SELECT country, ROUND(AVG(days_settled),2) AS average_days_settled
FROM invoices
WHERE disputed = 1
GROUP BY country
ORDER BY average_days_settled;
