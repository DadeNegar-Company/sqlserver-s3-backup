## 2026-02-23 - [Secure SQLCMD Input Handling]
**Vulnerability:** Credentials were written to temporary files and passed via CLI arguments, exposing them to other users on the system.
**Learning:** `sqlcmd` supports input via process substitution `<(...)` combined with the `-i` flag, even though it typically expects a file path. This avoids writing secrets to disk.
**Prevention:** Use `sqlcmd ... -i <(cat <<EOF ... EOF)` for dynamic SQL generation instead of temporary files. Use `SQLCMDPASSWORD` environment variable instead of `-P`.
