## 2026-03-12 - [SQL Server Credential and Temp File Exposure]
**Vulnerability:** SQL Server passwords passed via `-P` argument to `sqlcmd` are exposed in process lists. S3 credentials written to predictable, readable `/tmp` files.
**Learning:** Command-line arguments for secrets are insecure. Standard `/tmp` file creation allows symlink attacks and secret exposure.
**Prevention:** Use environment variables like `SQLCMDPASSWORD` for secrets. Always use `mktemp` with secure permissions (`chmod 600`) and a cleanup `trap` for temporary files containing sensitive data.