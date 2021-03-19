# ------------------------------------------------------------
# - Installing Wazuh-manager
# -
agent:
  pkg.installed:
    - pkgs:
      - wazuh-agent

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
      - file: agent_ar_ipset

agent_ar_ipset:
  file.managed:
    - name: /var/ossec/active-response/bin/ipset.sh
    - source: salt://wazuh/files/ipset.sh
    - user: root
    - group: ossec
    - mode: "0750"
    - require:
      - pkg: agent
