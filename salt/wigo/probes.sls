# Install custom probes (those that don't come with wigo package)
{% for name, activate in pillar['wigo']['probes'].items() %}
{% if activate %}
wigo_probes_{{ name }}:
  file.managed:
    - name: /usr/local/wigo/probes/examples/{{ name }}
    - source: salt://wigo/files/{{ name }}
    - user: root
    - group: root
    - mode: '0755'
{% else %}
wigo_probes_{{ name }}:
  file.absent:
    - name: /usr/local/wigo/probes/examples/{{ name }}
{% endif %}
{% endfor %}

# Activate needed custom probes
{% for name,ttr in pillar['wigo']['probes_actives'].items() %}
{% if pillar['wigo']['probes'][name] %}
wigo_probes_{{ name }}_activate:
  file.symlink:
    - name: /usr/local/wigo/probes/{{ ttr }}/{{ name }}
    - target: ../examples/{{ name }}
    - watch_in:
      - service: wigo_service
{% else %}
wigo_probes_{{ name }}_activate:
  file.absent:
    - name: /usr/local/wigo/probes/{{ ttr }}/{{ name }}
    - watch_in:
      - service: wigo_service
{% endif %}
{% endfor %}

# Configure custom probes
{% for name,probe_context in pillar['wigo']['probes_config'].items() %}
wigo_probes_{{ name }}_config:
  file.managed:
    - name: /etc/wigo/conf.d/{{ name }}.conf
    - source: salt://wigo/files/{{ name }}.conf
    - context: {{ probe_context }}
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
{% endfor %}
