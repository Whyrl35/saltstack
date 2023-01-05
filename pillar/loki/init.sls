{% set secret = salt['vault'].read_secret('secret/salt/openstack/admin') %}
{% set loki_info = salt.http.query('https://api.github.com/repos/grafana/loki/releases/latest')['body'] | load_json %}
{% set version = loki_info.tag_name %}

loki:
  archive:
    github:
      version: {{ version }}

  config:
    schema_config:
      configs:
      - from: 2023-01-01
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
          username: {{ secret['username'] }}
          password: {{ secret['password'] }}
          user_domain_name: default
          project_name: {{ secret['project_id'] }}
          project_domain_name: default
          region_name: GRA
          container_name: loki

    table_manager:
      retention_deletes_enabled: true
      retention_period: 2190h # ~3 months

    chunk_store_config:
      # store for 6 months
      max_look_back_period: 2190h


    limits_config:
      enforce_metric_name: false
      max_cache_freshness_per_query: 10m
      max_query_length: 12000h
      max_query_parallelism: 256
      reject_old_samples: true
      reject_old_samples_max_age: 168h
      ingestion_rate_mb: 10
      ingestion_burst_size_mb: 30

    frontend_worker:
      parallelism: 2

    frontend:
      log_queries_longer_than: 5s
      compress_responses: true
      max_outstanding_per_tenant: 8192

    query_range:
      split_queries_by_interval: 0
      parallelise_shardable_queries: false

    server:
      http_server_read_timeout: 3m
      http_server_write_timeout: 3m

    query_scheduler:
      max_outstanding_requests_per_tenant: 10000
