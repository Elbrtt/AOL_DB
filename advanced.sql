-- Create a trigger that automatically updates the inventory level of a product whenever a transaction (sale or return) involving that product is recorded.

DELIMITER $$
CREATE TRIGGER updateInventory
AFTER INSERT ON msorder
FOR EACH ROW
BEGIN
    UPDATE MsProduct
    SET StockQuantity = StockQuantity - NEW.OrderQuantity
    WHERE StockCode = NEW.StockCode;
END $$



-- Create a stored procedure named GetCustomerInvoiceHistory that accepts a CustomerID as input and returns a complete list of all invoices (including the date and total value) belonging to that customer.

DELIMITER $$
CREATE PROCEDURE GetCustomerInvoiceHistory(IN input_CustomerId VARCHAR(10))
BEGIN
    SELECT 
        i.InvoiceId,
        i.InvoiceDate,
        -- Calculate Total Value (Sum of Qty * Price for all items in that invoice)
        CAST(SUM(o.OrderQuantity * p.BasePrice) AS DECIMAL(10,2)) AS TotalValue
    FROM MsInvoice i
    JOIN MsOrder o ON i.InvoiceId = o.InvoiceId
    JOIN MsProduct p ON o.StockCode = p.StockCode
    WHERE i.CustomerId = input_CustomerId
    GROUP BY i.InvoiceId
    ORDER BY i.InvoiceDate DESC;
END $$

-- Test the Trigger
-- 1. Check current stock for product '21724'
SELECT StockQuantity FROM MsProduct WHERE StockCode = '21724';

-- 2. "Buy" 10 items (Insert a new order)
INSERT INTO msinvoice VALUES ('TEST123', now(), 12362);
INSERT INTO MsOrder VALUES ('TEST123', '21724', 10);

-- 3. Check stock again (It should be 10 lower)
SELECT StockQuantity FROM MsProduct WHERE StockCode = '21724';

-- Test the Procedure
CALL GetCustomerInvoiceHistory('12362');

