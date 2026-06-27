#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

FAKE_SQLCMD="$TMP_DIR/sqlcmd"
CAPTURED_SQL="$TMP_DIR/captured.sql"
RUN_SCRIPT="$TMP_DIR/backup.sh"
RUN_LOG="$TMP_DIR/run.log"

cat > "$FAKE_SQLCMD" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

input_file=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -i)
      input_file="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

if [ -z "$input_file" ]; then
  exit 1
fi

cat "$input_file" >> "$CAPTURED_SQL"

if grep -q "FROM sys.databases" "$input_file"; then
  printf '%s\n' "appdb"
fi
EOF
chmod +x "$FAKE_SQLCMD"
tr -d '\r' < "$REPO_ROOT/backup.sh" > "$RUN_SCRIPT"

export CAPTURED_SQL
export SQLCMD_BIN="$FAKE_SQLCMD"
export SQL_PASSWORD="test-password"
export S3_BUCKET="backup-bucket"
export S3_ACCESS_KEY_ID="access"
export S3_SECRET_ACCESS_KEY="secret"
export S3_ENDPOINT="https://s3.example.test"
export SQL_DB="appdb"

if ! bash "$RUN_SCRIPT" >"$RUN_LOG" 2>&1; then
  cat "$RUN_LOG"
  echo "backup script failed before producing expected SQL"
  exit 1
fi

if ! grep -q "BUFFERCOUNT = 32" "$CAPTURED_SQL"; then
  echo "expected default BUFFERCOUNT to be 32"
  exit 1
fi

if grep -q "BUFFERCOUNT = 100" "$CAPTURED_SQL"; then
  echo "expected aggressive BUFFERCOUNT=100 to be removed"
  exit 1
fi

stripe_count=$(grep -c "part[0-9]\\.bak" "$CAPTURED_SQL")
if [ "$stripe_count" -ne 4 ]; then
  echo "expected default stripe count to be 4, got $stripe_count"
  exit 1
fi

echo "backup config defaults are conservative"
