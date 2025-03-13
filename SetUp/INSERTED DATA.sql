-- Insert data into PERSONS table first
DBCC CHECKIDENT ('PERSONS', RESEED, 0);
INSERT INTO PERSONS (first_name, last_name, email, phone_number, password_hash, profile_img, person_type, created_at, updated_at, creation_by, update_by)
VALUES 
('John', 'Doe', 'john.doe@example.com', '0712345678', HASHBYTES('SHA2_256', 'password123'), 'https://example.com/profiles/john.jpg', 'Customer', GETDATE(), GETDATE(), 'System', 'System'),
('Jane', 'Smith', 'jane.smith@example.com', '0723456789', HASHBYTES('SHA2_256', 'password456'), 'https://example.com/profiles/jane.jpg', 'Customer', GETDATE(), GETDATE(), 'System', 'System'),
('Michael', 'Johnson', 'michael.johnson@example.com', '0734567890', HASHBYTES('SHA2_256', 'password789'), 'https://example.com/profiles/michael.jpg', 'Customer', GETDATE(), GETDATE(), 'System', 'System'),
('Sarah', 'Williams', 'sarah.williams@example.com', '0745678901', HASHBYTES('SHA2_256', 'passwordabc'), 'https://example.com/profiles/sarah.jpg', 'Admin', GETDATE(), GETDATE(), 'System', 'System'),
('David', 'Brown', 'david.brown@example.com', '0756789012', HASHBYTES('SHA2_256', 'passworddef'), 'https://example.com/profiles/david.jpg', 'Admin', GETDATE(), GETDATE(), 'System', 'System'),
('Emily', 'Davis', 'emily.davis@example.com', '0767890123', HASHBYTES('SHA2_256', 'passwordghi'), 'https://example.com/profiles/emily.jpg', 'Customer', GETDATE(), GETDATE(), 'System', 'System'),
('Robert', 'Miller', 'robert.miller@example.com', '0778901234', HASHBYTES('SHA2_256', 'passwordjkl'), 'https://example.com/profiles/robert.jpg', 'Customer', GETDATE(), GETDATE(), 'System', 'System'),
('Laura', 'Wilson', 'laura.wilson@example.com', '0789012345', HASHBYTES('SHA2_256', 'passwordmno'), 'https://example.com/profiles/laura.jpg', 'Customer', GETDATE(), GETDATE(), 'System', 'System');

-- Insert data into CUSTOMERS table
DBCC CHECKIDENT ('CUSTOMERS', RESEED, 0);
INSERT INTO CUSTOMERS (FK_customer_person_id, rewards_points, last_login, [status])
VALUES 
(1, 150, GETDATE(), 'Active'),
(2, 75, GETDATE(), 'Active'),
(3, 200, DATEADD(DAY, -1, GETDATE()), 'Active'),
(6, 50, DATEADD(DAY, -2, GETDATE()), 'Inactive'),
(7, 100, DATEADD(DAY, -3, GETDATE()), 'Active'),
(8, 25, DATEADD(DAY, -1, GETDATE()), 'Active'); -- Added Laura Wilson as customer for consistency

-- Insert data into ADMINS table
DBCC CHECKIDENT ('ADMINS', RESEED, 0);
INSERT INTO ADMINS (FK_admin_person_id, last_login)
VALUES 
(4, GETDATE()),
(5, DATEADD(DAY, -1, GETDATE()));

-- Insert data into ADDRESSES table
DBCC CHECKIDENT ('ADDRESSES', RESEED, 0);
INSERT INTO ADDRESSES (FK_address_customer_id, address_line1, address_line2, city, postal_code, country, created_at, updated_at, created_by, updated_by)
VALUES 
-- Assuming customer_id is the actual ID from CUSTOMERS table, not the person_id
(1, '123 Main St', 'Apt 4B', 'London', 'SW1A 1AA', 'United Kingdom', GETDATE(), GETDATE(), 'System', 'System'),
(2, '456 Oak Ave', NULL, 'Manchester', 'M1 1AA', 'United Kingdom', GETDATE(), GETDATE(), 'System', 'System'),
(3, '789 Pine Rd', 'Suite 101', 'Liverpool', 'L1 1AA', 'United Kingdom', GETDATE(), GETDATE(), 'System', 'System'),
(4, '101 Cedar Ln', NULL, 'Birmingham', 'B1 1AA', 'United Kingdom', GETDATE(), GETDATE(), 'System', 'System'),
(5, '202 Maple Dr', 'Flat 3', 'Glasgow', 'G1 1AA', 'United Kingdom', GETDATE(), GETDATE(), 'System', 'System'),
(6, '303 Elm St', NULL, 'Edinburgh', 'EH1 1AA', 'United Kingdom', GETDATE(), GETDATE(), 'System', 'System');

