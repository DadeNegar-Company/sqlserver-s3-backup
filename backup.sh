#!/bin/bash

# Exit on explicitly thrown errors
set -e

# Default variables
DATE=$(date +"%Y-%m-%dT%H:%M:%SZ")
S3_PREFIX=${S3_PREFIX:-""}
SQL_HOST=${SQL_HOST:-"localhost"}
SQL_PORT=${SQL_PORT:-"1433"}
SQL_USER=${SQL_USER:-"sa"}

if [ -z "$SQL_PASSWORD" ]; then
  echo "Error: SQL_PASSWORD must be provided."
  exit 1
fi

if [ -z "$S3_BUCKET" ]; then
  echo "Error: S3_BUCKET must be provided."
  exit 1
fi

if [ -z "$S3_ACCESS_KEY_ID" ] || [ -z "$S3_SECRET_ACCESS_KEY" ]; then
  echo "Error: S3 credentials must be provided."
  exit 1
fi

if [ -z "$S3_ENDPOINT" ]; then
  echo "Error: S3_ENDPOINT must be provided for SQL Server to configure the URL."
  exit 1
fi

# Clean up s3 endpoint to remove https:// or http:// if present
# e.g., https://s3.ir-thr-at1.arvanstorage.ir -> s3.ir-thr-at1.arvanstorage.ir
CLEAN_ENDPOINT=$(echo "$S3_ENDPOINT" | sed -e 's|^[^/]*//||' -e 's|/$||')

# The credential URL for SQL Server needs to match the root or virtual host of the bucket
CREDENTIAL_URL="s3://${CLEAN_ENDPOINT}/${S3_BUCKET}"
BACKUP_BASE_URL="s3://${CLEAN_ENDPOINT}/${S3_BUCKET}"

if [ -n "$S3_PREFIX" ]; then
  BACKUP_BASE_URL="${BACKUP_BASE_URL}/${S3_PREFIX}"
fi

echo "Connecting to SQL Server $SQL_HOST:$SQL_PORT..."

# 1. Create or Update Credential
cat <<EOF > /tmp/setup_cred.sql
IF NOT EXISTS (SELECT * FROM sys.credentials WHERE name = '$CREDENTIAL_URL')
BEGIN
    CREATE CREDENTIAL [$CREDENTIAL_URL]
    WITH IDENTITY = 'S3 Access Key',
    SECRET = '${S3_ACCESS_KEY_ID}:${S3_SECRET_ACCESS_KEY}';
END
ELSE
BEGIN
    ALTER CREDENTIAL [$CREDENTIAL_URL]
    WITH IDENTITY = 'S3 Access Key',
    SECRET = '${S3_ACCESS_KEY_ID}:${S3_SECRET_ACCESS_KEY}';
END
GO
EOF

echo "Setting up S3 credentials in SQL Server for $CREDENTIAL_URL ..."
/opt/mssql-tools/bin/sqlcmd -S "$SQL_HOST,$SQL_PORT" -U "$SQL_USER" -P "$SQL_PASSWORD" -C -i /tmp/setup_cred.sql

# 2. Get list of databases
if [ "$BACKUP_ALL_DATABASES" = "true" ] || [ "$BACKUP_ALL_DATABASES" = "1" ]; then
  echo "Fetching all non-system databases..."
  cat <<EOF > /tmp/get_dbs.sql
SET NOCOUNT ON;
SELECT name FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') AND state_desc = 'ONLINE';
GO
EOF
  # -W removes trailing spaces, -h -1 removes headers
  DBS_LIST=$(/opt/mssql-tools/bin/sqlcmd -S "$SQL_HOST,$SQL_PORT" -U "$SQL_USER" -P "$SQL_PASSWORD" -C -W -h -1 -i /tmp/get_dbs.sql)
  # Convert the newline separated list into an array
  mapfile -t DBS <<< "$DBS_LIST"
elif [ -n "$SQL_DB" ]; then
  IFS=',' read -ra DBS <<< "$SQL_DB"
else
  echo "Neither SQL_DB nor BACKUP_ALL_DATABASES is provided. Nothing to backup."
  exit 0
fi

# 3. Backup loop
for db in "${DBS[@]}"; do
  # Trim whitespace
  db=$(echo "$db" | xargs)
  
  # Ignore empty lines or dashed lines from sqlcmd output
  if [ -n "$db" ] && [[ ! "$db" =~ ^-+$ ]]; then
    FILE_NAME="${db}_${DATE}.bak"
    FULL_URL="${BACKUP_BASE_URL}/${FILE_NAME}"
    echo "=============================================="
    echo "Backing up database: $db to $FULL_URL..."
    
    cat <<EOF > /tmp/backup.sql
BACKUP DATABASE [$db] 
TO URL = '$FULL_URL'
-- Optimize upload chunk size (10MB) to reduce S3 requests and improve throughput
WITH COMPRESSION, MAXTRANSFERSIZE = 10485760, STATS = 10, INIT, FORMAT,
BACKUP_OPTIONS = '{"s3": {"region":"${S3_REGION:-us-east-1}"}}';
GO
EOF
    /opt/mssql-tools/bin/sqlcmd -S "$SQL_HOST,$SQL_PORT" -U "$SQL_USER" -P "$SQL_PASSWORD" -C -i /tmp/backup.sql
    echo "Finished backing up $db."
  fi
done

echo "SQL Server backup process completed successfully."
