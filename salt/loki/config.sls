{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import loki with context %}

loki-conf-install:
  file.directory:
    - names:
      - {{ loki.path }}/etc
    - user: {{ loki.identity.user }}
    - group: {{ loki.identity.group }}
    - mode: '0755'
    - makedirs: True
    - recurse:
        - user
        - group
        - mode
  cmd.run:
    - name: curl -Lo {{ loki.path }}/etc/loki.yaml {{ loki.config_file.uri }}
    - retry: 3
    - creates: {{ loki.path }}/etc/loki.yaml

loki-conf-update:
  file.serialize:
    - name: {{ loki.path }}/etc/loki.yaml
    - user: {{ loki.identity.user }}
    - group: {{ loki.identity.group }}
    - mode: '0644'
    - makedirs: True
    - serializer: yaml
    - serializer_opts:
      - default_flow_style: False
      - explicit_start: False
      - indent: 4
    - merge_if_exists: True
    - dataset: {{ loki.config }}
    - require:
      - cmd: loki-conf-install
    # - dataset_pillar: {}
