## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-03-17 - [SQL Server Backup to S3 BLOCKSIZE Optimization]
**Learning:** For SQL Server backups to S3, omitting `BLOCKSIZE = 65536` can cause unaligned I/O and reduce overall throughput, even when `MAXTRANSFERSIZE` and `BUFFERCOUNT` are optimized.
**Action:** Always include `BLOCKSIZE = 65536` alongside `MAXTRANSFERSIZE = 20971520` and high `BUFFERCOUNT` for S3 backup commands to guarantee optimal I/O alignment and throughput.
