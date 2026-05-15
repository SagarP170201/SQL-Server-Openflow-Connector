-- =============================================================================
-- AZURE SQL DATABASE — Source Setup for Openflow 2-Table Incremental POC
-- =============================================================================
-- Prerequisites:
--   1. Create Azure SQL Server + Database via Azure Portal (see below)
--   2. Connect using sqlcmd, Azure Data Studio, or DBeaver
--
-- Azure Portal Steps:
--   1. Portal → "Create a resource" → "SQL Database"
--   2. Resource group: create new (e.g., rg-openflow-poc)
--   3. Database name: OpenflowPOC
--   4. Server: "Create new"
--        - Server name: openflow-poc-<unique> (globally unique)
--        - Location: East US (match Snowflake region)
--        - Authentication: SQL authentication
--        - Admin login: sqladmin
--        - Password: YourStrongPassword123!
--   5. Compute: Basic tier (5 DTU, ~$5/mo) — sufficient for POC
--   6. Networking:
--        - Connectivity: Public endpoint
--        - Firewall: "Add current client IP" = Yes
--        - "Allow Azure services" = Yes
--   7. Review + Create
--
-- Connection string:
--   Server: openflow-poc-<unique>.database.windows.net
--   Port: 1433
--   Database: OpenflowPOC
-- =============================================================================

-- Enable Change Tracking on the database
ALTER DATABASE CURRENT
SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON);
GO

-- Create POC tables
CREATE TABLE dbo.orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
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

-- Create connector user (Azure SQL uses contained database users)
CREATE USER openflow_user WITH PASSWORD = 'OpenflowPass123!';
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
    (1, 1, 150.00, SYSUTCDATETIME()),
    (2, 2, 275.50, SYSUTCDATETIME()),
    (3, 1, 89.99, SYSUTCDATETIME()),
    (4, 3, 432.00, SYSUTCDATETIME());
GO
