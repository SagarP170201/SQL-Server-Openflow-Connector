-- =============================================================================
-- AWS RDS SQL SERVER — Source Setup for Openflow 2-Table Incremental POC
-- =============================================================================
-- Prerequisites:
--   1. Create RDS instance via AWS Console (see below)
--   2. Connect using sqlcmd, Azure Data Studio, or DBeaver
--
-- AWS Console Steps:
--   1. RDS → Create database
--   2. Engine: Microsoft SQL Server
--   3. Edition: SQL Server Express (sqlserver-ex) — free tier eligible
--   4. Version: SQL Server 2022 (16.00)
--   5. Template: Free tier
--   6. DB instance identifier: openflow-sqlserver-poc
--   7. Master username: admin
--   8. Master password: YourStrongPassword123!
--   9. Instance class: db.t3.small
--  10. Storage: 20 GiB
--  11. Connectivity: Public access = Yes
--  12. Security group: Allow inbound TCP 1433 from 0.0.0.0/0
--  13. Create database (~10 min)
--
-- Connection string:
--   Server: openflow-sqlserver-poc.<id>.<region>.rds.amazonaws.com
--   Port: 1433
-- =============================================================================

-- Create a test database
CREATE DATABASE OpenflowPOC;
GO

USE OpenflowPOC;
GO

-- Enable Change Tracking
ALTER DATABASE OpenflowPOC
SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON);
GO

-- Create POC tables
CREATE TABLE dbo.orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE dbo.customers (
    customer_id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(200) NOT NULL
);
GO

-- Enable Change Tracking on both tables
ALTER TABLE dbo.orders ENABLE CHANGE_TRACKING;
ALTER TABLE dbo.customers ENABLE CHANGE_TRACKING;
GO

-- Create connector login and user
CREATE LOGIN openflow_user WITH PASSWORD = 'OpenflowPass123!';
GO

USE OpenflowPOC;
CREATE USER openflow_user FOR LOGIN openflow_user;
GO

-- Grant permissions
GRANT SELECT ON dbo.orders TO openflow_user;
GRANT SELECT ON dbo.customers TO openflow_user;
GRANT VIEW CHANGE TRACKING ON dbo.orders TO openflow_user;
GRANT VIEW CHANGE TRACKING ON dbo.customers TO openflow_user;
GO

-- Seed initial data
INSERT INTO dbo.customers VALUES
    (1, 'Alice Johnson', 'alice@example.com'),
    (2, 'Bob Smith', 'bob@example.com'),
    (3, 'Carol White', 'carol@example.com');

INSERT INTO dbo.orders VALUES
    (1, 1, 150.00, GETDATE()),
    (2, 2, 275.50, GETDATE()),
    (3, 1, 89.99, GETDATE()),
    (4, 3, 432.00, GETDATE());
GO
