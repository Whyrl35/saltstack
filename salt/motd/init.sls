# ------------------------------------------------------------
# - Create an init script to start/load iptables
# -
motd:
  file.absent:
    - name: /etc/motd

xx-motd:
  file.managed:
    - name: /etc/update-motd.d/xx-motd
    - source: salt://motd/motd.jinja
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja

00-static:
  file.managed:
    - name: /etc/update-motd.d/00-static
    - source: salt://motd/files/00-static
    - user: root
    - group: root
    - mode: "0755"

10-uname:
  file.absent:
    - name: /etc/update-motd.d/10-uname

20-uptime:
  file.managed:
    - name: /etc/update-motd.d/20-uptime
    - source: salt://motd/files/20-uptime
    - user: root
    - group: root
    - mode: "0755"

99-spacing:
  file.managed:
    - name: /etc/update-motd.d/99-spacing
    - source: salt://motd/files/99-spacing
    - user: root
    - group: root
    - mode: "0755"
