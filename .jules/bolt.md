## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-20 - [Bash Subprocess Overhead in Loops]
**Learning:** Using `echo "$var" | xargs` inside loops for string manipulation spawns subprocesses, causing massive performance overhead (~230x slower) and accidentally collapsing internal whitespace.
**Action:** Always use native Bash parameter expansion (e.g., `${var#...}`) for string manipulation within loops to avoid subprocess overhead.
