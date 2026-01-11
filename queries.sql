-- Query 1: New Product. Add a new, never-before-seen product to the database.

INSERT INTO msproduct VALUES("ABCDE", "new, never-before-seen product", 6.7, 100);


-- Query 2: Customer Order. Write the series of statements required for an existing customer to order two different products in a single transaction.

START TRANSACTION;

-- Create invoice
INSERT INTO msinvoice VALUES ('98765', NOW(), '12362');
    
-- Add 1st item: 2 INFLATABLE POLITICAL GLOBE
INSERT INTO msorder VALUES ('98765', '10002', 2);
    
-- Add 2nd item: 1 WRAP ENGLISH ROSE
INSERT INTO msorder VALUES ('98765', '16161P', 1);
    
COMMIT;


-- Query 3: Customer Return. Write the statements required to process a return for one of the items from the order you created above.

START TRANSACTION;

-- Create return invoice. C prefix for 'cancel'
INSERT INTO msinvoice VALUES ('C98765', NOW(), '12362');

-- Use negative orderqty to signify return product
INSERT INTO msorder VALUES ('C98765', '10002', -1);

COMMIT;

-- Query 4: Analytical Report. Write a query to find the top 10 customers by total money spent.

SELECT
c.CustomerId,
c.CustomerName,
ROUND(SUM(o.OrderQuantity * p.BasePrice), 2) AS TotalSpent
FROM MsCustomer c
JOIN MsInvoice i ON c.CustomerId = i.CustomerId
JOIN MsOrder o ON i.InvoiceId = o.InvoiceId
JOIN MsProduct p ON o.StockCode = p.StockCode
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 10;


-- Query 5: Analytical Report. Write a query to identify the month with the highest total sales revenue in the year 2011.

SELECT 
    MONTHNAME(i.InvoiceDate) AS SalesMonth,
    ROUND(SUM(o.OrderQuantity * p.BasePrice), 2) AS MonthlyRevenue
FROM MsInvoice i
JOIN MsOrder o ON i.InvoiceId = o.InvoiceId
JOIN MsProduct p ON o.StockCode = p.StockCode
WHERE YEAR(i.InvoiceDate) = 2011
GROUP BY MONTH(i.InvoiceDate)
ORDER BY MonthlyRevenue DESC
LIMIT 1;

