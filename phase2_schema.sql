CREATE TABLE MsCountry (
    CountryId INT AUTO_INCREMENT PRIMARY KEY,
    CountryName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE MsCustomer (
    CustomerId VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(50),
    CustomerPhone VARCHAR(20),
    Country INT NOT NULL,
    
    FOREIGN KEY (Country) REFERENCES MsCountry(CountryId)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE MsProduct (
    StockCode VARCHAR(15) PRIMARY KEY,
    Description TEXT NOT NULL,
    BasePrice DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL
);

CREATE TABLE MsInvoice (
    InvoiceId VARCHAR(10) PRIMARY KEY,
    InvoiceDate DATETIME NOT NULL,
    CustomerId VARCHAR(10),
    
    FOREIGN KEY (CustomerId) REFERENCES MsCustomer(CustomerId)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

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
