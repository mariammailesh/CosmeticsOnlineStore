-- Add Item to Order: 
--Write a stored procedure to add a selected item to a customer's order, 
--ensuring stock availability is checked before adding.
CREATE PROCEDURE sp_AddItemToOrder
    @OrderID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    DECLARE @AvailableStock INT, @UnitPrice FLOAT
    BEGIN TRANSACTION
    IF NOT EXISTS (SELECT 1 FROM PRODUCTS WHERE product_id = @ProductID AND is_active = 1)
    BEGIN
        RAISERROR ('Product does not exist or is inactive.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    SELECT @AvailableStock = quantity_available, @UnitPrice = selling_price 
    FROM INVENTORY I 
    JOIN PRODUCTS P ON I.FK_product_id = P.product_id
    WHERE P.product_id = @ProductID AND I.is_active = 1

    IF @AvailableStock IS NULL OR @AvailableStock < @Quantity
    BEGIN
        RAISERROR ('Not enough stock available for the requested product.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE order_id = @OrderID AND is_active = 1)
    BEGIN
        RAISERROR ('Order does not exist or is inactive.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    INSERT INTO ORDER_ITEMS (FK_order_id, FK_product_id, quantity, unit_price, is_active, created_at, updated_at)
    VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice, 1, GETDATE(), GETDATE())
    UPDATE INVENTORY 
    SET quantity_available = quantity_available - @Quantity, updated_at = GETDATE()
    WHERE FK_product_id = @ProductID
    COMMIT TRANSACTION
    
    PRINT 'Item added to order successfully.'
END
GO
 
 EXEC sp_AddItemToOrder @OrderID = 2, @ProductID = 3, @Quantity = 2;

