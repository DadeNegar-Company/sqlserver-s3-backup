## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-02-23 - [SQL Server Backup S3 Blocksize Optimization]
**Learning:** Default `BACKUP TO URL` operations use small block sizes that degrade S3 upload throughput.
**Action:** Always explicitly include `BLOCKSIZE = 65536` (64KB) alongside `MAXTRANSFERSIZE` in the `WITH` clause to maximize performance.
