-- Manage Discounts: 
--Implement a stored procedure to apply or update discounts for specific 
--items or categories. 

CREATE PROCEDURE sp_ManageDiscounts
    @ProductID INT,
    @Discount FLOAT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    IF @Discount < 0 OR @Discount > 1
    BEGIN
        RAISERROR ('Invalid discount value. Must be between 0 and 1.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM PRODUCTS WHERE product_id = @ProductID)
    BEGIN
        RAISERROR ('Product ID not found.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE PRODUCTS
    SET discount_amount = @Discount, updated_at = GETDATE(), updated_by = 'System'
    WHERE product_id = @ProductID;

    COMMIT TRANSACTION;
    PRINT 'Discount applied to product.';
END

EXEC dbo.sp_ManageDiscounts @ProductID = 5, @Discount = 0.6;

