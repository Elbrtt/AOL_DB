CREATE TABLE online_retail (
    Invoice VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    Price DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(50)
);

LOAD DATA INFILE 'online_retail_data.csv' 
INTO TABLE online_retail 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;
