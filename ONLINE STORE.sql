
-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
USE OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(8, 2)
);
-- Import Data into Books Table via schema
-- Import Data into Customers Table via schema
-- Import Data into Orders Table via schema

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books 
WHERE Genre ='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books 
WHERE Published_Year > 1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(Stock) AS Total_stock FROM Books ;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books
WHERE Price = (SELECT MAX(Price) FROM Books);

SELECT * FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE Quantity >1;

-- 8) Retrieve all orders where the total amount exceeds $20:
Select * FROM Orders
WHERE Total_Amount > 20;

-- 9) List all genres available in the Books table:
  -- Solution 1
SELECT DISTINCT Genre FROM BOOKS;

  -- Solution 2
SELECT Genre FROM BOOKS
GROUP BY (genre);

-- 10) Find the book with the lowest stock:
SELECT * FROM BOOKS 
WHERE STOCK = (SELECT MIN(STOCK) FROM BOOKS);

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(TOTAL_AMOUNT) AS REVENUE FROM ORDERS;

 
-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT B.GENRE, SUM(O.QUANTITY) AS TOTAL_BOOKS_SOLD
FROM ORDERS O
JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY B.GENRE;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(PRICE) AS AVG_PRICE FROM BOOKS
WHERE GENRE ='FANTASY';

-- 3) List customers who have placed at least 2 orders:
SELECT CUSTOMER_ID, COUNT(ORDER_ID) AS ORDER_COUNT FROM ORDERS
GROUP BY CUSTOMER_ID 
HAVING COUNT(ORDER_ID) >= 2;

-- 4) Find the most frequently ordered book:
SELECT O.BOOK_ID, B.TITLE, COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM ORDERS O
JOIN BOOKS B ON O.BOOK_ID=B.BOOK_ID
GROUP BY O.BOOK_ID, B.TITLE
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM BOOKS
WHERE GENRE = 'FANTASY'
ORDER BY PRICE DESC 
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT B.AUTHOR , SUM(O.QUANTITY) AS SOLD_BOOKS
FROM ORDERS O JOIN BOOKS B
ON O.BOOK_ID = B.BOOK_ID
GROUP BY B.AUTHOR;   

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT C.CITY , TOTAL_AMOUNT
FROM ORDERS O 
JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE O.TOTAL_AMOUNT > 30;


-- 8) Find the customer who spent the most on orders:
SELECT C.CUSTOMER_ID, C.NAME, SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM ORDERS O JOIN CUSTOMERS C 
ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME
ORDER BY TOTAL_SPENT DESC LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders: 
SELECT B.BOOK_ID, B.TITLE, B.STOCK, COALESCE(SUM(O.QUANTITY),0) AS ORDER_QUANTITY,  
	B.STOCK- COALESCE(SUM(O.QUANTITY),0) AS REMAINING_QUANTITY
FROM BOOKS B
LEFT JOIN ORDERS O ON B.BOOK_ID=O.BOOK_ID
GROUP BY B.BOOK_ID ORDER BY B.BOOK_ID;