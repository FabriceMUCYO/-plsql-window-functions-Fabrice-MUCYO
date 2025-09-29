-- Insert into customers
INSERT INTO customers VALUES (1, 'Alice Uwase', 'Kigali');
INSERT INTO customers VALUES (2, 'Bob Mugisha', 'Kigali');
INSERT INTO customers VALUES (3, 'Claire Iradukunda', 'Northern');
INSERT INTO customers VALUES (4, 'David Habimana', 'Southern');
INSERT INTO customers VALUES (5, 'Emma Uwimana', 'Eastern');

-- Insert into products
INSERT INTO products VALUES (101, 'Samsung Galaxy S23', 'Smartphones');
INSERT INTO products VALUES (102, 'iPhone 14', 'Smartphones');
INSERT INTO products VALUES (103, 'Dell Laptop', 'Computers');
INSERT INTO products VALUES (104, 'HP Printer', 'Accessories');
INSERT INTO products VALUES (105, 'AirPods Pro', 'Audio');
INSERT INTO products VALUES (106, 'Samsung Tablet', 'Tablets');
INSERT INTO products VALUES (107, 'MacBook Air', 'Computers');
INSERT INTO products VALUES (108, 'Wireless Mouse', 'Accessories');

-- Insert into transactions
-- January 2024 transactions
INSERT INTO transactions VALUES (1, 1, 101, DATE '2024-01-10', 850000);
INSERT INTO transactions VALUES (2, 2, 102, DATE '2024-01-15', 950000);
INSERT INTO transactions VALUES (3, 3, 103, DATE '2024-01-20', 1200000);
INSERT INTO transactions VALUES (4, 1, 105, DATE '2024-01-25', 500000);

-- February 2024 transactions
INSERT INTO transactions VALUES (5, 2, 104, DATE '2024-02-05', 350000);
INSERT INTO transactions VALUES (6, 4, 106, DATE '2024-02-10', 600000);
INSERT INTO transactions VALUES (7, 3, 107, DATE '2024-02-15', 1500000);
INSERT INTO transactions VALUES (8, 5, 101, DATE '2024-02-20', 850000);

-- March 2024 transactions
INSERT INTO transactions VALUES (9, 1, 108, DATE '2024-03-05', 150000);
INSERT INTO transactions VALUES (10, 2, 103, DATE '2024-03-10', 1200000);
INSERT INTO transactions VALUES (11, 4, 102, DATE '2024-03-15', 950000);
INSERT INTO transactions VALUES (12, 5, 105, DATE '2024-03-20', 250000);

COMMIT;
