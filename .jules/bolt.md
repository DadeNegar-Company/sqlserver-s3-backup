## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-03-16 - [SQL Server Backup I/O Optimization]
**Learning:** Default SQL Server `BACKUP` uses a smaller default block size, leading to suboptimal I/O reads. Specifying BLOCKSIZE=65536 (64KB) alongside MAXTRANSFERSIZE and BUFFERCOUNT further optimizes I/O throughput for S3 backup operations.
**Action:** Always include BLOCKSIZE=65536 when configuring high-performance backup operations using MAXTRANSFERSIZE and BUFFERCOUNT.
