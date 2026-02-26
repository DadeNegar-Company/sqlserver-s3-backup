## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-02-26 - [Bash Trim Optimization]
**Learning:** Using `xargs` inside a loop to trim whitespace spawns a subshell and external process for every iteration, causing significant overhead (300x slower than bash expansion).
**Action:** Use bash parameter expansion (`"${var#"${var%%[![:space:]]*}"}"`) for trimming strings inside loops.
