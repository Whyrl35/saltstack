#cis_2628_remote_syslog:
  #TODO: not needed as wazuh/loki centralized the logs, not all but all necessary

cis_2629_2632_rsyslog_server:
  file.keyvalue:
    - name: '/etc/systemd/journald.conf'
    - key_values:
        ForwardToSyslog: 'yes'
        Compress: 'yes'
        Storage: 'persistent'
    - separator: '='
    - uncomment: '#'
    - key_ignore_case: True
    - append_if_not_found: True
