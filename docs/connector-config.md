# Openflow Connector Configuration Reference

## Source: EC2 SQL Server (64 vCPU / 256 GB RAM / 6 TB)

### SQLServer Source Parameters

| Parameter | Value |
|-----------|-------|
| SQLServer Connection URL | `jdbc:sqlserver://<ec2-public-ip-or-dns>:1433;databaseName=<your_database>;encrypt=false` |
| SQLServer JDBC Driver | Upload `mssql-jdbc-12.10.0.jre11.jar` (check "Reference asset") |
| SQLServer Username | `openflow_user` |
| SQLServer Password | `OpenflowPass123!` |

### SQLServer Destination Parameters

| Parameter | Value |
|-----------|-------|
| Destination Database | `OPENFLOW_SQLSERVER_POC` |
| Destination Schema Pattern | `INCREMENTAL_POC` |
| Snowflake Authentication Strategy | `SNOWFLAKE_MANAGED_TOKEN` (SPCS) or `KEY_PAIR` (BYOC) |
| Snowflake Account Identifier | Blank (SPCS) or `<org>-<account>` (BYOC) |
| Snowflake Object Identifier Resolution | `CASE_INSENSITIVE` |
| Snowflake Private Key File | Upload `rsa_key.p8` (BYOC only) |
| Snowflake Role | `OPENFLOW_SQLSERVER_ROLE` |
| Snowflake Username | Blank (SPCS) or `OPENFLOW_SQLSERVER_SVC` (BYOC) |
| Snowflake Warehouse | `OPENFLOW_SQLSERVER_WH` |

### SQLServer Ingestion Parameters

| Parameter | Value |
|-----------|-------|
| Ingestion Type | `incremental` |
| Included Table Names | `<your_database>.<schema>.<table_1>, <your_database>.<schema>.<table_2>` |
| Merge Task Schedule CRON | `* * * * * ?` |

## Start the Connector

1. Right-click canvas → **Enable all Controller Services**
2. Right-click process group → **Start**
3. Verify: all processors green (RUNNING), no bulletin errors

## Post-POC

Change `Ingestion Type` from `incremental` → `full` so future tables use snapshot-first flow.
