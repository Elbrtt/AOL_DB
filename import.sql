LOAD DATA INFILE 'online_retail_data.csv' 
INTO TABLE online_retail 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
SET CustomerID = NULIF(@vCustomerID, '');