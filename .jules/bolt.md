## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-03-03 - [Bash String Manipulation]
**Learning:** Using `echo "$var" | xargs` inside a loop for string trimming spawns a new process per iteration, causing significant overhead (176x slower than built-in expansion).
**Action:** Use bash parameter expansion `${var##...}` and `extglob` for string manipulation in loops.
