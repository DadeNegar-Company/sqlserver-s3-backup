## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2024-05-24 - [SQL Server Backup BLOCKSIZE Optimization]
**Learning:** While `MAXTRANSFERSIZE` and `BUFFERCOUNT` significantly improve S3 backup throughput, omitting `BLOCKSIZE = 65536` (64KB) leaves disk I/O efficiency unoptimized. Matching maximum 64KB block sizes improves chunk processing speed during URL backups.
**Action:** Always explicitly set `BLOCKSIZE = 65536` alongside `MAXTRANSFERSIZE` when configuring high-performance `BACKUP DATABASE ... TO URL`.
