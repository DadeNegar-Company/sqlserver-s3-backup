## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-24 - [Bash String Trimming Performance]
**Learning:** Using `echo "$var" | xargs` to trim strings inside a loop spawns multiple subprocesses per iteration, causing significant overhead (measured at ~230x slower than built-ins) and accidentally collapsing internal spaces.
**Action:** Always prefer Bash parameter expansion (e.g., `var="${var#"${var%%[![:space:]]*}"}"`) for string manipulation, especially in loops, to keep operations in-process.
