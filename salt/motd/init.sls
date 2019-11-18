# ------------------------------------------------------------
# - Create an init script to start/load iptables
# -
motd:
  file.managed:
    - name: /etc/motd
    - source: salt://motd/motd.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja

