#!/bin/bash
set -e

# Setup environment for testing
export SQL_PASSWORD="password"
export S3_BUCKET="bucket"
export S3_ACCESS_KEY_ID="key"
export S3_SECRET_ACCESS_KEY="secret"
export S3_ENDPOINT="endpoint"
# Use the mock sqlcmd
export SQLCMD_BIN="./tests/mock_sqlcmd.sh"

# Run backup script
echo "Running backup.sh with mock sqlcmd..."
if ./backup.sh; then
  echo "Test PASSED: backup.sh ran successfully with secure configurations."
else
  echo "Test FAILED: backup.sh failed."
  exit 1
fi