-- Insert data into CATEGORIES_LOOKUP table
DBCC CHECKIDENT ('CATEGORIES_LOOKUP', RESEED, 0);
INSERT INTO CATEGORIES_LOOKUP (category_name)
VALUES 
('Skincare'),
('Haircare'),
('Makeup'),
('Fragrances'),
('Bath & Body');
-- Insert data into BRANDS_LOOKUP table
DBCC CHECKIDENT ('BRANDS_LOOKUP', RESEED, 0);
INSERT INTO BRANDS_LOOKUP (brand_name, origin_country)
VALUES 
('Nivea', 'Germany'),
('LOr�al', 'France'),
('Dove', 'United Kingdom'),
('Olay', 'United States'),
('Neutrogena', 'United States');

-- Insert data into PRODUCTS table
DBCC CHECKIDENT ('PRODUCTS', RESEED, 0);
INSERT INTO PRODUCTS (serial_number, [name], [description], base_price, selling_price, FK_brand_id, FK_category_id, [weight], expiry_date, created_at, updated_at, created_by, updated_by, discount_amount)
VALUES 
('SN-001-2023', 'Hydrating Face Cream', 'Rich moisturizing cream for dry skin with vitamin E and aloe vera', 15.99, 19.99, 1, 1, 150.0, DATEADD(YEAR, 2, GETDATE()), GETDATE(), GETDATE(), 'System', 'System', 0.25),
('SN-002-2023', 'Volumizing Shampoo', 'Adds volume and bounce to thin hair with keratin complex', 12.50, 17.50, 2, 2, 350.0, DATEADD(YEAR, 3, GETDATE()), GETDATE(), GETDATE(), 'System', 'System', 0.1),
('SN-003-2023', 'Long-lasting Lipstick', 'Vibrant color that lasts up to 24 hours with moisturizing ingredients', 8.99, 14.99, 2, 3, 15.0, DATEADD(YEAR, 2, GETDATE()), GETDATE(), GETDATE(), 'System', 'System', 0.05),
('SN-004-2023', 'Fresh Ocean Cologne', 'Refreshing scent with notes of citrus and sea breeze', 35.00, 49.99, 3, 4, 100.0, DATEADD(YEAR, 4, GETDATE()), GETDATE(), GETDATE(), 'System', 'System'),
('SN-005-2023', 'Exfoliating Body Scrub', 'Gentle exfoliation with natural sea salt and essential oils', 9.99, 14.99, 5, 5, 250.0, DATEADD(YEAR, 2, GETDATE()), GETDATE(), GETDATE(), 'System', 'System');


-- Insert data into SHOPPING_CARTS table
-- Fixed to reference valid customer IDs
DBCC CHECKIDENT ('SHOPPING_CARTS', RESEED, 0);
INSERT INTO SHOPPING_CARTS (FK_customer_id, created_at, updated_at)
VALUES 
(1, GETDATE(), GETDATE()),
(2, GETDATE(), GETDATE()),
(3, GETDATE(), GETDATE()),
(4, GETDATE(), GETDATE()),
(5, GETDATE(), GETDATE()),
(6, GETDATE(), GETDATE());

-- Insert data into CART_ITEMS table
-- Fixed to reference valid cart IDs

INSERT INTO CART_ITEMS (FK_cart_id, FK_product_id, quantity, created_at, updated_at, created_by, updated_by)
VALUES 
(1, 1, 2, GETDATE(), GETDATE(), 'System', 'System'),
(2, 3, 1, GETDATE(), GETDATE(), 'System', 'System'),
(3, 2, 1, GETDATE(), GETDATE(), 'System', 'System'),
(4, 5, 3, GETDATE(), GETDATE(), 'System', 'System'),
(5, 4, 1, GETDATE(), GETDATE(), 'System', 'System'),
(6, 1, 1, GETDATE(), GETDATE(), 'System', 'System');

-- Insert data into WISHLISTS table
-- Fixed to reference valid customer IDs
DBCC CHECKIDENT ('WISHLISTS', RESEED, 0);

