## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-24 - [Subprocess Overhead in Bash Loops]
**Learning:** Using subshells and external commands like `xargs` (e.g., `db=$(echo "$db" | xargs)`) inside loops introduces severe performance overhead (~230x) due to continuous process spawning and can inadvertently collapse internal whitespace.
**Action:** Use native Bash parameter expansion (e.g., `var="${var#"${var%%[![:space:]]*}"}"`) for string manipulation within loops to avoid spawning subprocesses.
