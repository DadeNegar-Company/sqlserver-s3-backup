## 2026-02-23 - Secure sqlcmd Usage
**Vulnerability:** SQL Server credentials were passed via command line arguments (`-P`), exposing them in the process list. Additionally, S3 keys were written to temporary files in `/tmp`, potentially exposing them to other users on the system.
**Learning:** Command line arguments are visible to all users via `ps`, and temporary files often have default permissions that are too open.
**Prevention:** Use environment variables (like `SQLCMDPASSWORD`) for passing passwords to tools. Avoid writing secrets to disk; instead, pipe them directly to the command via standard input (stdin).
