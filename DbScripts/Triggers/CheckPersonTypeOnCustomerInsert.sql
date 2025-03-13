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
