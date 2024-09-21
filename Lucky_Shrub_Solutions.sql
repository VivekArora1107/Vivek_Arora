-- Task 1 solution:
CREATE FUNCTION FindAverageCost(YearInput INT) 
RETURNS DECIMAL(10,2) DETERMINISTIC 
RETURN (SELECT AVG(Cost) FROM Orders WHERE YEAR(Date) = YearInput); 

SELECT FindAverageCost(2022);

-- Task 2 solution:
DELIMITER // 
CREATE PROCEDURE EvaluateProduct(IN product_id VARCHAR(10), OUT SoldItemsIn2020 INT, OUT SoldItemsIn2021 INT, OUT SoldItemsIn2022 INT)
BEGIN
SELECT SUM(Quantity) INTO SoldItemsIn2020 FROM Orders WHERE ProductID=product_id AND YEAR(Date)=2020; 
SELECT SUM(Quantity) INTO SoldItemsIn2021 FROM Orders WHERE ProductID=product_id AND YEAR(Date)=2021;
SELECT SUM(Quantity) INTO SoldItemsIn2022 FROM Orders WHERE ProductID=product_id AND YEAR(Date)=2022; 
END //
DELIMITER ;

-- Call the procedure:
CALL EvaluateProduct('P1', @sold_items_2020, @sold_items_2021, @sold_items_2022);

-- Output the variables values:
SELECT @sold_items_2020, @sold_items_2021, @sold_items_2022;

-- Task 3 Solution
CREATE TRIGGER UpdateAudit AFTER INSERT 
ON Orders 
FOR EACH ROW 
INSERT INTO Audit (OrderDateTime) 
VALUES (Current_timestamp);

-- Inserting only 1 Values:
INSERT INTO Orders (OrderID, ClientID, ProductID , Quantity, Cost, Date) VALUES   
(31, "Cl1", "P1", 12, 512, "2022-09-12" );

-- Viewing Audit Table:
SELECT * FROM Audit;

-- Task 4 Solution
SELECT Employees.FullName, Addresses.Street, Addresses.County 
FROM Employees INNER JOIN Addresses 
ON Employees.AddressID = Addresses.AddressID
UNION
SELECT Clients.FullName, Addresses.Street, Addresses.County 
FROM Clients INNER JOIN Addresses ON Clients.AddressID = Addresses.AddressID 
ORDER BY Street;

-- Task 5 Solution
-- Optimizing the query by recreating a common table expression (CTE)
WITH
P2_Sales_2020 AS (SELECT CONCAT(SUM(Cost), " (2020)") AS "Total sum of P2 Product" FROM Orders WHERE YEAR(Date) = 2020 AND ProductID= "P2"),
P2_Sales_2021 AS (SELECT CONCAT(SUM(Cost), " (2021)") AS "Total sum of P2 Product" FROM Orders WHERE YEAR(Date) = 2021 AND ProductID= "P2"),
P2_Sales_2022 AS (SELECT CONCAT(SUM(Cost), " (2022)") AS "Total sum of P2 Product" FROM Orders WHERE YEAR(Date) = 2022 AND ProductID= "P2")
SELECT * FROM P2_Sales_2020
UNION
SELECT * FROM P2_Sales_2021
UNION
SELECT * FROM P2_Sales_2022;

-- Task 6 Solution
SELECT Activity.Properties ->>'$.ClientID' 
AS ClientID, Activity.Properties ->>'$.ProductID' 
AS ProductID, Clients.FullName, Clients.ContactNumber 
FROM Clients RIGHT JOIN Activity 
ON Clients.ClientID = Activity.Properties ->>'$.ClientID';

-- Task 7 Solution
-- Use the following code to create the procedure:
DELIMITER //
CREATE PROCEDURE GetProfit(IN product_id VARCHAR(10), IN YearInput INT)
BEGIN
DECLARE profit DEC(7,2) DEFAULT 0.0; 
DECLARE sold_quantity, buy_price, sell_price INT DEFAULT 0;
SELECT SUM(Quantity) INTO sold_quantity FROM Orders WHERE ProductID = product_id AND YEAR(Date) = YearInput; 
SELECT BuyPrice INTO buy_price FROM Products WHERE ProductID = product_id; 
SELECT SellPrice INTO sell_price FROM Products WHERE ProductID = product_id;
SET profit = (sell_price * sold_quantity) - (buy_price * sold_quantity);
Select profit; 
END //
DELIMITER ;

-- Use the following code to call the procedure:
CALL GetProfit('P1', 2020);

-- Task 8 solution
CREATE VIEW DataSummary AS SELECT Clients.FullName, Clients.ContactNumber, Addresses.County, Products.ProductName, Orders.ProductID, Orders.Cost, Orders.Date 
FROM Clients INNER JOIN Addresses 
ON Clients.AddressID = Addresses.AddressID INNER JOIN Orders ON Clients.ClientID = Orders.ClientID INNER JOIN Products ON Orders.ProductID = Products.ProductID 
WHERE YEAR(Orders.Date) = 2022 
ORDER BY Orders.Cost DESC;

-- To see the View
SELECT * FROM DataSummary;