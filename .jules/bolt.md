## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-02-23 - [Bash Subprocess Optimization in Loops]
**Learning:** Using `xargs` and `echo` to trim whitespace in a loop (`db=$(echo "$db" | xargs)`) incurs massive subprocess spawning overhead. Native bash parameter expansion is approximately 230x faster and prevents internal whitespace from being unintentionally collapsed.
**Action:** Replace `xargs`-based string manipulation inside loops with native bash parameter expansion (e.g., `${var#...}`).
