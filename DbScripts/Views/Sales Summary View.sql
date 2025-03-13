-- Sales Summary View: 
--Create a view summarizing total sales by month, including revenue and 
--number of orders.
CREATE VIEW SalesSummaryView AS
SELECT 
    YEAR(O.created_at) AS SalesYear,
    MONTH(O.created_at) AS SalesMonth,
    COUNT(O.order_id) AS TotalOrders,
    SUM(O.subtotal + O.tax + O.shipping_cost) AS TotalRevenue
FROM ORDERS O
WHERE O.is_active = 1
GROUP BY YEAR(O.created_at), MONTH(O.created_at)

SELECT * FROM SalesSummaryView
ORDER BY SalesYear DESC, SalesMonth DESC
