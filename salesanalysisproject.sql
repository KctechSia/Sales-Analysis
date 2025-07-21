CREATE DATABASE AxiaStores;

use AxiaStores;

CREATE TABLE  CustomerTB(
CustomerID INT,
FirstName VARCHAR(40),
LastName VARCHAR(40),
Email VARCHAR(40),
Phone VARCHAR(40),
City VARCHAR(40)
);

INSERT INTO CustomerTB(CustomerID, FirstName, LastName, Email, Phone, City)
VALUES
(1, "Musa", "Ahmed", "musa.ahmed@hotmail.com", "08031230001", "Lagos"),
(2, "Ray", "Samson", "ray.samson@yahoo.com", "08031230002", "Ibadan"),
(3, "Chinedu", "Okafor", "chinedu.ok@yahoo.com", "08031230003", "Enugu"),
(4, "Dare", "Adewale", "dare.ad@hotmail.com", "08031230004", "Abuja"),
(5, "Efe", "Ojo", "efe.oj@gmail.com", "08031230005", "Port Harcourt"),
(6, "Aisha", "Bello", "aisha.bello@hotmail.com", "08031230006", "Kano"),
(7, "Tunde", "Salami", "tunde.salami@yahoo.com", "08031230007", "Ilorin"),
(8, "Nneka", "Umeh", "nneka.umeh@gmail.com", "08031230008", "Owerri"),
(9, "Kelvin", "Peters", "kelvin.peters@hotmail.com", "08031230009", "Asaba"),
(10, "Blessing", "Mark", "blessing.mark@gmail.com", "08031230010", "Uyo");

CREATE TABLE  ProductTB(
ProductID INT,
ProductName VARCHAR(40),
Category VARCHAR(40),
UnitPrice DECIMAL,
StockQty INT
);

INSERT INTO ProductTB(ProductID, ProductName, Category, UnitPrice, StockQty)
VALUES
(1, "Wireless Mouse", "Accessories", 7500, 120),
(2, "USB-C Charger 65W", "Electronics", 14500, 75),
(3, "Noise-Cancel Headset", "Audio", 85500, 50),
(4, "27\4K Monitor", "Displays", 185000, 20),
(5, "Laptop Stand", "Accessories", 19500, 90),
(6, "Bluetooth Speaker", "Audio", 52000, 60);

INSERT INTO ProductTB(ProductID, ProductName, Category, UnitPrice, StockQty)
VALUES
(7, "Mechanical Keyboard", "Accessories", 18500, 40),
(8, "WebCam 1080p", "Electronics", 25000, 55),
(9, "Smartwatch Series 5", "Wearables", 320000, 30),
(10, "Portable SSD 1TB", "Storage", 125000, 35);

CREATE TABLE OrdersTB (
OrderID INT,
CustomerID INT,
ProductID INT,
OrderDate DATE,
Quantity INT
);

INSERT INTO OrdersTB (OrderID, CustomerID, ProductID, OrderDate, Quantity)
VALUES
(1001, 1, 3, '2025-06-01', 1),
(1002, 2, 1, '2025-06-03', 2),
(1003, 3, 5, '2025-06-05', 1),
(1004, 4, 4, '2025-06-10', 1),
(1005, 5, 2, '2025-06-12', 3),
(1006, 6, 7, '2025-06-15', 1),
(1007, 7, 6, '2025-06-18', 2),
(1008, 8, 8, '2025-06-20', 1),
(1009, 9, 9, '2025-06-22', 1),
(1010, 10, 10, '2025-06-25', 2);
-- Sales Revenue Breakdown by Product Category
SELECT c.firstname, c.email
FROM CustomerTB c
JOIN OrdersTB o ON c.customerid = o.customerid
JOIN ProductTB p ON o.productid = p.productid
WHERE p.productname = 'Wireless Mouse';

SELECT LastName, FirstName
FROM CustomerTB
ORDER BY LastName ASC;

-- The goal was to identify key customers and analyze sales performance by product to support targeted marketing efforts
SELECT 
    CONCAT(c.firstname, ' ', c.lastname) AS full_name,
    p.productname,
    o.quantity,
    p.unitprice AS unit_price,
    (o.quantity * p.unitprice) AS total_price,
    o.orderdate
FROM ordersTB o
JOIN customerTB c ON o.customerid = c.customerid
JOIN productTB p ON o.productid = p.productid
ORDER BY o.orderdate;

SELECT 
    p.category,
    AVG(o.quantity * p.unitprice) AS average_sales
FROM orderstb o
JOIN producttb p ON o.productid = p.productid
GROUP BY p.category
ORDER BY average_sales DESC;

SELECT 
    c.city,
    SUM(o.quantity * p.unitprice) AS total_revenue
FROM orderstb o
JOIN customertb c ON o.customerid = c.customerid
JOIN producttb p ON o.productid = p.productid
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 1;

-- which customer buys the most and how much they contribute to revenue
SELECT 
  c.customerid,
  CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
  p.productname,
  SUM(o.quantity) AS total_quantity,
  SUM(o.quantity * p.unitprice) AS total_spent
FROM ordersTB o
JOIN customerTB c ON o.customerid = c.customerid
JOIN productTB p ON o.productid = p.productid
GROUP BY c.customerid, customer_name, p.productname
ORDER BY total_spent DESC;

WITH ProductSales AS (
    SELECT 
        p.Productname,
        SUM(o.quantity * p.unitprice) AS total_revenue
    FROM ordersTB o
    JOIN productTB p ON o.productid = p.productid
    GROUP BY p.Productname)

SELECT *
FROM ProductSales
WHERE total_revenue > 1000;