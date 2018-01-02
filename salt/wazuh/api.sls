# ------------------------------------------------------------
# - Installing Wazuh-api
# -
nodesource:
  pkg.installed:
    - pkgs:
      - nodejs

api:
  pkg.installed:
    - pkgs:
      - wazuh-api
  service.running:
    - name: wazuh-api
    - enable: True
    - require:
      - pkg : api


