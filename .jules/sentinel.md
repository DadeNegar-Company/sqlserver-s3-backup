## 2026-03-07 - Credential Exposure in Process Lists and on Disk
**Vulnerability:** SQL Server credentials were passed via command-line arguments (`-P`), exposing them to process lists. S3 credentials and database credentials were written to `/tmp/setup_cred.sql` and other intermediate files, leaving them readable on disk.
**Learning:** Command-line arguments and temporary files on disk can easily expose sensitive secrets to other users or logging mechanisms.
**Prevention:** Use environment variables (like `SQLCMDPASSWORD`) for secrets, and use process substitution (`<(...)`) instead of writing credential-containing queries to disk.
