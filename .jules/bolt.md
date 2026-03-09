## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-18 - [Bash String Manipulation Performance]
**Learning:** Using `xargs` in a loop (e.g., `db=$(echo "$db" | xargs)`) spawns a subshell and process per iteration, causing significant overhead (measured at ~230x slower than built-ins).
**Action:** Prefer bash parameter expansion (e.g., `db="${db#"${db%%[![:space:]]*}"}"`) over external commands like `xargs` or `sed` for simple string manipulation inside loops.
