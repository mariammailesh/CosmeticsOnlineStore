--Write a query to fetch all items based on a selected category, including details such as name, price, and discount stat:
SELECT P.*, C.category_name 
FROM PRODUCTS P
JOIN CATEGORIES_LOOKUP C ON P.FK_category_id = C.category_id
WHERE C.category_name='Skincare'

--Implement a query to search for items by name or description using a keyword. 
SELECT p.product_id, B.brand_name, p.[name] AS product_name, p.[description], p.selling_price
FROM PRODUCTS p
JOIN BRANDS_LOOKUP B ON p.FK_brand_id = B.brand_id
WHERE 
[name] LIKE '%face%' 
OR 
[description] LIKE '%HAIR%'
ORDER BY product_id;

--Create a query to fetch the purchase history of a specific customer, 
--including item details, quantities, and total spent.
SELECT P.person_id, CONCAT(P.first_name,' ', P.last_name) AS [Full Name], PR.name as [product name], PR.description, OI.quantity, PR.base_price, PR.selling_price,PT.amount AS [total amount], O.created_at AS [Order Date]
FROM PERSONS P INNER JOIN ORDERS O ON P.person_id=O.FK_order_customer_id
LEFT JOIN ORDER_ITEMS OI ON  O.order_id=OI.FK_order_id
LEFT JOIN PRODUCTS PR ON OI.FK_product_id=PR.product_id
LEFT JOIN PAYMENT_TRANSACTIONS PT ON PT.FK_transaction_order_id=O.order_id
WHERE O.FK_order_customer_id= 5

--Write a query to identify the top-selling products based on order quantities 
--within a specified timeframe.
SELECT
P.name AS [Product Name], sum(OI.quantity) AS [Quantity Sold] 
FROM 
ORDER_ITEMS OI INNER JOIN ORDERS O ON OI.FK_order_id=O.order_id
LEFT JOIN PRODUCTS P ON OI.FK_product_id = P.product_id
where o.created_at between '@start' and '@end'
GROUP BY P.name
ORDER BY [Quantity Sold] desc
