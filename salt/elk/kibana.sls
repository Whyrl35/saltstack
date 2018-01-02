# ------------------------------------------------------------
# - Installing filebeat
# -
kibana:
  pkg.installed:
    - pkgs:
      - kibana

  cmd.run:
    - name: export NODE_OPTIONS="--max-old-space-size=3072" ; /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp.zip
    - unless: /usr/share/kibana/bin/kibana-plugin list | grep -q wazuh
    - require:
      - pkg: kibana

  file.managed:
    - name: /etc/kibana/kibana.yml
    - source: salt://elk/kibana.jinja
    - template: jinja
    - require:
      - pkg: kibana

  service.running:
    - name: kibana
    - enable: True
    - require:
      - cmd: kibana_systemd
      - file: /etc/kibana/kibana.yml

kibana_systemd:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - pkg: kibana
