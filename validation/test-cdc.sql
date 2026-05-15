-- =============================================================================
-- SOURCE — Test CDC changes (run on SQL Server after connector is running)
-- Works for both Azure SQL and AWS RDS
-- =============================================================================

-- For Azure SQL, you're already in the database.
-- For AWS RDS, uncomment: USE OpenflowPOC;

-- INSERT
INSERT INTO dbo.orders (order_id, customer_id, amount, order_date)
VALUES (9001, 1, 99.99, GETDATE());

INSERT INTO dbo.customers (customer_id, name, email)
VALUES (100, 'Test User', 'testuser@example.com');

-- UPDATE
UPDATE dbo.orders SET amount = 109.99 WHERE order_id = 9001;
UPDATE dbo.customers SET email = 'updated@example.com' WHERE customer_id = 1;

-- DELETE
DELETE FROM dbo.customers WHERE customer_id = 100;
