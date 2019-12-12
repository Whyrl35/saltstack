{% from 'borgwrapper/map.jinja' import borgwrapper with context %}

include:
  - borgbackup.client

borgwrapper_bin:
  file.managed:
    - name: {{ borgwrapper.bin }}
    - source: salt://borgwrapper/files/borgwrapper
    - user: root
    - group: root
    - mode: "0750"
    - makedirs: True
    - require:
      - pkg: borgbackup
