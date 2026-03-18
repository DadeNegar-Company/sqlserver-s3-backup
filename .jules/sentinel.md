## 2024-05-24 - Credential exposure via sqlcmd arguments and predictable temp files
**Vulnerability:** SQL Server passwords were passed via the `-P` argument to `sqlcmd` (exposing them to process lists), and S3 secrets were written to predictable, world-readable `/tmp` files.
**Learning:** Command-line arguments are visible to any user on the system via `ps`. Hardcoded `/tmp` files can lead to symlink attacks and unauthorized reads of secrets.
**Prevention:** Use the `SQLCMDPASSWORD` environment variable for `sqlcmd` authentication. Use `mktemp` with secure templates (e.g. `XXXXXX` without extensions), enforce strict permissions (`chmod 600`), and guarantee cleanup with `trap 'rm -f ...' EXIT`.
