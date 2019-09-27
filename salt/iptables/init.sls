# ------------------------------------------------------------
# - Install the package
# -
iptables:
  pkg.installed:
    - pkgs:
      - iptables
      - xtables-addons-common
      - xtables-addons-dkms
    - require:
      - pkg : ipset
  service.running:
    - name: firewall
    - enable: True
    - require:
      - pkg: iptables
      - file: /etc/iptables.d
      - file: /etc/init.d/firewall
      - file: iptables_service


# ------------------------------------------------------------
# - Install Default rules
# -
iptables_rules_default:
  file.recurse:
    - name: /etc/iptables.d
    - source: salt://iptables/rules_default
    - clean: True
    - include_empty: True
    - user: root
    - group: root
    - dir_mode : 700
    - file_mode : 600
    - maxdepth: 0
    - watch_in:
      - service : iptables

iptables_generated_rules:
  file.directory:
    - name: /etc/iptables.generated.d
    - user: root
    - group: root
    - dir_mode: 700
    - file_mode: 600
    - watch_in:
      - service: iptables

# ------------------------------------------------------------
# - Create an init script to start/load iptables
# -
iptables_init:
  file.managed:
    - name: /etc/init.d/firewall
    - source: salt://iptables/init/firewall
    - user: root
    - group: root
    - mode: 700
    - template: jinja
    - require:
      - pkg : iptables
      - file : /etc/iptables.d


# ------------------------------------------------------------
# - Create a systemd service
# -
iptables_service:
  file.managed:
    - name: /etc/systemd/system/firewall.service
    - source: salt://iptables/init/firewall.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg : iptables
      - file : /etc/init.d/firewall
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/firewall.service
    - require:
      - file: /etc/systemd/system/firewall.service


# ------------------------------------------------------------
# - Install Dynamic custom rules
# -
{% for name, custom in pillar.get('iptables_custom', {}).items()  %}
iptables_rules_{{ name }}:
  file.managed:
    - name: /etc/iptables.generated.d/{{ custom['chain_id'] }}-{{ custom['chain']|lower }}.rules.{{ custom['chain_type'] }}
    - source: salt://iptables/rules_custom
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - file : /etc/iptables.d
    - watch_in:
      - service : iptables
    - defaults:
      chain: {{ name }}
{% endfor %}
