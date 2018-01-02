# ------------------------------------------------------------
# - Installing filebeat
# -
logstash:
  pkg.installed:
    - pkgs:
      - logstash

  group.present:
    - name: ossec
    - addusers:
      - logstash
    - require:
      - pkg: logstash

  cmd.run:
    - name: curl -so /etc/logstash/conf.d/01-wazuh.conf https://raw.githubusercontent.com/wazuh/wazuh/3.0/extensions/logstash/01-wazuh-local.conf
    - unless: ls /etc/logstash/conf.d/01-wazuh.conf
    - require:
      - pkg: logstash

  service.running:
    - name: logstash
    - enable: True
    - require:
      - cmd: logstash_systemd
      - cmd: logstash
      - group: ossec

logstash_systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - pkg: logstash
