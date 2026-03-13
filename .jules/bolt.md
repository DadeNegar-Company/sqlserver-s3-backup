## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2025-03-13 - [SQL Server Backup Blocksize Optimization]
**Learning:** SQL Server's default `BLOCKSIZE` (often 512 bytes for non-tape devices) causes excessive small I/O operations when writing to S3 URLs, reducing memory-to-network transfer efficiency.
**Action:** Always include `BLOCKSIZE=65536` (64KB) in `BACKUP TO URL` commands to maximize throughput and optimize memory alignment.
