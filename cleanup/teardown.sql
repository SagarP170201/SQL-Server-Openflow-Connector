-- =============================================================================
-- TEARDOWN — Remove all POC objects
-- =============================================================================

-- Snowflake (run as ACCOUNTADMIN)
DROP DATABASE IF EXISTS OPENFLOW_SQLSERVER_POC;
DROP WAREHOUSE IF EXISTS OPENFLOW_SQLSERVER_WH;
DROP USER IF EXISTS OPENFLOW_SQLSERVER_SVC;
DROP ROLE IF EXISTS OPENFLOW_SQLSERVER_ROLE;
DROP EXTERNAL ACCESS INTEGRATION IF EXISTS OPENFLOW_SQLSERVER_EAI;

-- Azure SQL: Delete the resource group in Azure Portal
--   Portal → Resource groups → rg-openflow-poc → Delete

-- AWS RDS: Delete the instance
--   aws rds delete-db-instance --db-instance-identifier openflow-sqlserver-poc --skip-final-snapshot
