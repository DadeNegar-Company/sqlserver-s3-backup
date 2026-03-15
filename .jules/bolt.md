## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-03-15 - [SQL Server Backup to S3 Optimization - BLOCKSIZE]
**Learning:** Adding BLOCKSIZE=65536 (64KB) alongside MAXTRANSFERSIZE optimizes memory allocation and I/O alignment for SQL Server backups to URL/S3, resulting in higher throughput.
**Action:** Always include BLOCKSIZE=65536 when optimizing BACKUP DATABASE to S3 with large MAXTRANSFERSIZE.
