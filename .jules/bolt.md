## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-10-24 - [SQL Server Backup S3 Block Size Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small block sizes, leading to suboptimal I/O throughput when uploading to S3.
**Action:** Always include `BLOCKSIZE = 65536` (64KB) in `BACKUP DATABASE ... TO URL` commands to maximize S3 upload performance.
