## 2024-03-06 - [Secure SQL Server CLI Credentials and Inputs]
**Vulnerability:** SQL Server passwords were passed via CLI arguments (`-P`) and S3 credentials/queries were written to `/tmp` files, exposing them to process listings and the local filesystem.
**Learning:** Passing passwords as CLI arguments and writing sensitive data to temporary files exposes them to local system users.
**Prevention:** Use environment variables (like `SQLCMDPASSWORD`) for CLI tools when supported, and use process substitution (`<(...)`) to pass multi-line sensitive input to commands securely without touching the disk.
