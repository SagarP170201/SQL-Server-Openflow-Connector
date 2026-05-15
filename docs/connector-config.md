# Openflow Connector Configuration Reference

## Openflow UI Parameter Values

After installing the SQL Server connector on your runtime, right-click the process group → Parameters and fill in:

### SQLServer Source Parameters

| Parameter | Azure SQL | AWS RDS |
|-----------|-----------|---------|
| SQLServer Connection URL | `jdbc:sqlserver://openflow-poc-<unique>.database.windows.net:1433;encrypt=true;databaseName=OpenflowPOC` | `jdbc:sqlserver://<rds-endpoint>:1433;databaseName=OpenflowPOC;encrypt=false` |
| SQLServer JDBC Driver | Upload `mssql-jdbc-12.10.0.jre11.jar` (check "Reference asset") | Same |
| SQLServer Username | `openflow_user` | `openflow_user` |
| SQLServer Password | `OpenflowPass123!` | `OpenflowPass123!` |

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
| Included Table Names | `OpenflowPOC.dbo.orders, OpenflowPOC.dbo.customers` |
| Merge Task Schedule CRON | `* * * * * ?` |

## Start the Connector

1. Right-click canvas → **Enable all Controller Services**
2. Right-click process group → **Start**
3. Verify: all processors green (RUNNING), no bulletins with errors

## Post-POC

Change `Ingestion Type` from `incremental` → `full` so future tables use snapshot-first flow.
