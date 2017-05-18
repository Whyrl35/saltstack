# ------------------------------------------------------------
# - Install the package
# -
iptables:
  pkg.installed:
    - pkgs:
      - iptables
      - xtables-addons-common
      - xtables-addons-dkms
  service.running:
    - name: firewall
    - enable: True
    - require:
      - pkg : iptables
      - file : /etc/init.d/firewall


# ------------------------------------------------------------
# - Create an init script to start/load iptables
# -
iptables_init:
  file.managed:
    - name: /etc/init.d/firewall
    - source: salt://iptables/init/firewall
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - pkg : iptables

# ------------------------------------------------------------
# - Directory to put the configuration files
# -
iptables_directory:
  file.directory:
    - name: {{ pillar['iptables']['conf_directory'] }}
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg : iptables

# ------------------------------------------------------------
# - Install Default rules
# -
iptables_rules_default:
  file.recurse:
    - name: /etc/iptables.d
    - source: salt://iptables/rules_default
    - include_empty: True
