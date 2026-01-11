CREATE TABLE MsCountry (
    CountryId INT AUTO_INCREMENT PRIMARY KEY,
    CountryName VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO MsCountry (CountryName)
SELECT DISTINCT Country 
FROM online_retail 
WHERE Country IS NOT NULL;

CREATE TABLE MsCustomer (
    CustomerId VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(50),
    CustomerPhone VARCHAR(20),
    Country INT NOT NULL,
    
    FOREIGN KEY (Country) REFERENCES MsCountry(CountryId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

INSERT INTO MsCustomer (CustomerId, CustomerName, CustomerPhone, Country)
SELECT DISTINCT 
    CAST(t.Customer_ID AS CHAR(10)) AS CustomerId, -- Convert float/int to string
    "John" AS CustomerName,
    "0123456789" AS CustomerPhone,
    c.CountryId
FROM online_retail t
JOIN MsCountry c ON t.Country = c.CountryName
WHERE t.Customer_ID IS NOT NULL;

CREATE TABLE MsProduct (
    StockCode VARCHAR(15) PRIMARY KEY,
    Description TEXT NOT NULL,
    BasePrice DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL
);

INSERT INTO MsProduct (StockCode, Description, BasePrice, StockQuantity)
SELECT 
    StockCode, 
    MAX(Description) as Description, -- Pick one description if duplicates exist
    MAX(Price) as BasePrice,         -- Pick the highest recorded price
    1001 as StockQuantity            -- Default
FROM online_retail
GROUP BY StockCode;

CREATE TABLE MsInvoice (
    InvoiceId VARCHAR(10) PRIMARY KEY,
    InvoiceDate DATETIME NOT NULL,
    CustomerId VARCHAR(10),
    
    FOREIGN KEY (CustomerId) REFERENCES MsCustomer(CustomerId)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO MsInvoice (InvoiceId, InvoiceDate, CustomerId)
SELECT 
    Invoice AS InvoiceId,
    MIN(InvoiceDate) AS InvoiceDate, -- Takes the first timestamp if duplicates exist
    MAX(CASE 
        WHEN Customer_ID IS NULL THEN NULL
        ELSE CAST(Customer_ID AS CHAR(10)) 
    END) AS CustomerId
FROM online_retail
GROUP BY Invoice;

CREATE TABLE MsOrder (
    InvoiceId VARCHAR(10),
    StockCode VARCHAR(15),
    OrderQuantity INT NOT NULL,
    
    PRIMARY KEY (InvoiceId, StockCode),
    
    FOREIGN KEY (InvoiceId) REFERENCES MsInvoice(InvoiceId)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    
    FOREIGN KEY (StockCode) REFERENCES MsProduct(StockCode)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

INSERT INTO MsOrder (InvoiceId, StockCode, OrderQuantity)
SELECT 
    Invoice,
    StockCode,
    SUM(Quantity) -- Sum duplicates to merge into one line item per product
FROM online_retail
GROUP BY Invoice, StockCode;
