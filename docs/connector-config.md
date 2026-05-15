# Openflow Connector Configuration Reference

## Deployment: BYOC (runtime in customer VPC)

The Openflow runtime runs in the same AWS VPC as the EC2 SQL Server. Uses KEY_PAIR authentication to write to Snowflake.

### SQLServer Source Parameters

| Parameter | Value |
|-----------|-------|
| SQLServer Connection URL | `jdbc:sqlserver://<ec2-private-ip>:1433;databaseName=<your_database>;encrypt=false` |
| SQLServer JDBC Driver | Upload `mssql-jdbc-12.10.0.jre11.jar` (check "Reference asset") |
| SQLServer Username | `openflow_user` |
| SQLServer Password | `OpenflowPass123!` |

### SQLServer Destination Parameters

| Parameter | Value |
|-----------|-------|
| Destination Database | `OPENFLOW_SQLSERVER_POC` |
| Destination Schema Pattern | `INCREMENTAL_POC` |
| Snowflake Authentication Strategy | `KEY_PAIR` |
| Snowflake Account Identifier | `<org>-<account>` |
| Snowflake Object Identifier Resolution | `CASE_INSENSITIVE` |
| Snowflake Private Key File | Upload `rsa_key.p8` (check "Reference asset") |
| Snowflake Role | `OPENFLOW_SQLSERVER_ROLE` |
| Snowflake Username | `OPENFLOW_SQLSERVER_SVC` |
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
