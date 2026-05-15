-- =============================================================================
-- SNOWFLAKE — Verify replication landed (run ~60s after source changes)
-- =============================================================================

-- Check tables were created
SHOW TABLES IN SCHEMA OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC;

-- Row counts
SELECT 'ORDERS' AS tbl, COUNT(*) AS rows FROM OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.ORDERS
UNION ALL
SELECT 'CUSTOMERS', COUNT(*) FROM OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.CUSTOMERS;

-- Verify INSERT arrived
SELECT * FROM OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.ORDERS WHERE ORDER_ID = 9001;
-- Expected: amount = 109.99 (after update)

-- Verify UPDATE propagated
SELECT CUSTOMER_ID, EMAIL FROM OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.CUSTOMERS WHERE CUSTOMER_ID = 1;
-- Expected: email = 'updated@example.com'

-- Verify DELETE propagated
SELECT * FROM OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.CUSTOMERS WHERE CUSTOMER_ID = 100;
-- Expected: 0 rows

-- Check journal tables exist
SHOW TABLES LIKE '%JOURNAL%' IN SCHEMA OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC;
