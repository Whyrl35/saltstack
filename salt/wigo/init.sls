# ------------------------------------------------------------
# - Installing Wigo
# -
wigo:
  pkg.installed:
    - pkgs:
      - wigo
    - require:
      - pkgrepo : deb wigo

  service.running:
    - name: wigo
    - enable: True
    - require:
      - pkg : wigo
      - file : /etc/wigo/wigo.conf
    - watch:
      - file : /etc/wigo/wigo.conf

  file.managed:
    - name : /etc/wigo/wigo.conf
    - source: salt://wigo/wigo.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg : wigo
