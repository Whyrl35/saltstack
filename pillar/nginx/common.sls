{% set log_format = { "msec": "$msec",
                      "connection": "$connection",
                      "connection_requests": "$connection_requests",
                      "pid": "$pid",
                      "request_id": "$request_id",
                      "request_length": "$request_length",
                      "remote_addr": "$remote_addr",
                      "remote_user": "$remote_user",
                      "remote_port": "$remote_port",
                      "time_local": "$time_local",
                      "time_iso8601": "$time_iso8601",
                      "request": "$request",
                      "request_uri": "$request_uri",
                      "args": "$args",
                      "status": "$status",
                      "body_bytes_sent": "$body_bytes_sent",
                      "bytes_sent": "$bytes_sent",
                      "http_referer": "$http_referer",
                      "http_user_agent": "$http_user_agent",
                      "http_x_forwarded_for": "$http_x_forwarded_for",
                      "http_host": "$http_host",
                      "server_name": "$server_name",
                      "request_time": "$request_time",
                      "upstream": "$upstream_addr",
                      "upstream_connect_time": "$upstream_connect_time",
                      "upstream_header_time": "$upstream_header_time",
                      "upstream_response_time": "$upstream_response_time",
                      "upstream_response_length": "$upstream_response_length",
                      "upstream_cache_status": "$upstream_cache_status",
                      "ssl_protocol": "$ssl_protocol",
                      "ssl_cipher": "$ssl_cipher",
                      "scheme": "$scheme",
                      "request_method": "$request_method",
                      "server_protocol": "$server_protocol",
                      "pipe": "$pipe",
                      "gzip_ratio": "$gzip_ratio",
                      "http_cf_ray": "$http_cf_ray",
                      "geoip_country_code": "$geoip_country_code" }  %}

nginx:
    lookup:
      package:
        - nginx
        - nginx-module-geoip
        - geoip-database
        #- geoip-database-extra
    install_from_repo: true
    service:
      enable: True
    server:
      config:
        load_module: "modules/ngx_http_geoip_module.so"
        http:
          log_format: >-
            json_analytics escape=json '{{ log_format | tojson }}'
          access_log:
            # - /var/log/nginx/access_log.json json_analytics
            - /var/log/nginx/access.log
          set_real_ip_from:
            - 10.0.1.177
          real_ip_header: X-Forwarded-For
          geoip_country: /usr/share/GeoIP/GeoIP.dat
          #geoip_city: /usr/share/GeoIP/GeoIPCity.dat
