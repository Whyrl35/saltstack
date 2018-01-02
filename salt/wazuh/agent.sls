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

