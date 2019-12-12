# ------------------------------------------------------------
# - Install the package
# -
ipset:
  pkg.installed:
    - pkgs:
      - ipset
      - iprange
  service.running:
    - name: ipset
    - enable: True
    - require:
      - pkg : ipset
      - file : {{ pillar['ipset']['conf_directory'] }}
      - file : /etc/init.d/ipset
      - file : /etc/systemd/system/ipset.service

# ------------------------------------------------------------
# - Directory to put the configuration files
# -
ipset_directory:
  file.directory:
    - name: {{ pillar['ipset']['conf_directory'] }}
    - user: root
    - group: root
    - mode: "0700"
    - require:
      - pkg : ipset

# ------------------------------------------------------------
# - Create an init script to start/load ipset
# -
ipset_init:
  file.managed:
    - name: /etc/init.d/ipset
    - source: salt://ipset/init/ipset
    - user: root
    - group: root
    - mode: "0700"
    - template: jinja
    - require:
      - pkg : ipset
      - file : {{ pillar['ipset']['conf_directory'] }}

# ------------------------------------------------------------
# - Create a systemd service
# -
ipset_service:
  file.managed:
    - name: /etc/systemd/system/ipset.service
    - source: salt://ipset/init/ipset.service
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - require:
      - pkg : ipset
      - file : /etc/init.d/ipset
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/ipset.service
      - file: /etc/init.d/ipset
    - require:
      - file : /etc/systemd/system/ipset.service

# ------------------------------------------------------------
# - Install Dynamic custom rules
# -
{% for ipset_name in pillar['ipset_custom'] %}
{{ ipset_name }}:
  file.managed:
    - name: {{ pillar['ipset']['conf_directory'] }}/{{ pillar['ipset_custom'][ipset_name]['id'] }}-{{ pillar['ipset_custom'][ipset_name]['name']|lower }}.rules
    - source: salt://ipset/ipset.jinja
    - user: root
    - group: root
    - mode: "0600"
    - template: jinja
    - context:
      ipset_name : {{ ipset_name }}
    - require:
      - file : {{ pillar['ipset']['conf_directory'] }}
    - watch_in:
      - service : ipset
{% endfor %}
