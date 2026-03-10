## 2026-03-10 - Secure SQLCMD Credential Handling
**Vulnerability:** SQL Server passwords and S3 credentials were unnecessarily exposed. `sqlcmd` was executed with `-P` (exposing passwords in `ps` output), and temporary files containing S3 keys were written to `/tmp/` without secure permissions or guaranteed cleanup.
**Learning:** Shell scripts interacting with databases and cloud services often leak secrets via process lists and world-readable temporary files if default configurations are used.
**Prevention:** Always use environment variables (e.g., `SQLCMDPASSWORD`) for command-line tools to avoid process list exposure. Use `mktemp` for temporary files, immediately apply restrictive permissions (`chmod 600`), and use `trap` on `EXIT` to ensure reliable cleanup.
