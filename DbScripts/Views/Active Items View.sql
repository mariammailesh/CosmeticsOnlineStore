-- Active Items View: 
--Create a view to display all items currently available for sale, including 
--category, brand, price, and discount amount.
CREATE VIEW ActiveItemsView AS
SELECT 
P.product_id, P.name, CL.category_name, BL.brand_name, P.base_price, P.selling_price, P.discount_amount
FROM 
PRODUCTS P INNER JOIN CATEGORIES_LOOKUP CL ON P.FK_category_id=CL.category_id
LEFT JOIN BRANDS_LOOKUP BL ON P.FK_brand_id=BL.brand_id
WHERE
P.is_active=1 

SELECT * FROM AvailableForSaleProducts
-----------------------------------------------------


