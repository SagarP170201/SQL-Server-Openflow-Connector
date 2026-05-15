#!/bin/bash
# Download Microsoft SQL Server JDBC driver for Openflow
set -e

OUTPUT_DIR="${1:-.}"
DRIVER_VERSION="12.10.0.jre11"
DRIVER_URL="https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/${DRIVER_VERSION}/mssql-jdbc-${DRIVER_VERSION}.jar"

curl -L -o "$OUTPUT_DIR/mssql-jdbc-${DRIVER_VERSION}.jar" "$DRIVER_URL"
echo "Downloaded: $OUTPUT_DIR/mssql-jdbc-${DRIVER_VERSION}.jar"
