FROM mcr.microsoft.com/mssql-tools

# Install bash if not present
USER root
RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

ENTRYPOINT ["/usr/local/bin/backup.sh"]
