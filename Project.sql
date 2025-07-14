-- Create Database
CREATE DATABASE OnlineBookstore;

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
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Program Files\PostgreSQL\17\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Program Files\PostgreSQL\17\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Program Files\PostgreSQL\17\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM BOOKS
WHERE genre='Fiction';


-- 2) Find books published after the year 1950:
SELECT * FROM BOOKS
WHERE Published_year>'1950';

-- 3) List all customers from the Canada:
SELECT * FROM Customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS total_stock 
FROM BOOKS;


-- 6) Find the details of the most expensive book:
SELECT * FROM BOOKS
ORDER BY price DESC 
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM orders 
WHERE Quantity > '1';

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders
WHERE Total_amount > 20 ;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM books;

-- 10) Find the book with the lowest stock:
SELECT * FROM books 
ORDER BY stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS revenue 
FROM orders;
-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre, SUM(o.quantity) AS total_book_sold
FROM Orders o
Join books b ON o.book_id = b.book_id
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS avg_price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.order_id) AS Orders_COUNT
FROM Orders o
JOIN Customers c ON c.customer_id= o.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >=2;

SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 2;


-- 4) Find the most frequently ordered book:
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT b.book_id, b.title, COUNT(o.Order_id) AS most_frequently_ordered_book
FROM orders o
JOIN books b ON b.book_id= o.book_id
GROUP BY b.book_id, b.Title
ORDER BY most_frequently_ordered_book DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE Genre ='Fantasy'
ORDER BY Price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS total_book_sold
FROM Orders o
Join books b ON o.book_id = b.book_id
GROUP BY b.author
ORDER BY SUM(o.quantity) DESC;

-- 7) List the cities where customers who spent over $30 are located:
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT DISTINCT(c.city), o.total_amount
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE O.total_amount > 30;
-- 8) Find the customer who spent the most on orders:
SELECT c.name, c.customer_id, SUM(o.total_amount)
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.name, c.customer_id
ORDER BY SUM(o.total_amount) DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
	b.stock-COALESCE(SUM(o.quantity),0) AS Stock_remaining
FROM books b
LEFT JOIN orders o ON o.book_id = b.book_id
GROUP BY b.book_id
ORDER BY b.book_id;





