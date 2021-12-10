{% set ns_ipv4s = salt.saltutil.runner('mine.get', tgt='ns[0-9]*', fun='network.ip_addrs') %}
{% set my_ipv4s = salt.grains.get('ipv4', []) %}
{% set bind_keys = salt['vault'].read_secret('secret/salt/bind/keys') %}

### General config options ###

bind:
  lookup:
    key_directory: '/etc/bind/keys'
    key_algorithm: RSASHA256
    key_algorithm_field: '008'
    key_size: 4096

  config:
    enable_logging: true
    use_extensive_logging:
      channel:
        default_log:
          file: default
          size: '200m'
          versions: '10'
          print-time: true
          print-category: true
          print-severity: true
          severity: info
        queries_log:
          file: queries
          print-time: true
          print-category: true
          print-severity: true
          severity: info
        query-errors_log:
          file: query-errors
          print-time: true
          print-category: true
          print-severity: true
          severity: dynamic
        default_syslog:
          print-time: true
          print-category: true
          print-severity: true
          syslog: daemon
          severity: info
        default_debug:
          file: named.run
          print-time: true
          print-category: true
          print-severity: true
          severity: info
      category:
        default:
          - default_syslog
          - default_debug
          - default_log
        config:
          - default_syslog
          - default_debug
          - default_log
        network:
          - default_syslog
          - default_debug
          - default_log
        general:
          - default_syslog
          - default_debug
          - default_log
        queries:
          - queries_log
        query-errors:
          - query-errors_log

    options:
     allow-recursion: '{ 10.3.0.0/16; 127.0.0.1; }'
     querylog: 'yes'
     forwarders:
       - 213.186.33.99
       - 9.9.9.9
       - 1.1.1.1

    protocol: 4
    default_zones: true

  rndc_client:
    options:
      default:
        server: localhost
        port: 953
        key: rndc-key
    server:
      '127.0.0.1':
        key: rndc-key
      'localhost':
        key: rndc-key

  controls:
    local:
      enabled: true
      bind:
        address: 127.0.0.1
        port: 953
      allow:
        - 127.0.0.1
      keys:
        - rndc-key
        - dns_key
    {% for ip in my_ipv4s %}
    {% if(ip | is_ip(options='private')) %}
    my_{{ ip }}:
      enabled: true
      bind:
        address: {{ ip }}
        port: 953
      allow:
        - {{ ip }}
        - my_net
      keys:
        - rndc-key
        - dns_key
    {% endif %}
    {% endfor %}

  statistics:
    local:
      enabled: true
      bind:
        address: 127.0.0.1
        port: 8053
      allow:
        - 127.0.0.1
    {% for ip in my_ipv4s %}
    {% if(ip | is_ip(options='private')) %}
    my_{{ ip }}:
      enabled: true
      bind:
        address: {{ ip }}
        port: 8123
      allow:
        - {{ ip }}
        - my_net
    {% endif %}
    {% endfor %}

include:
  {% if 'dns-master' in grains['roles'] %}
  - .master
  {% endif %}
  {% if 'dns-slave' in grains['roles'] %}
  - .slave
  {% endif %}
