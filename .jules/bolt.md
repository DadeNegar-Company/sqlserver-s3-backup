## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-14 - [Bash Loop Performance]
**Learning:** Using `echo | xargs` inside a loop spawns unnecessary subprocesses on every iteration, drastically reducing performance.
**Action:** Always prefer native bash parameter expansion (e.g., `var="${var#"${var%%[![:space:]]*}"}"`) over subprocesses for string manipulation inside loops. This improves execution speed by ~230x and prevents the accidental collapse of internal whitespace.
