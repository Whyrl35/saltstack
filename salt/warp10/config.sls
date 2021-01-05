{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import warp10 with context %}

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
