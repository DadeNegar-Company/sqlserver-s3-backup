## 2026-03-17 - Insecure Credential Passing and Temporary Files
**Vulnerability:** SQL Server password was passed directly on the command line via `-P` parameter and sensitive queries were written to predictable, globally-readable `/tmp/*.sql` files.
**Learning:** Command line arguments are visible to any user on the system via `ps`. Predictable `/tmp` files can lead to data exposure and local privilege escalation.
**Prevention:** Always use secure environment variables (e.g., `SQLCMDPASSWORD`) for passing credentials to tools like `sqlcmd`. Use `mktemp` with secure permissions (`chmod 600`) and a `trap` for guaranteed cleanup when writing sensitive query scripts to disk.
