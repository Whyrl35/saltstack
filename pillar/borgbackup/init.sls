borgbackup:
  lookup:
    orchestrate:
      client:
        force_server_update: False
        auto_add_servers:
          - {{ grains['id'] }}
