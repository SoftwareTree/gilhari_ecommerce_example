-- ============================================================================
-- E-COMMERCE DATABASE SAMPLE DATA
-- Designed for Business Intelligence and Analytics
-- Demonstrates complex relationships and realistic business data
-- ============================================================================
-- NOTE: This script populates the database with sample data for testing
-- Run schema.sql first to create the tables
-- ============================================================================

-- Suppliers
INSERT INTO supplier (name, contactemail, country, rating) VALUES
('TechSupply Inc', 'contact@techsupply.com', 'USA', 4.8),
('Global Electronics', 'sales@globalelec.com', 'China', 4.5),
('Premium Goods Ltd', 'info@premiumgoods.co.uk', 'UK', 4.9),
('FastShip Distributors', 'orders@fastship.com', 'Germany', 4.3);

-- Products
INSERT INTO product (sku, name, description, category, price, stockquantity, supplierid) VALUES
('LAPTOP-001', 'UltraBook Pro 15', 'High-performance laptop', 'Electronics', 1299.99, 45, 1),
('PHONE-001', 'SmartPhone X', 'Latest smartphone model', 'Electronics', 899.99, 120, 2),
('HEADPHONE-001', 'Wireless Headphones Pro', 'Noise-cancelling headphones', 'Electronics', 299.99, 80, 1),
('WATCH-001', 'Fitness Tracker Pro', 'Advanced fitness tracking', 'Wearables', 199.99, 150, 3),
('TABLET-001', 'Tablet Ultra', '12-inch tablet', 'Electronics', 599.99, 60, 2),
('MOUSE-001', 'Ergonomic Wireless Mouse', 'Comfortable design', 'Accessories', 49.99, 200, 4),
('KEYBOARD-001', 'Mechanical Keyboard RGB', 'Gaming keyboard', 'Accessories', 129.99, 95, 4),
('MONITOR-001', '27-inch 4K Monitor', 'Professional display', 'Electronics', 449.99, 35, 1);

-- Customers
INSERT INTO customer (email, firstname, lastname, phonenumber, registrationdate, totalspent, tier) VALUES
('john.doe@example.com', 'John', 'Doe', '555-0101', '2023-06-15', 5499.95, 'Gold'),
('jane.smith@example.com', 'Jane', 'Smith', '555-0102', '2023-08-22', 12450.00, 'Platinum'),
('bob.johnson@example.com', 'Bob', 'Johnson', '555-0103', '2024-01-10', 899.99, 'Silver'),
('alice.williams@example.com', 'Alice', 'Williams', '555-0104', '2024-03-05', 3200.50, 'Gold'),
('charlie.brown@example.com', 'Charlie', 'Brown', '555-0105', '2024-07-18', 299.99, 'Bronze'),
('emma.davis@example.com', 'Emma', 'Davis', '555-0106', '2023-11-30', 7800.00, 'Gold'),
('david.miller@example.com', 'David', 'Miller', '555-0107', '2024-05-12', 1599.98, 'Silver');

-- Addresses
INSERT INTO address (customerid, addresstype, street, city, state, zipcode, country, isdefault) VALUES
(1, 'Shipping', '123 Main St', 'San Francisco', 'CA', '94102', 'USA', TRUE),
(2, 'Shipping', '456 Oak Ave', 'New York', 'NY', '10001', 'USA', TRUE),
(3, 'Shipping', '789 Pine Rd', 'Seattle', 'WA', '98101', 'USA', TRUE),
(4, 'Shipping', '321 Elm St', 'Boston', 'MA', '02101', 'USA', TRUE),
(5, 'Shipping', '654 Maple Dr', 'Chicago', 'IL', '60601', 'USA', TRUE),
(6, 'Shipping', '987 Cedar Ln', 'Los Angeles', 'CA', '90001', 'USA', TRUE),
(7, 'Shipping', '147 Birch Blvd', 'Austin', 'TX', '78701', 'USA', TRUE);

-- Orders
INSERT INTO customerorder (ordernumber, customerid, orderdate, status, totalamount, shippingaddressid) VALUES
('ORD-2025-0001', 1, '2025-09-01 10:30:00', 'Delivered', 1299.99, 1),
('ORD-2025-0002', 2, '2025-09-03 14:15:00', 'Delivered', 1499.97, 2),
('ORD-2025-0003', 1, '2025-09-10 09:20:00', 'Shipped', 449.99, 1),
('ORD-2025-0004', 3, '2025-09-12 16:45:00', 'Processing', 899.99, 3),
('ORD-2025-0005', 4, '2025-09-15 11:00:00', 'Delivered', 729.98, 4),
('ORD-2025-0006', 2, '2025-09-18 13:30:00', 'Shipped', 599.99, 2),
('ORD-2025-0007', 5, '2025-09-20 10:15:00', 'Pending', 299.99, 5),
('ORD-2025-0008', 6, '2025-09-22 15:20:00', 'Delivered', 1949.96, 6),
('ORD-2025-0009', 7, '2025-09-25 12:40:00', 'Processing', 1599.98, 7);

-- Order Items
INSERT INTO orderitem (orderid, productid, quantity, unitprice, discount, subtotal) VALUES
-- Order 1
(1, 1, 1, 1299.99, 0, 1299.99),
-- Order 2
(2, 3, 1, 299.99, 0, 299.99),
(2, 6, 2, 49.99, 0, 99.98),
(2, 7, 1, 129.99, 10, 116.99),
-- Order 3
(3, 8, 1, 449.99, 0, 449.99),
-- Order 4
(4, 2, 1, 899.99, 0, 899.99),
-- Order 5
(5, 4, 1, 199.99, 0, 199.99),
(5, 6, 1, 49.99, 0, 49.99),
(5, 5, 1, 599.99, 20, 479.99),
-- Order 6
(6, 5, 1, 599.99, 0, 599.99),
-- Order 7
(7, 3, 1, 299.99, 0, 299.99),
-- Order 8
(8, 1, 1, 1299.99, 0, 1299.99),
(8, 3, 1, 299.99, 0, 299.99),
(8, 7, 1, 129.99, 0, 129.99),
(8, 6, 2, 49.99, 10, 89.98),
-- Order 9
(9, 1, 1, 1299.99, 0, 1299.99),
(9, 3, 1, 299.99, 0, 299.99);
