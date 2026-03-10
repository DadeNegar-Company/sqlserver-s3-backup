## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-20 - [Bash subprocess overhead in loops]
**Learning:** Using echo | xargs for string trimming inside a loop spawns subprocesses, creating a severe performance bottleneck (~230x slower) and destroying internal whitespace.
**Action:** Always use native bash parameter expansion (e.g., ${var#"${var%%[![:space:]]*}"}) for string manipulation within loops to avoid subshell overhead.
