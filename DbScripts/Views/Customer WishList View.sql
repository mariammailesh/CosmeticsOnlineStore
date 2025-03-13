--Customer Wishlist View: 
--Implement a view to show all wishlist items for each customer, including 
--item details and quantities. 
CREATE VIEW CustomerWishlistView AS
SELECT 
    C.customer_id AS CustomerID,
    P.first_name + ' ' + P.last_name AS CustomerName,
    PR.product_id AS ProductID,
    PR.name AS ProductName,
    CL.category_name AS Category,
    BL.brand_name AS Brand,
    PR.selling_price AS Price,
    PR.discount_amount AS Discount,
    WLI.is_active AS IsActiveWishlistItem,
    WLI.created_at AS WishlistAddedDate
FROM WISHLISTS W
JOIN CUSTOMERS C ON W.FK_customer_id = C.customer_id
JOIN PERSONS P ON C.FK_customer_person_id = P.person_id
JOIN WISHLIST_ITEMS WLI ON W.wishlist_id = WLI.FK_wishlist_id
JOIN PRODUCTS PR ON WLI.FK_product_id = PR.product_id
LEFT JOIN CATEGORIES_LOOKUP CL ON PR.FK_category_id = CL.category_id
LEFT JOIN BRANDS_LOOKUP BL ON PR.FK_brand_id = BL.brand_id

SELECT * FROM CustomerWishlistView