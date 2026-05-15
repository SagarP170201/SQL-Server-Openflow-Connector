# SQL Server Openflow Connector — 2-Table Incremental POC

Validates a 2-table POC where the customer keeps their historical load approach and uses Openflow only for ongoing incremental replication from SQL Server.

## Architecture

```
SQL Server on EC2 (64 vCPU / 256 GB RAM / 6 TB DB)
    │ Change Tracking (CDC)
    │ Private IP (no public exposure)
    ▼
Openflow Runtime (BYOC — same VPC as EC2)
    │ Incremental mode (no snapshot)
    │ KEY_PAIR auth to Snowflake
    ▼
Snowflake (OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC)
```

## Why BYOC?

The SQL Server is on EC2 with no public IP. BYOC deploys the Openflow runtime inside the same AWS VPC, enabling direct private connectivity to SQL Server on `<private-ip>:1433`. No EAI or network rules needed.

Docs: https://docs.snowflake.com/en/user-guide/data-integration/openflow/setup-openflow-byoc

## Quickstart

1. **Source**: Run `source-setup/aws-ec2-setup.sql` on your EC2 SQL Server
2. **Destination**: Run `snowflake-setup/destination-setup.sql` in Snowflake
3. **Keys**: Run `scripts/generate-keys.sh`, then assign public key to the service user
4. **BYOC Runtime**: Set up BYOC deployment in your AWS VPC (see docs above)
5. **Connector**: Configure Openflow UI per `docs/connector-config.md`
6. **Validate**: Run `validation/test-cdc.sql` on source, then `validation/verify-snowflake.sql` on Snowflake

## File Structure

```
├── source-setup/
│   ├── aws-ec2-setup.sql        # EC2 SQL Server setup (primary)
│   └── azure-sql-setup.sql      # Azure SQL Database setup (alternate)
├── snowflake-setup/
│   └── destination-setup.sql    # Database, schema, user, role, warehouse
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

## Networking (BYOC)

No EAI or network rules required. The BYOC runtime runs in the customer's VPC and connects directly to EC2 via private IP.

| # | Check | How |
|---|-------|-----|
| 1 | BYOC runtime deployed in same VPC (or peered VPC) | Openflow UI → Deployments |
| 2 | Security group allows TCP 1433 from runtime subnet | AWS Console → EC2 → Security Groups |
| 3 | Windows Firewall allows 1433 | SQL Server Configuration Manager on EC2 |
| 4 | SQL Server TCP/IP enabled on 1433 | SQL Server Configuration Manager |

## Confidence Rating

| Component | Confidence | Notes |
|-----------|-----------|-------|
| Snowflake destination setup | **100%** | Validated — all objects created and grants verified |
| SQL Server Change Tracking | **95%** | Standard CT setup, well-documented by Microsoft |
| Openflow incremental mode | **90%** | Per Snowflake docs — `Ingestion Type = incremental` bypasses snapshot |
| Network (BYOC private) | **95%** | Same VPC, no public internet traversal |
| **Overall E2E** | **92%** | Higher confidence with BYOC — no public IP dependency |
