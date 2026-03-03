## 2024-03-03 - Credential Exposure in sqlcmd

**Vulnerability:** SQL Server credentials (SQL_PASSWORD) and S3 credentials (S3_SECRET_ACCESS_KEY) were exposed in two ways: SQL_PASSWORD was passed via the `-P` command line argument to `sqlcmd`, which makes it visible in the system process list (`ps aux`); S3 credentials were written in plaintext to temporary files like `/tmp/setup_cred.sql` which could be read by other users on the system if permissions were misconfigured, or left behind if the script crashed.

**Learning:** When automating database interactions with `sqlcmd` or similar tools, passing secrets as command-line arguments or writing them to disk as temporary files creates a significant risk of credential exposure. The base environment or any logging mechanism might inadvertently capture these secrets.

**Prevention:** To avoid this, always pass passwords via environment variables specifically designed for this purpose (e.g., `SQLCMDPASSWORD` for `sqlcmd`). To avoid writing queries containing secrets to disk, use bash process substitution `<(...)` to pass the query string as a file descriptor directly to the tool.
