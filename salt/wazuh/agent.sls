# ------------------------------------------------------------
# - Installing Wazuh-manager
# -
agent:
  pkg.installed:
    - pkgs:
      - wazuh-agent

  service.running:
    - name: wazuh-agent
    - enable: True
    - require:
      - pkg : agent

agent_ar_ipset:
  file.managed:
    - name: /var/ossec/active-response/bin/ipset.sh
    - source: salt://wazuh/active-response/ipset.sh
    - user: root
    - group: ossec
    - mode: 750
