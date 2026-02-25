## 2024-05-23 - Secure sqlcmd Usage
**Vulnerability:** The `backup.sh` script exposed the SQL password in the process list by using the `-P` flag and wrote S3 credentials to temporary files in `/tmp`.
**Learning:** `sqlcmd` allows passing the password via the `SQLCMDPASSWORD` environment variable, avoiding process list exposure. It also supports reading input from file descriptors (process substitution `<(...)`), which prevents sensitive data from hitting the disk.
**Prevention:** Always use `export SQLCMDPASSWORD` and pass dynamic SQL via `<(...)` instead of temporary files.
