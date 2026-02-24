## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-02-24 - [Bash Loop Optimization: xargs vs Parameter Expansion]
**Learning:** Using `xargs` inside a tight loop for string trimming spawns a subprocess per iteration, which is ~127x slower than pure bash parameter expansion.
**Action:** Use `${var#...}` and `${var%...}` for string manipulation inside loops instead of piping to external tools like `xargs` or `sed`.
