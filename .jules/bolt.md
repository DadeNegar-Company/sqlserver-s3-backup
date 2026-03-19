## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-24 - [SQL Server Backup Block Size Optimization]
**Learning:** SQL Server S3 backups without a specified block size can suffer from unoptimized disk I/O reads. Setting BLOCKSIZE=65536 matches the optimal 64KB chunk size for performance when used alongside large MAXTRANSFERSIZE and BUFFERCOUNT.
**Action:** Always include BLOCKSIZE=65536 when optimizing SQL Server `BACKUP TO URL` commands for S3 to maximize I/O throughput.
