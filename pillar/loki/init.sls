loki:
  config:
    schema_config:
      configs:
      - from: 2020-10-24
        index:
          period: 24h
          prefix: index_
        object_store: swift
        schema: v11
        store: boltdb-shipper
    storage_config:
      boltdb_shipper:
          active_index_directory: /opt/loki/boltdb-shipper-active
          cache_location: /opt/loki/boltdb-shipper-cache
          cache_ttl: 24h
          shared_store: filesystem
      swift:
          auth_url: "https://auth.cloud.ovh.net/v3"
          username: XRg2mSG29tZa
          password: 3sWdGUXK2A5bknauwfXkczGF9MaRJcrW
          user_domain_name: default
          project_name: 3723225605861003
          project_domain_name: default
          region_name: DE
          container_name: loki
    table_manager:
      retention_deletes_enabled: true
      retention_period: 720h # ~6 months
    chunk_store_config:
      max_look_back_period: 720h

