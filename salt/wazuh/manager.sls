# ------------------------------------------------------------
# - Installing Wazuh-manager
# -
manager:
  pkg.installed:
    - pkgs:
      - openjdk-11-jdk
      - wazuh-manager

  file.managed:
    - name: /var/ossec/etc/authd.pass
    - source: salt://wazuh/authd.pass
    - user: root
    - group: ossec
    - mode: "0640"
    - template: jinja
    - require:
      - pkg: manager

  service.running:
    - name: wazuh-manager
    - enable: True
    - require:
      - pkg: manager
      - file: manager_ossec_conf
    - watch:
      - file: manager_ossec_conf

manager_ossec_conf:
  file.managed:
    - name: /var/ossec/etc/ossec.conf
    - source: salt://wazuh/ossec.conf
    - template: jinja
    - user: root
    - group: ossec
    - mode: "0640"

centralized_agent_conf:
  file.managed:
    - name: /var/ossec/etc/shared/default/agent.conf
    - source: salt://wazuh/agent.conf
    - template: jinja
    - user: root
    - group: ossec
    - mode: "0640"

manager_ar_ipset:
  file.managed:
    - name: /var/ossec/active-response/bin/ipset.sh
    - source: salt://wazuh/active-response/ipset.sh
    - user: root
    - group: ossec
    - mode: "0750"
