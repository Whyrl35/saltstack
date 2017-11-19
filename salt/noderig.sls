# ------------------------------------------------------------
# - Installing Beamium
# -
noderig:
  pkg.installed:
    - pkgs:
      - noderig
    - require:
      - pkgrepo : deb metrics

  service.running:
    - name: noderig
    - enable: True
    - require:
      - pkg : noderig
      - file : /etc/noderig/config.yaml
    - watch:
      - file : /etc/noderig/config.yaml

noderig_config:
  file.managed:
    - name: /etc/noderig/config.yaml
    - source: salt://noderig/config.jinja
    - user: noderig
    - group: noderig
    - mode: 644
    - template: jinja
    - require:
      - pkg : noderig

noderig_collectors:
  file.directory:
    - name: {{ pillar['noderig']['collectors'] }}
    - user: noderig
    - group: noderig
    - mode: 755
    - require:
      - service : noderig
      - file : /etc/noderig/config.yaml
