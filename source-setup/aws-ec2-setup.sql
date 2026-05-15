-- =============================================================================
-- AWS EC2 SQL SERVER — Source Setup for Openflow 2-Table Incremental POC
-- =============================================================================
-- Source Instance Specs:
--   - EC2-hosted SQL Server
--   - 64 vCPU, 256 GB RAM, 6 TB database
--   - Port: 1433
--
-- Networking Prerequisites:
--   1. EC2 Security Group: Allow inbound TCP 1433 from 0.0.0.0/0
--      (or restrict to Openflow SPCS egress IPs)
--   2. EC2 must have a public IP or Elastic IP (for SPCS reachability)
--   3. No NACLs blocking 1433 on the subnet
--   4. Windows Firewall on the EC2: port 1433 open
--   5. SQL Server Configuration Manager: TCP/IP enabled, listening on 1433
--
-- Connection string:
--   Server: <ec2-public-ip-or-dns>
--   Port: 1433
-- =============================================================================

-- Enable Change Tracking on the source database
ALTER DATABASE <your_database>
SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON);
GO

USE <your_database>;
GO

-- Enable Change Tracking on the 2 POC tables
ALTER TABLE <schema>.<table_1> ENABLE CHANGE_TRACKING;
ALTER TABLE <schema>.<table_2> ENABLE CHANGE_TRACKING;
GO

-- Create connector login and user
CREATE LOGIN openflow_user WITH PASSWORD = 'OpenflowPass123!';
GO

USE <your_database>;
CREATE USER openflow_user FOR LOGIN openflow_user;
GO

-- Grant permissions on the 2 POC tables
GRANT SELECT ON <schema>.<table_1> TO openflow_user;
GRANT SELECT ON <schema>.<table_2> TO openflow_user;
GRANT VIEW CHANGE TRACKING ON <schema>.<table_1> TO openflow_user;
GRANT VIEW CHANGE TRACKING ON <schema>.<table_2> TO openflow_user;
GO
