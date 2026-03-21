## 2024-05-24 - Secure SQL Server Interactions

**Vulnerability:** Passing passwords via command-line arguments (`-P "$SQL_PASSWORD"`) to `sqlcmd` exposes credentials in process listings. Using predictable paths for temporary files in `/tmp` without strict permissions can lead to credential or data exposure.
**Learning:** Processes and command-line arguments are visible system-wide, and `/tmp` is a world-writable directory vulnerable to symlink attacks or snooping if permissions are not restricted. `sqlcmd` doesn't fully support bash process substitution (`<()`), requiring physical files, but `/tmp` files need tight permissions (`chmod 600`) and safe naming (`mktemp` without extensions) to prevent local snooping/race conditions.
**Prevention:** Always use `SQLCMDPASSWORD` for auth, `mktemp` with `XXXXXX` and no extension for any script-generated SQL, `chmod 600` on the files, and `trap 'rm -f ...' EXIT` for cleanup.
