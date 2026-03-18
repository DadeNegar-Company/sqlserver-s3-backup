## 2026-02-23 - [SQL Server Backup to S3 Optimization]
**Learning:** Default SQL Server `BACKUP TO URL` uses small transfer chunks (often 1MB), leading to high request overhead and slow throughput for S3 backups.
**Action:** Always check and set `MAXTRANSFERSIZE` (e.g., 10MB) for `BACKUP DATABASE ... TO URL` commands to optimize performance.

## 2026-03-18 - [SQL Server Backup I/O Optimization]
**Learning:** SQL Server S3 backups benefit from a 64KB block size to optimize I/O alignment and throughput for URL targets.
**Action:** Always include `BLOCKSIZE = 65536` in `BACKUP DATABASE ... TO URL` commands along with `MAXTRANSFERSIZE` and `BUFFERCOUNT`.
