# ------------------------------------------------------------
# - Installing Wazuh-manager
# -
agent:
  pkg.installed:
    - pkgs:
      - wazuh-agent

agent-config:
  file.replace:
    - name: /var/ossec/etc/ossec.conf
    - pattern: MANAGER_IP
    - repl: {{ pillar['wazuh']['server'] }}
    - require:
      - pkg: agent

agent-register:
  cmd.run:
    - name: /var/ossec/bin/agent-auth -m {{ pillar['wazuh']['server'] }}
    - unless: test -f /var/ossec/etc/client.keys && test -s /var/ossec/etc/client.keys
    - require:
      - file: agent-config

agen-service:
  service.running:
    - name: wazuh-agent
    - enable: True
    - require:
      - cmd: agent-register

agent_ar_ipset:
  file.managed:
    - name: /var/ossec/active-response/bin/ipset.sh
    - source: salt://wazuh/active-response/ipset.sh
    - user: root
    - group: ossec
    - mode: "0750"
