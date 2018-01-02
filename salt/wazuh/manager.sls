# ------------------------------------------------------------
# - Installing Wazuh-manager
# -
manager:
  pkg.installed:
    - pkgs:
      - wazuh-manager

  service.running:
    - name: wazuh-manager
    - enable: True
    - require:
      - pkg : manager