INSERT INTO WISHLISTS (FK_customer_id, created_at, updated_at, created_by, updated_by)
VALUES 
(1, GETDATE(), GETDATE(), 'System', 'System'),
(2, GETDATE(), GETDATE(), 'System', 'System'),
(3, GETDATE(), GETDATE(), 'System', 'System'),
(4, GETDATE(), GETDATE(), 'System', 'System'),
(5, GETDATE(), GETDATE(), 'System', 'System'),
(6, GETDATE(), GETDATE(), 'System', 'System');

-- Insert data into WISHLIST_ITEMS table
-- Fixed to reference valid wishlist IDs
INSERT INTO WISHLIST_ITEMS (FK_wishlist_id, FK_product_id, created_at, updated_at, created_by, updated_by)
VALUES 
(1, 4, GETDATE(), GETDATE(), 'System', 'System'),
(2, 5, GETDATE(), GETDATE(), 'System', 'System'),
(3, 1, GETDATE(), GETDATE(), 'System', 'System'),
(4, 2, GETDATE(), GETDATE(), 'System', 'System'),
(5, 3, GETDATE(), GETDATE(), 'System', 'System'),
(6, 5, GETDATE(), GETDATE(), 'System', 'System');

-- Insert data into ORDERS table
-- Fixed to reference valid customer IDs 
DBCC CHECKIDENT ('ORDERS', RESEED, 0);
INSERT INTO ORDERS (FK_order_customer_id, subtotal, tax, shipping_cost, [status], created_at, updated_at, created_by, updated_by)
VALUES 
(1, 54.97, 11.00, 5.99, 'Delivered', DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -9, GETDATE()), 'System', 'System'),
(2, 17.50, 3.50, 4.99, 'Shipped', DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -4, GETDATE()), 'System', 'System'),
(3, 44.97, 9.00, 5.99, 'Processing', DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -2, GETDATE()), 'System', 'System'),
(4, 49.99, 10.00, 0.00, 'Pending', GETDATE(), GETDATE(), 'System', 'System'),
(5, 34.98, 7.00, 5.99, 'Delivered', DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, -19, GETDATE()), 'System', 'System');

-- Insert data into ORDER_ITEMS table
-- Fixed to reference valid order IDs
INSERT INTO ORDER_ITEMS (FK_order_id, FK_product_id, quantity, unit_price, created_at, updated_at, created_by, updated_by)
VALUES 
(1, 1, 1, 19.99, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -10, GETDATE()), 'System', 'System'),
(1, 3, 1, 14.99, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -10, GETDATE()), 'System', 'System'),
(2, 5, 1, 14.99, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -10, GETDATE()), 'System', 'System'),
(3, 2, 1, 17.50, DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -5, GETDATE()), 'System', 'System'),
(4, 5, 3, 14.99, DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -2, GETDATE()), 'System', 'System');

-- Insert data into PAYMENT_TRANSACTIONS table
-- Fixed to ensure one payment per order and correct payment amounts
DBCC CHECKIDENT ('PAYMENT_TRANSACTIONS', RESEED, 0);

INSERT INTO PAYMENT_TRANSACTIONS (FK_transaction_order_id, payment_method, amount, discount_amount, payment_status, transaction_reference, transaction_date, created_at, updated_at, created_by, updated_by)
VALUES 
(1, 'Credit Card', 71.96, 0.00, 'Paid', 'TRX-001-2023', DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -10, GETDATE()), 'System', 'System'),
(2, 'PayPal', 25.99, 0.00, 'Paid', 'TRX-002-2023', DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -5, GETDATE()), 'System', 'System'),
(3, 'Credit Card', 59.96, 0.00, 'Paid', 'TRX-003-2023', DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -2, GETDATE()), 'System', 'System'),
(4, 'Debit Card', 59.99, 0.00, 'Unpaid', 'TRX-004-2023', GETDATE(), GETDATE(), GETDATE(), 'System', 'System'),
(5, 'PayPal', 47.97, 0.00, 'Refunded', 'TRX-005-2023', DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, -18, GETDATE()), 'System', 'System');

-- Insert data into SHIPPING_DETAILS table
-- Fixed column spelling error (tracking_number instead of traching_number) and aligned order IDs
DBCC CHECKIDENT ('SHIPPING_DETAILS', RESEED, 0);

