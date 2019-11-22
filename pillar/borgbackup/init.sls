borgbackup:
  lookup:
    orchestrate:
      client:
        force_server_update: True
        auto_add_servers:
          - {{ grains['id'] }}
