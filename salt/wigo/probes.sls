# Install custom probes (those that don't come with wigo package)
{% for name in pillar['wigo']['probes'] %}
wigo_probes_{{ name }}:
  file.managed:
    - name: /usr/local/wigo/probes/examples/{{ name }}
    - source: salt://wigo/files/{{ name }}
    - user: root
    - group: root
    - mode: '0755'
{% endfor %}

# Activate needed custom probes
{% for name,ttr in pillar['wigo']['probes_actives'].items() %}
wigo_probes_{{ name }}_activate:
  file.symlink:
    - name: /usr/local/wigo/probes/{{ ttr }}/{{ name }}
    - target: /usr/local/wigo/probes/examples/{{ name }}
{% endfor %}

# Configure custom probes
{% for name,probe_context in pillar['wigo']['probes_config'].items() %}
wigo_probes_{{ name }}_config:
  file.managed:
    - name: /etc/wigo/conf.d/{{ name }}.conf
    - source: salt://wigo/files/{{ name }}.conf
    - context: {{ probe_context }}
    - user: root
    - group: root
    - mode: '0644'
{% endfor %}
