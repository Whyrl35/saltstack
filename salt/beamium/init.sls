# ------------------------------------------------------------
# - Installing Beamium
# -
beamium:
  pkg.installed:
    - pkgs:
      - beamium
    - require:
      - pkgrepo : deb metrics

  service.running:
    - name: beamium
    - enable: True
    - require:
      - pkg : beamium
      - file : /etc/beamium/config.yaml
    - watch:
      - file : /etc/beamium/config.yaml

  file.managed:
    - name : /etc/beamium/config.yaml
    - source: salt://beamium/config.jinja
    - user: beamium
    - group: beamium
    - mode: 644
    - template: jinja
    - require:
      - pkg : beamium


