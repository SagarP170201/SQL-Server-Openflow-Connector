-- =============================================================================
-- SNOWFLAKE — EAI / Network Rule for SPCS Openflow Runtime
-- Run as ACCOUNTADMIN
-- Replace <ec2-public-ip-or-dns> with your EC2 instance's public IP or DNS
-- =============================================================================

-- For EC2-hosted SQL Server, use the public IP or Elastic IP:
CREATE OR REPLACE NETWORK RULE OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.SQLSERVER_NETWORK_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('<ec2-public-ip-or-dns>:1433');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION OPENFLOW_SQLSERVER_EAI
  ALLOWED_NETWORK_RULES = (OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC.SQLSERVER_NETWORK_RULE)
  ENABLED = TRUE;

-- Then attach OPENFLOW_SQLSERVER_EAI to your Openflow runtime in the Snowsight UI:
-- Openflow → Runtimes → your runtime → More Options → External Access → Add integration
