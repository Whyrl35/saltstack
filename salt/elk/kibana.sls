# ------------------------------------------------------------
# - Installing kibana
# -
kibana:
  pkg.installed:
    - pkgs:
      - kibana

  cmd.run:
    - name: export NODE_OPTIONS="--max-old-space-size=3072" ; /usr/share/kibana/bin/kibana-plugin --allow-root install https://packages.wazuh.com/wazuhapp/wazuhapp.zip
    - unless: /usr/share/kibana/bin/kibana-plugin --allow-root list | grep -q wazuh
    - require:
      - pkg: kibana

  file.managed:
    - name: /etc/kibana/kibana.yml
    - user: root
    - group: root
    - mode: 644
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

kibana_conf_file:
  file.serialize:
    - name: /etc/kibana/kibana.yml
    - dataset_pillar: kibana:mergeconf
    - formatter: yaml
    - merge_if_exists: true
    - require:
      - pkg: kibana
