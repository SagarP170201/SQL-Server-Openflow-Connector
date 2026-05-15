-- =============================================================================
-- SNOWFLAKE — EAI / Network Rule for SPCS Openflow Runtime
-- Run as ACCOUNTADMIN
-- Replace <your-sql-server-endpoint> with actual host
-- =============================================================================

-- For Azure SQL:
-- CREATE OR REPLACE NETWORK RULE OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.SQLSERVER_NETWORK_RULE
--   MODE = EGRESS
--   TYPE = HOST_PORT
--   VALUE_LIST = ('openflow-poc-<unique>.database.windows.net:1433');

-- For AWS RDS:
-- CREATE OR REPLACE NETWORK RULE OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.SQLSERVER_NETWORK_RULE
--   MODE = EGRESS
--   TYPE = HOST_PORT
--   VALUE_LIST = ('openflow-sqlserver-poc.<id>.<region>.rds.amazonaws.com:1433');

-- Uncomment and fill in whichever applies:
CREATE OR REPLACE NETWORK RULE OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.SQLSERVER_NETWORK_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('<your-sql-server-endpoint>:1433');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION OPENFLOW_SQLSERVER_EAI
  ALLOWED_NETWORK_RULES = (OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.SQLSERVER_NETWORK_RULE)
  ENABLED = TRUE;

-- Then attach OPENFLOW_SQLSERVER_EAI to your Openflow runtime in the Snowsight UI:
-- Openflow → Runtimes → your runtime → More Options → External Access → Add integration
