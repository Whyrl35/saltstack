{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

{% if 'secret' in warp10.config %}
{{ warp10.path }}/etc/conf.d/00-secrets.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.secret.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - key_ignore_case: true
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{{ warp10.path }}/etc/conf.d/00-warp.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.warp.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - key_ignore_case: true
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/10-directory.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.directory.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - key_ignore_case: true
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/10-egress.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.egress.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - key_ignore_case: true
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
