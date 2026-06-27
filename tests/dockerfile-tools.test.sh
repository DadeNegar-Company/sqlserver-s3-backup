#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCKERFILE="$REPO_ROOT/Dockerfile"

if grep -q "mcr.microsoft.com/mssql-tools" "$DOCKERFILE"; then
  echo "expected Dockerfile not to use the legacy mssql-tools image"
  exit 1
fi

if ! grep -q "mssql-tools18" "$DOCKERFILE"; then
  echo "expected Dockerfile to install mssql-tools18"
  exit 1
fi

if ! grep -q "SQLCMD_BIN=/opt/mssql-tools18/bin/sqlcmd" "$DOCKERFILE"; then
  echo "expected Dockerfile to point backup.sh at sqlcmd from mssql-tools18"
  exit 1
fi

if grep -q "/usr/share/keyrings/microsoft-prod.gpg" "$DOCKERFILE" \
  && ! grep -q "signed-by=/usr/share/keyrings/microsoft-prod.gpg" "$DOCKERFILE"; then
  echo "expected Microsoft apt keyring to be referenced by signed-by when stored under /usr/share/keyrings"
  exit 1
fi

echo "docker image uses mssql-tools18"
