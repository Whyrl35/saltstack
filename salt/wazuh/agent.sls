# ------------------------------------------------------------
# - Installing Wazuh-manager
# -
agent:
  pkg.installed:
    - pkgs:
      - wazuh-agent
      - python3-nftables

agent-config-manager-ip:
  file.replace:
    - name: /var/ossec/etc/ossec.conf
    - pattern: MANAGER_IP
    - repl: {{ pillar['wazuh']['server'] }}
    - require:
      - pkg: agent

agent-config-udp:
  file.replace:
    - name: /var/ossec/etc/ossec.conf
    - pattern: <protocol>tcp</protocol>
    - repl: <protocol>udp</protocol>
    - require:
      - pkg: agent

### XXX: don't needed, use the sync function of wazuh: https://documentation.wazuh.com/4.0/user-manual/reference/centralized-configuration.html

#agent-config-access-log:
#  file.replace:
#    - name: /var/ossec/etc/ossec.conf
#    - pattern: "<location>/var/log/nginx/access.log</location>"
#    - repl: "<location>/var/log/nginx/*access.log</location>"
#    - require:
#      - pkg: agent

#agent-config-error-log:
#  file.replace:
#    - name: /var/ossec/etc/ossec.conf
#    - pattern: "<location>/var/log/nginx/error.log</location>"
#    - repl: "<location>/var/log/nginx/*error.log</location>"
#    - require:
#      - pkg: agent

agent-register:
  cmd.run:
    - name: /var/ossec/bin/agent-auth -m {{ pillar['wazuh']['server'] }}
    - unless: test -f /var/ossec/etc/client.keys && test -s /var/ossec/etc/client.keys
    - require:
      - file: agent-config-manager-ip
      - file: agent-config-udp

agent-service:
  service.running:
    - name: wazuh-agent
    - enable: True
    - require:
      - cmd: agent-register
    - watch:
      - file: agent-config-manager-ip
      - file: agent-config-udp
#      - file: agent-config-access-log
#      - file: agent-config-error-log
      - file: agent_ar_ipset

agent_ar_ipset:
  file.managed:
    - name: /var/ossec/active-response/bin/ipset.sh
    - source: salt://wazuh/files/ipset.sh
    - user: root
    - group: wazuh
    - mode: "0750"
    - require:
      - pkg: agent

agent_ar_nftables:
  file.managed:
    - name: /var/ossec/active-response/bin/nftables-blacklist.py
    - source: salt://wazuh/files/nftables-blacklist.py
    - user: root
    - group: wazuh
    - mode: "0750"
    - require:
      - pkg: agent