INSERT INTO SHIPPING_DETAILS (FK_shipping_order_id, tracking_number, estimated_delivery, shipped_date)
VALUES 
(1, 'TRACK-001-2023', DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -8, GETDATE())),
(2, 'TRACK-002-2023', DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -4, GETDATE())),
(3, 'TRACK-003-2023', DATEADD(DAY, 2, GETDATE()), DATEADD(DAY, -1, GETDATE())),
(4, 'TRACK-004-2023', DATEADD(DAY, 4, GETDATE()), DATEADD(DAY, 1, GETDATE())),
(5, 'TRACK-005-2023', DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, -18, GETDATE()));

-- Insert data into RATES table
-- Fixed to reference valid order IDs
DBCC CHECKIDENT ('RATES', RESEED, 0);

INSERT INTO RATES (FK_order_id, rate_amount, rate_message, created_at, updated_at, created_by, updated_by)
VALUES 
(1, 4.5, 'Great products and fast delivery!', DATEADD(DAY, -3, GETDATE()), DATEADD(DAY, -3, GETDATE()), 'Customer', 'System'),
(2, 3.5, 'Good product but packaging could be better.', DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, -1, GETDATE()), 'Customer', 'System'),
(3, 4.0, 'Satisfied with the purchase.', DATEADD(DAY, 1, GETDATE()), DATEADD(DAY, 1, GETDATE()), 'Customer', 'System'),
(4, 5.0, 'Excellent service and product quality!', DATEADD(DAY, 2, GETDATE()), DATEADD(DAY, 2, GETDATE()), 'Customer', 'System'),
(5, 2.0, 'Product did not meet expectations.', DATEADD(DAY, -17, GETDATE()), DATEADD(DAY, -17, GETDATE()), 'Customer', 'System');

DBCC CHECKIDENT ('PRODUCT_IMAGES', RESEED, 0);
INSERT INTO PRODUCT_IMAGES
           ([FK_product_id], [url_link], [is_active], [created_at], [updated_at], [created_by], [updated_by])
     VALUES
           (1, 'https://example.com/images/product1.jpg', 1, GETDATE(), GETDATE(), 'Admin', 'Admin'),
           (2, 'https://example.com/images/product2.jpg', 1, GETDATE(), GETDATE(), 'Admin', 'Admin'),
           (3, 'https://example.com/images/product3.jpg', 0, GETDATE(), GETDATE(), 'Admin', 'Admin'),
           (4, 'https://example.com/images/product4.jpg', 1, GETDATE(), GETDATE(), 'System', 'System'),
           (5, 'https://example.com/images/product5.jpg', 1, GETDATE(), GETDATE(), 'DataImport', 'DataImport')

--insert data into inventory table
 INSERT INTO INVENTORY (FK_product_id, quantity_available, warehouse_location, batch_number, is_active, created_at, updated_at, created_by, updated_by)
VALUES 
(1, 100, 'Warehouse A', 'BATCH-001-2023', 1, GETDATE(), GETDATE(), 'System', 'System'),
(2, 150, 'Warehouse B', 'BATCH-002-2023', 1, GETDATE(), GETDATE(), 'System', 'System'),
(3, 200, 'Warehouse A', 'BATCH-003-2023', 1, GETDATE(), GETDATE(), 'System', 'System'),
(4, 50, 'Warehouse C', 'BATCH-004-2023', 1, GETDATE(), GETDATE(), 'System', 'System'),
(5, 300, 'Warehouse A', 'BATCH-005-2023', 1, GETDATE(), GETDATE(), 'System', 'System')

--insert data into PRODUCT_REQUESTS table
INSERT INTO PRODUCT_REQUESTS (FK_customer_id, product_name, quantity_requested, status, is_active, created_at, updated_at, creation_by, update_by)
VALUES 
(1, 'Moisturizing Cream', 2, 'Pending', 1, GETDATE(), GETDATE(), 'User1', 'User1'),
(2, 'Lipstick Red Shade', 3, 'Pending', 1, GETDATE(), GETDATE(), 'User2', 'User2'),
(3, 'Sunscreen SPF 50', 1, 'Pending', 1, GETDATE(), GETDATE(), 'User3', 'User3'),
(4, 'Hair Serum', 4, 'Pending', 1, GETDATE(), GETDATE(), 'User4', 'User4'),
(5, 'Perfume Rose Scent', 2, 'Pending', 1, GETDATE(), GETDATE(), 'User5', 'User5');

