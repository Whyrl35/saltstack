{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import promtail with context %}

promtail-conf-install:
  file.directory:
    - names:
      - {{ promtail.path }}/etc
    - user: {{ promtail.identity.user }}
    - group: {{ promtail.identity.group }}
    - mode: '0755'
    - makedirs: True
    - recurse:
        - user
        - group
        - mode
  cmd.run:
    - name: curl -Lo {{ promtail.path }}/etc/promtail.yaml {{ promtail.config_file.uri }}
    - retry: 3
    - creates: {{ promtail.path }}/etc/promtail.yaml

promtail-conf-update:
  file.serialize:
    - name: {{ promtail.path }}/etc/promtail.yaml
    - user: {{ promtail.identity.user }}
    - group: {{ promtail.identity.group }}
    - mode: '0644'
    - makedirs: True
    - serializer: yaml
    - serializer_opts:
      - default_flow_style: False
      - explicit_start: False
      - indent: 2
    - merge_if_exists: True
    - dataset: {{ promtail.config }}
    # - dataset_pillar: {}

