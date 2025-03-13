-- Generate Sales Report: 
--Create a stored procedure to generate a detailed sales report for a given 
--period, including itemized sales and total revenue.

CREATE PROCEDURE sp_GenerateSalesReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRANSACTION

    IF @StartDate IS NULL OR @EndDate IS NULL OR @StartDate > @EndDate
    BEGIN
        RAISERROR ('Invalid date range. Ensure both dates are provided and StartDate is not greater than EndDate.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    SELECT 
        O.order_id AS OrderID,
        P.product_id AS ProductID,
        P.name AS ProductName,
        OI.quantity AS QuantitySold,
        OI.unit_price AS UnitPrice,
        (OI.quantity * OI.unit_price) AS TotalRevenue,
        O.created_at AS OrderDate
    FROM ORDER_ITEMS OI
    INNER JOIN ORDERS O ON OI.FK_order_id = O.order_id
    INNER JOIN PRODUCTS P ON OI.FK_product_id = P.product_id
    WHERE O.created_at BETWEEN @StartDate AND @EndDate
    ORDER BY O.created_at DESC

    COMMIT TRANSACTION
END

EXEC dbo.sp_GenerateSalesReport @StartDate = '2020-01-01', @EndDate = '2029-12-31'
