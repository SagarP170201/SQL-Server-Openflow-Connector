# SQL Server Openflow Connector — 2-Table Incremental POC

Validates a 2-table POC where the customer keeps their historical load approach and uses Openflow only for ongoing incremental replication from SQL Server.

## Architecture

```
SQL Server on EC2 (64 vCPU / 256 GB RAM / 6 TB DB)
    │ Change Tracking (CDC)
    ▼
Openflow Runtime (SPCS)
    │ Incremental mode (no snapshot)
    ▼
Snowflake (OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC)
```

## Quickstart

1. **Source**: Run `source-setup/aws-ec2-setup.sql` on your EC2 SQL Server
2. **Destination**: Run `snowflake-setup/destination-setup.sql` in Snowflake
3. **Keys**: Run `scripts/generate-keys.sh`
4. **Network**: Run `snowflake-setup/eai-network-rule.sql` (fill in your EC2 endpoint)
5. **Connector**: Configure Openflow UI per `docs/connector-config.md`
6. **Validate**: Run `validation/test-cdc.sql` on source, then `validation/verify-snowflake.sql` on Snowflake

## File Structure

```
├── source-setup/
│   ├── aws-ec2-setup.sql        # EC2 SQL Server setup (primary)
│   └── azure-sql-setup.sql      # Azure SQL Database setup (alternate)
├── snowflake-setup/
│   ├── destination-setup.sql    # Database, schema, user, role, warehouse
│   └── eai-network-rule.sql     # EAI for SPCS connectivity
├── scripts/
│   ├── generate-keys.sh         # RSA key pair generation
│   └── download-jdbc-driver.sh  # MSSQL JDBC driver download
├── validation/
│   ├── test-cdc.sql             # Insert/update/delete test data on source
│   └── verify-snowflake.sql     # Confirm replication in Snowflake
├── docs/
│   └── connector-config.md      # Openflow UI parameter reference
└── cleanup/
    └── teardown.sql             # Drop all POC objects
```

## Networking Checklist

| # | Check | How |
|---|-------|-----|
| 1 | EC2 Security Group allows TCP 1433 inbound | AWS Console → EC2 → Security Groups |
| 2 | EC2 has public IP or Elastic IP | AWS Console → EC2 → Instances |
| 3 | Windows Firewall allows 1433 | `netsh advfirewall firewall show rule name=all` on EC2 |
| 4 | SQL Server TCP/IP enabled on 1433 | SQL Server Configuration Manager |
| 5 | EAI created in Snowflake | `SHOW EXTERNAL ACCESS INTEGRATIONS;` |
| 6 | EAI attached to Openflow runtime | Openflow UI → Runtime → External Access |

Ref: https://docs.snowflake.com/en/user-guide/data-integration/openflow/setup-openflow-spcs-sf-allow-list

## Confidence Rating

| Component | Confidence | Notes |
|-----------|-----------|-------|
| Snowflake destination setup | **100%** | Validated — all objects created and grants verified |
| SQL Server Change Tracking | **95%** | Standard CT setup, well-documented by Microsoft |
| Openflow incremental mode | **90%** | Per Snowflake docs — `Ingestion Type = incremental` bypasses snapshot |
| EAI/Network connectivity | **85%** | Depends on EC2 security group + EAI config |
| **Overall E2E** | **90%** | Main risk is network path from SPCS to EC2 |
