## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-24 - [Bash String Trimming Optimization]
**Learning:** Using `echo | xargs` for string trimming within loops incurs significant performance overhead by spawning subprocesses. Bash parameter expansion (`${var#...}`) provides the same functionality with ~230x improvement and avoids accidental internal whitespace collapsing.
**Action:** Prefer native Bash parameter expansion for string manipulation within loops.
