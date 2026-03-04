## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-24 - [Bash Subprocess Optimization in Loops]
**Learning:** Using `xargs` (or any subprocess like `echo` or `awk`) inside a loop for string manipulation introduces significant performance overhead and can have unintended side effects like collapsing internal whitespace. Native bash parameter expansion is much faster (measured at ~230x improvement for this case).
**Action:** Use native bash string manipulation (parameter expansion) instead of spawning subprocesses inside frequently executed loops.
