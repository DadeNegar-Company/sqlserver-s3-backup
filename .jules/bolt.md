## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-25 - [Bash Subshell Performance in Loops]
**Learning:** Using subshells and external binaries (like `$(echo "$var" | xargs)`) for string manipulation inside bash loops creates massive performance overhead compared to native bash parameter expansion.
**Action:** Always use native bash string manipulation (e.g., `${var#"${var%%[![:space:]]*}"}`) inside loops to avoid spawning unnecessary processes.
