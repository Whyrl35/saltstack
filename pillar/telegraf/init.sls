# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{% set minions_v4 = salt.saltutil.runner('mine.get', tgt='*', fun='network.ip_addrs') %}
{% set website_urls = ['https://bastion.whyrl.fr',
                       'https://grafana.whyrl.fr',
                       'https://hassio.whyrl.fr',
                       'https://ks.whyrl.fr',
                       'https://nas.whyrl.fr',
                       'https://salt.whyrl.fr',
                       'https://vault.whyrl.fr',
                       'https://warden.whyrl.fr',
                       'https://wazuh.whyrl.fr',
                       'https://webmail.whyrl.fr',
                       'https://whyrl.fr',
                       'https://wigo.whyrl.fr'] %}

telegraf:
  config: /etc/telegraf/telegraf.conf
  system_user: root
  system_group: root
  pkg:
    name: telegraf
  service:
    name: telegraf
  conf:
    global_tags: {}
    agent:
      interval: 30s
      round_interval: true
      metric_batch_size: 1000
      metric_buffer_limit: 10000
      collection_jitter: 0s
      flush_interval: 10s
      flush_jitter: 0s
      precision: ''
      hostname: ''
      omit_hostname: false
    inputs:
      cpu:
      - {}
      disk:
      - ignore_fs: [ "tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs",]
      diskio:
      - {}
      kernel:
      - {}
      mem:
      - {}
      processes:
      - {}
      swap:
      - {}
      system:
      - {}
      ping:
      - urls:
          - srv001.whyrl.fr
          {% for server, addrs in minions_v4.items() %}
          {% for addr in (addrs | ipv4)  %}
          {% if(addr | is_ip(options='public')) %}
          {% if server != grains['id'] %}
          - {{ server }}
          {% endif %}
          {% endif %}
          {% endfor %}
          {% endfor %}
        count: 4
        ping_interval: 1.0
        timeout: 2.0
      dns_query:
      - servers:
          - 9.9.9.9
          - 1.1.1.1
          - 8.8.8.8
          - 213.186.33.99
        domains:
          - srv001.whyrl.fr
          {% for server, addrs in minions_v4.items() %}
          {% for addr in (addrs | ipv4)  %}
          {% if(addr | is_ip(options='public')) %}
          {% if server != grains['id'] %}
          - {{ server }}
          {% endif %}
          {% endif %}
          {% endfor %}
          {% endfor %}
      http_response:
      - urls:
        {% for url in website_urls %}
        - {{ url }}
        {% endfor %}
        response_timeout: "20s"
        method: "GET"
        follow_redirects: false
    outputs:
      prometheus_client:
      - listen: ":9283"
        metric_version: 2
