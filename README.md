# SQL Server Openflow Connector — 2-Table Incremental POC

Validates a 2-table POC where the customer keeps their historical load approach and uses Openflow only for ongoing incremental replication from SQL Server.

## Architecture

```
SQL Server (Azure SQL / AWS RDS)
    │ Change Tracking (CDC)
    ▼
Openflow Runtime (SPCS)
    │ Incremental mode (no snapshot)
    ▼
Snowflake (OPENFLOW_SQLSERVER_POC.INCREMENTAL_POC)
```

## Quickstart

1. **Source**: Create Azure SQL or AWS RDS instance → run `source-setup/azure-sql-setup.sql` or `source-setup/aws-rds-setup.sql`
2. **Destination**: Run `snowflake-setup/destination-setup.sql` in Snowflake
3. **Keys**: Run `scripts/generate-keys.sh`
4. **Connector**: Configure Openflow UI per `docs/connector-config.md`
5. **Validate**: Run `validation/test-cdc.sql` on source, then `validation/verify-snowflake.sql` on Snowflake

## File Structure

```
├── source-setup/
│   ├── azure-sql-setup.sql      # Azure SQL Database setup
│   └── aws-rds-setup.sql        # AWS RDS SQL Server setup
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

## Confidence Rating

| Component | Confidence | Notes |
|-----------|-----------|-------|
| Snowflake destination setup | **100%** | Validated — all objects created and grants verified |
| SQL Server Change Tracking | **95%** | Standard CT setup, well-documented by Microsoft |
| Openflow incremental mode | **90%** | Per Snowflake docs — `Ingestion Type = incremental` bypasses snapshot, uses `CREATE TABLE IF NOT EXISTS` |
| EAI/Network connectivity | **85%** | Depends on firewall rules and DNS resolution from SPCS runtime |
| **Overall E2E** | **90%** | Main risk is network connectivity between SPCS and your SQL Server |

### Risk Mitigation

- Test network connectivity before starting the connector (Openflow network test utility)
- Ensure Change Tracking retention (2 days) exceeds any planned downtime
- Keep `Ingestion Type = incremental` only during the POC cutover, then switch to `full`
