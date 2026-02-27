## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-02-24 - [Bash Loop Optimization]
**Learning:** Using `xargs` inside a loop for string trimming spawns a new process every iteration, which is ~230x slower than native Bash parameter expansion.
**Action:** Use `${var#...}` and `${var%...}` for string manipulation in tight loops instead of external commands like `xargs` or `sed`.
