#!/bin/bash

# Exit on explicitly thrown errors
set -e

# Default variables
DATE=$(date +"%Y-%m-%dT%H:%M:%SZ")
S3_PREFIX=${S3_PREFIX:-""}
SQL_HOST=${SQL_HOST:-"localhost"}
SQL_PORT=${SQL_PORT:-"1433"}
SQL_USER=${SQL_USER:-"sa"}
FAILED=0

if [ -z "$SQL_PASSWORD" ]; then
  echo "Error: SQL_PASSWORD must be provided."
  exit 1
fi

export SQLCMDPASSWORD="$SQL_PASSWORD"

SETUP_CRED_FILE=$(mktemp)
GET_DBS_FILE=$(mktemp)
BACKUP_FILE=$(mktemp)
chmod 600 "$SETUP_CRED_FILE" "$GET_DBS_FILE" "$BACKUP_FILE"
trap 'rm -f "$SETUP_CRED_FILE" "$GET_DBS_FILE" "$BACKUP_FILE"' EXIT

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

# Helper: run sqlcmd and check output for SQL errors
# Usage: run_sqlcmd_checked "description" [sqlcmd args...]
# Returns non-zero if SQL errors (Msg ..., Level ...) are detected in output
run_sqlcmd_checked() {
  local desc="$1"
  shift
  local output
  output=$(/opt/mssql-tools/bin/sqlcmd "$@" 2>&1)
  local rc=$?
  echo "$output"
  if [ $rc -ne 0 ]; then
    echo "ERROR: $desc failed with exit code $rc"
    return 1
  fi
  # Check for SQL Server error messages in output (e.g. "Msg 3201, Level 16, State 1")
  if echo "$output" | grep -qE '^Msg [0-9]+, Level (1[1-9]|[2-9][0-9]), State'; then
    echo "ERROR: $desc failed — SQL Server error detected in output"
    return 1
  fi
  return 0
}

echo "Connecting to SQL Server $SQL_HOST:$SQL_PORT..."

# 1. Create or Update Credential
cat <<EOF > "$SETUP_CRED_FILE"
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
if ! run_sqlcmd_checked "Credential setup" -S "$SQL_HOST,$SQL_PORT" -U "$SQL_USER" -C -i "$SETUP_CRED_FILE"; then
  echo "FATAL: Failed to set up S3 credentials. Aborting backup."
  exit 1
fi

# 2. Get list of databases
if [ "$BACKUP_ALL_DATABASES" = "true" ] || [ "$BACKUP_ALL_DATABASES" = "1" ]; then
  echo "Fetching all non-system databases..."
  cat <<EOF > "$GET_DBS_FILE"
SET NOCOUNT ON;
SELECT name FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') AND state_desc = 'ONLINE';
GO
EOF
  # -W removes trailing spaces, -h -1 removes headers
  DBS_LIST=$(/opt/mssql-tools/bin/sqlcmd -S "$SQL_HOST,$SQL_PORT" -U "$SQL_USER" -C -W -h -1 -i "$GET_DBS_FILE")
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
    # Generate 8 URLs for striping to support large databases and improve performance
    URL_LIST=""
    for i in {1..8}; do
      STRIPE_URL="${BACKUP_BASE_URL}/${db}_${DATE}_part${i}.bak"
      if [ -z "$URL_LIST" ]; then
        URL_LIST="TO URL = '$STRIPE_URL'"
      else
        URL_LIST="${URL_LIST},
   URL = '$STRIPE_URL'"
      fi
    done

    cat <<EOF > "$BACKUP_FILE"
BACKUP DATABASE [$db] 
$URL_LIST
-- Set MAXTRANSFERSIZE to 20MB (20971520) - max allowed for S3
-- Set BUFFERCOUNT to 100 for high-throughput parallel uploads across 8 stripes
WITH COMPRESSION, MAXTRANSFERSIZE = 20971520, STATS = 10, INIT, FORMAT, BUFFERCOUNT = 100,
BACKUP_OPTIONS = '{"s3": {"region":"${S3_REGION:-us-east-1}"}}';
GO
EOF
    if run_sqlcmd_checked "Backup of $db" -S "$SQL_HOST,$SQL_PORT" -U "$SQL_USER" -C -i "$BACKUP_FILE"; then
      echo "Successfully backed up $db."
    else
      echo "FAILED to back up $db!"
      FAILED=1
    fi
  fi
done

if [ "$FAILED" -ne 0 ]; then
  echo "SQL Server backup process completed with ERRORS."
  exit 1
fi

echo "SQL Server backup process completed successfully."
