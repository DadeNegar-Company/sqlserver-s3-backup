## 2024-03-22 - Fix insecure credential handling and temporary files
**Vulnerability:** SQL Server password was passed using the `-P` flag to `sqlcmd`, exposing it to process listings. S3 credentials and SQL commands were written to predictable, world-readable `/tmp/*.sql` files without restrictive permissions or guaranteed cleanup.
**Learning:** External processes like `sqlcmd` must consume secrets securely via environment variables (e.g., `SQLCMDPASSWORD`). Predictable temporary files pose a risk of unauthorized reads/writes by other system users if permissions and cleanup are not strictly enforced.
**Prevention:** Always use environment variables for CLI secrets when available. If files are required, use `mktemp` with restrictive permissions (`chmod 600`) and enforce automatic cleanup using `trap 'rm -f ...' EXIT`.
## 2024-05-23 - Fix SQL injection in dynamically generated SQL scripts
**Vulnerability:** Shell variables (`db`, `S3_ACCESS_KEY_ID`, `CREDENTIAL_URL`, `S3_REGION`) were interpolated directly into dynamically generated SQL scripts in `backup.sh` without escaping. An attacker controlling the database name or S3 credentials could perform SQL injection, arbitrary code execution via `xp_cmdshell` or drop databases.
**Learning:** Generating SQL scripts using Bash here-docs (`cat <<EOF > script.sql`) exposes the system to SQL injection when user-controlled strings contain unescaped single quotes (`'`) or right brackets (`]`).
**Prevention:** Always sanitize inputs interpolated into SQL scripts. For T-SQL, escape single quotes by doubling them (`''`) and right brackets by doubling them (`]]`) using bash parameter expansion (e.g., `${var//\'/\'\'}`).
## 2024-05-24 - Fix Denial of Service risk from unsafe whitespace trimming
**Vulnerability:** Using `echo "$var" | xargs` to trim whitespace from dynamic database names crashes the script if the name contains unmatched single or double quotes, due to `xargs` parsing rules and the `set -e` script configuration.
**Learning:** `xargs` is not safe for basic string manipulation of untrusted input because it interprets quotes and special characters, potentially leading to a Denial of Service.
**Prevention:** Use native bash parameter expansion (e.g., `${var#"${var%%[![:space:]]*}"}`) to safely trim whitespace without evaluating special characters.
