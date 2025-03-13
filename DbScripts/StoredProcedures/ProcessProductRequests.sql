--Process Item Request: 
--Develop a stored procedure for the admin to process product requests 
--submitted by customers, with options to approve or reject the request.

CREATE PROCEDURE sp_ProcessProductRequest
    @RequestID INT,
    @Status VARCHAR(10) 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;


    IF @Status NOT IN ('Approved', 'Rejected')
    BEGIN
        RAISERROR ('Invalid status. Allowed values are Approved or Rejected.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM PRODUCT_REQUESTS WHERE request_id = @RequestID AND is_active = 1)
    BEGIN
        RAISERROR ('Product request not found or inactive.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE PRODUCT_REQUESTS
    SET status = @Status, updated_at = GETDATE()
    WHERE request_id = @RequestID;

    COMMIT TRANSACTION;
    PRINT 'Product request processed successfully.';
END

EXEC sp_ProcessProductRequest @RequestID = 1, @Status = 'Approved';
