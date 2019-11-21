borgbackup:
  lookup:
    orchestrate:
      client:
        auto_add_servers:
          - {{ grain['id'] }}
          