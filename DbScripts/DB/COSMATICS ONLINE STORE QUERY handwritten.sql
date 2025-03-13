--PERSONS TABLE:
CREATE TABLE PERSONS(
person_id int identity(1,1) primary Key,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(225) not null,
phone_number varchar(10) not null,
password_hash varchar(225) not null,
profile_img varchar(max),
person_type varchar(10) not null,
is_active bit default(1),
created_at datetime,
updated_at datetime,
creation_by varchar(max),
update_by varchar(max)
)
--I forgot to add the unique constraint on create
ALTER TABLE PERSONS ADD CONSTRAINT UQ_email UNIQUE (email);
ALTER TABLE PERSONS ADD CONSTRAINT UQ_phone_number UNIQUE (phone_number);

--check email, phone_number
ALTER TABLE PERSONS
ADD CONSTRAINT CHK_SALARY CHECK(Email LIKE '%_@_%._%')
ALTER TABLE PERSONS
ADD CONSTRAINT CHK_PHONE_NUMBER CHECK(phone_number LIKE '07%' AND LEN(phone_number) = 10)

--CUSTOMERS TABLE:
CREATE TABLE CUSTOMERS(
customer_id int identity(1,1) primary key,
FK_customer_person_id int unique not null,
rewards_points int not null, 
last_login datetime not null,
[status] varchar(20)
)
--add Fk, Cascade, default
ALTER TABLE CUSTOMERS
ADD 
CONSTRAINT FK_customer_person_id
FOREIGN KEY (FK_customer_person_id)
REFERENCES PERSONS(person_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT DEFAULT_REWARDS_POINTS DEFAULT(0) FOR rewards_points
--trigger to check only customers are added to this table
CREATE TRIGGER TRG_CheckPersonTypeOnCustomerInsert
on CUSTOMERS
AFTER INSERT
AS 
BEGIN
	IF EXISTS(
	SELECT 1 
	FROM PERSONS
	JOIN inserted i ON PERSONS.person_id = i.FK_customer_person_id
	WHERE PERSONS.person_type != 'Customer'
	)
	BEGIN
		RAISERROR ('ONLY PERSONS WITH person_type OF "Customer" CAN BE INSERTED INTO THE CUSTOMERS TABLE.', 16,1)
		ROLLBACK TRANSACTION
	END
END

--ADMINS TABLE
CREATE TABLE ADMINS(
admin_id int identity(1,1) primary key,
FK_admin_person_id int unique not null,
last_login datetime not null
)
--add FK, default
ALTER TABLE ADMINS
ADD CONSTRAINT FK_admin_person_id 
FOREIGN KEY (FK_admin_person_id)
REFERENCES PERSONS(person_id)
ON DELETE CASCADE
ON UPDATE CASCADE, 
CONSTRAINT DEFAULT_LAST_LOGIN DEFAULT GETDATE()
FOR last_login
--TRG FOR CHCECKING PERSON TYPE =ADMIN
CREATE TRIGGER TRG_CheckPersonTypeOnAdminInsert
on ADMINS
AFTER INSERT
AS 
BEGIN
	IF EXISTS(
	SELECT 1 
	FROM PERSONS
	JOIN inserted i ON PERSONS.person_id = i.FK_admin_person_id
	WHERE PERSONS.person_type != 'Admin'
	)
	BEGIN
		RAISERROR ('ONLY PERSONS WITH person_type OF "Admin" CAN BE INSERTED INTO THE ADMINS TABLE.', 16,1)
		ROLLBACK TRANSACTION
	END
END

--ADDRESSES TABLE:
CREATE TABLE ADDRESSES(
address_id int identity(1,1) primary key,
FK_address_customer_id int unique not null,
address_line1 varchar(max) not null,
address_line2 varchar(max),
city varchar(100) not null,
postal_code varchar(max) not null,
country varchar(max) not null,
created_at datetime,
updated_at datetime,
created_by varchar(max),
updated_by varchar(max)
)
--constraint
ALTER TABLE ADDRESSES
ADD CONSTRAINT FK_ADDRESSES_CUSTOMER_ID
FOREIGN KEY (FK_address_customer_id)
REFERENCES PERSONS(person_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT DEFAULT_ADDRESS_LINE2 DEFAULT NULL FOR address_line2

--ORDERS TABLE
CREATE TABLE ORDERS(
order_id int identity (1,1) primary key,
FK_order_customer_id int NOT NULL, 
subtotal float not null,
tax float not null, 
shipping_cost float not null,
[status] varchar(50) not null,
payment_status varchar(50),
is_active bit,
created_at datetime,
updated_at datetime,
created_by varchar(max),
updated_by varchar(max)
)
--constraints:
ALTER TABLE ORDERS
ADD CONSTRAINT FK_ORDER_CUSTOMER_ID
FOREIGN KEY (FK_order_customer_id)
REFERENCES CUSTOMERS(customer_id) 
ON DELETE CASCADE
ON UPDATE CASCADE, 
CONSTRAINT DEFAULT_IS_ACTIVE DEFAULT 1 FOR is_active,
CONSTRAINT DEFAULT_SUBTOTAL DEFAULT 0.0 FOR subtotal,
CONSTRAINT DEFAULT_TAX DEFAULT 0.00 FOR tax,
CONSTRAINT DEFAULT_SHIPPING_COST DEFAULT 0.0 FOR shipping_cost,
CONSTRAINT CHK_PAYMENT_STATUS CHECK(payment_status IN ('Paid','Unpaid','Refunded')),
CONSTRAINT CHK_STATUS CHECK([status] IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
ALTER TABLE ORDERS
ADD CONSTRAINT DEFAULT_CREATED_AT DEFAULT GETDATE() FOR created_at,
constraint DEFAULTUPDATED_AT DEFAULT GETDATE() FOR updated_at
Alter table orders
drop column payment_status
Alter table orders
drop constraint CHK_PAYMENT_STATUS
--PAYMENT_TRANSACTIONS TABLE
CREATE TABLE PAYMENT_TRANSACTIONS(
transaction_id int identity(1,1) primary key,
FK_transaction_order_id int not null,
payment_method varchar(30) not null,
amount float not null default 0.0,
payment_status varchar(50) not null,
transaction_reference varchar(225) UNIQUE not null,
transaction_date datetime not null,
is_active bit,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
--CONSTRAINTS:
ALTER TABLE PAYMENT_TRANSACTIONS
ADD CONSTRAINT CHK_PAYMENT_STATUS CHECK(payment_status IN ('Paid','Unpaid','Refunded')),
CONSTRAINT FK_TRANSACTION_ORDER_ID 
FOREIGN KEY(FK_transaction_order_id)
REFERENCES ORDERS(order_id)
ON DELETE CASCADE 
ON UPDATE CASCADE

ALTER TABLE PAYMENT_TRANSACTIONS
DROP CONSTRAINT FK_TRANSACTION_ORDER_ID

--SHIPPING_DETAILS TABLE:
CREATE TABLE SHIPPING_DETAILS(
shipping_id int identity(1,1) primary key, 
FK_shipping_order_id int not null,
tracking_number varchar(20) unique not null,
estimated_delivery datetime not null default GETDATE(),
shipped_date datetime not null DEFAULT GETDATE()
)
--CONSTRAINTS
ALTER TABLE SHIPPING_DETAILS
ADD CONSTRAINT FK_SHIPPING_ORDER_ID
FOREIGN KEY (FK_shipping_order_id)
REFERENCES ORDERS(order_id)
ON UPDATE CASCADE
ON DELETE CASCADE

--SHOPPING_CARTS
CREATE TABLE SHOPPING_CARTS(
cart_id int identity(1,1) primary key,
FK_customer_id int unique not null,
created_at datetime default GETDATE(),
updated_at datetime default GETDATE()
)
--CONSTRAINTS:
ALTER TABLE SHOPPING_CARTS
ADD CONSTRAINT FK_CUSTOMER_ID 
FOREIGN KEY (FK_customer_id)
REFERENCES CUSTOMERS(customer_id)
ON UPDATE CASCADE
ON DELETE CASCADE

--WISHLISTS TABLE:
CREATE TABLE WISHLISTS(
wishlist_id int identity(1,1) primary key,
FK_customer_id int unique not null,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE WISHLISTS
ADD CONSTRAINT FK_WISHLIST_CUSTOMER_ID
FOREIGN KEY (FK_customer_id)
REFERENCES CUSTOMERS(customer_id)
ON UPDATE CASCADE
ON DELETE CASCADE

--PRODUCTS TABLE:
CREATE TABLE PRODUCTS(
product_id int identity(1,1) primary key,
serial_number varchar(225) unique not null,
[name] varchar(200) not null,
[description] varchar(500) not null,
base_price float default 0.0 not null,
selling_price float default 0.0 not null,
FK_brand_id int not null,
FK_category_id int not null, 
[weight] float not null,
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE PRODUCTS
ADD CONSTRAINT FK_PRODUCT_BRAND_ID
FOREIGN KEY (FK_brand_id)
REFERENCES BRANDS_LOOKUP(brand_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT FK_PRODUCT_CATEGORY_ID
FOREIGN KEY (FK_category_id)
REFERENCES CATEGORIES_LOOKUP(category_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT CHK_PRICES CHECK(base_price>0 AND selling_price>0)

alter table products
add expiry_date date not null 
--CATEGORIES_LOOKUP TABLE
CREATE TABLE CATEGORIES_LOOKUP(
category_id int identity(1,1) primary key,
category_name varchar(200) not null
)
--BRANDS_LOOKUP
CREATE TABLE BRANDS_LOOKUP(
brand_id int identity(1,1) primary key,
brand_name varchar(200) not null,
origin_country varchar(50) not null
)

--RATES TABLE
CREATE TABLE RATES(
rate_id int identity(1,1) primary key,
FK_order_id int unique not null,
rate_amount float not null,
rate_message varchar(500) ,
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE RATES
ADD CONSTRAINT FK_RATE_ORDER_ID
FOREIGN KEY (FK_order_id)
REFERENCES ORDERS (order_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
CONSTRAINT CHK_RATE_AMOUNT CHECK(rate_amount<=5 AND rate_amount>=0)

--WISHLIST_ITEMS TABLE:
CREATE TABLE WISHLIST_ITEMS(
FK_wishlist_id int not null,
FK_product_id int not null,
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE WISHLIST_ITEMS
ADD CONSTRAINT FK_WISHLIST_ID_WISHIST_ITEMS
FOREIGN KEY (FK_wishlist_id)
REFERENCES WISHLISTS(wishlist_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT FK_PRODUCT_ID_WISHLIST_ITEMS
FOREIGN KEY (FK_product_id)
REFERENCES PRODUCTS(product_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT COMPOSIT_KEY_ORDER_ITEMS 
PRIMARY KEY(FK_order_id, FK_product_id)
,CONSTRAINT COMPOSIT_KEY_WISHLIST_ITEMS 
PRIMARY KEY(FK_wishlist_id, FK_product_id)

--CART_ITEMS
CREATE TABLE CART_ITEMS(
FK_cart_id int not null,
FK_product_id int not null,
quantity int default 0 not null,
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE CART_ITEMS
ADD CONSTRAINT FK_CART_ID_CART_ITEMS
FOREIGN KEY (FK_cart_id)
REFERENCES SHOPPING_CARTS(cart_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT FK_PRODUCT_ID_CART_ITEMS
FOREIGN KEY (FK_product_id)
REFERENCES PRODUCTS(product_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT COMPOSIT_KEY_CART_ITEMS 
PRIMARY KEY(FK_cart_id, FK_product_id),
CONSTRAINT CHK_QUANTITY CHECK(quantity >=0)

--ORDER_ITEMS TABLE:
CREATE TABLE ORDER_ITEMS(
FK_order_id int not null,
FK_product_id int not null,
quantity int default 0 not null,
unit_price float default 0.0 not null,
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE ORDER_ITEMS
ADD CONSTRAINT FK_ORDER_ID_ORDER_ITEMS
FOREIGN KEY (FK_order_id)
REFERENCES ORDERS(order_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT FK_PRODUCT_ID_ORDER_ITEMS
FOREIGN KEY (FK_product_id)
REFERENCES PRODUCTS(product_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
CONSTRAINT COMPOSIT_KEY_ORDER_ITEMS 
PRIMARY KEY(FK_order_id, FK_product_id),
CONSTRAINT CHK_QUANITITY CHECK(quantity>=0),
CONSTRAINT CHK_UNIT_PRICE CHECK(unit_price>=0)

 --INVENTORY TABLE
 CREATE TABLE INVENTORY(
inventory_id int identity(1,1) primary key,
FK_product_id int unique not null,
quantity_available int default 0 not null,
warehouse_location varchar(max) not null,
batch_number varchar(max) NOT NULL,
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE INVENTORY
ADD CONSTRAINT FK_INVENTORY_PRODUCT_ID
FOREIGN KEY(FK_product_id)
REFERENCES PRODUCTS(product_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
CONSTRAINT CHK_QUANITITY_AVAILABLE CHECK(quantity_available>=0)
 
--PRODUCT_IMAGES
CREATE TABLE PRODUCT_IMAGES(
image_id int identity(1,1) primary key,
FK_product_id int not null,
url_link varchar(max) not null,
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE PRODUCT_IMAGES
ADD CONSTRAINT FK_PRODUCT_IMAGE_PRODUCT_ID
FOREIGN KEY(FK_product_id)
REFERENCES PRODUCTS(product_id)
ON UPDATE CASCADE
ON DELETE CASCADE

--INGREDIENTS TABLE:
CREATE TABLE INGREDIENTS(
ingredient_id int identity(1,1) primary key,
name varchar(200) not null,
[description] varchar(500) not null,
safety_info varchar(max),
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE INGREDIENTS
ADD CONSTRAINT CHK_DESCRIPTION_MIN_LENGTH CHECK (LEN(description) >= 10)

--PRODUCT_INGREDIENTS JUNCTION TABLE:
CREATE TABLE PRODUCT_INGREDIENTS(
FK_product_id int not null,
FK_ingredient_id int not null, 
is_active bit default 1,
created_at datetime DEFAULT GETDATE(),
updated_at datetime DEFAULT GETDATE(),
created_by varchar(max),
updated_by varchar(max)
)
ALTER TABLE PRODUCT_INGREDIENTS
ADD CONSTRAINT FK_PRODUCT_ID
FOREIGN KEY(FK_product_id)
REFERENCES PRODUCTS(product_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
CONSTRAINT FK_INGREDIENT_ID
FOREIGN KEY(FK_ingredient_id)
REFERENCES INGREDIENTS(ingredient_id)
ON UPDATE CASCADE
ON DELETE CASCADE,
CONSTRAINT COMPOSITE_KEY_PRODUCT_INGREDIENTS 
PRIMARY KEY(FK_ingredient_id, FK_product_id)

--add PRODUCT_REQUESTS table
CREATE TABLE PRODUCT_REQUESTS (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    FK_customer_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    quantity_requested INT NOT NULL,
    [status] VARCHAR(10) DEFAULT 'Pending', 
	is_active bit default(1),
	created_at datetime default GetDate(),
	updated_at datetime default GetDate(),
	creation_by varchar(max),
	update_by varchar(max)
)

ALTER TABLE PRODUCT_REQUESTS
ADD 
CONSTRAINT FK_ProductRequest_customer_id
FOREIGN KEY (FK_customer_id)
REFERENCES CUSTOMERS(customer_id)
ON DELETE CASCADE
ON UPDATE CASCADE

ALTER TABLE PRODUCT_REQUESTS
ADD 
CONSTRAINT CHK_PRODUCT_REQUESTS_STATUS
 CHECK([status] IN ('Pending', 'Approved', 'Rejected'))



