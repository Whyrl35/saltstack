# Install custom probes
{% for name,ttr in pillar['noderig']['probes'].items() %}
wigo_probes_{{ name }}:
  file.managed:
    - name: {{ pillar['noderig']['collectors'] }}/{{ ttr }}/{{ name }}
    - source: salt://noderig/files/{{ name }}
    - makedirs: True
    - dir_mode: '0755'
    - user: root
    - group: root
    - mode: '0755'
    - watch_in:
        service: noderig
{% endfor %}
