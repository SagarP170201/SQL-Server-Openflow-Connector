#!/bin/bash
# Generate RSA key pair for Openflow Snowflake authentication (PKCS8, no passphrase)
set -e

OUTPUT_DIR="${1:-./keys}"
mkdir -p "$OUTPUT_DIR"

openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt > "$OUTPUT_DIR/rsa_key.p8"
openssl rsa -in "$OUTPUT_DIR/rsa_key.p8" -pubout -out "$OUTPUT_DIR/rsa_key.pub"

echo "Keys generated in $OUTPUT_DIR/"
echo ""
echo "Public key (paste into ALTER USER ... SET RSA_PUBLIC_KEY):"
echo ""
grep -v "^-----" "$OUTPUT_DIR/rsa_key.pub" | tr -d '\n'
echo ""
