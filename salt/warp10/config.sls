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
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/01-throttling.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.throttling.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
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
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/10-ingress.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.ingress.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/10-leveldb.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.leveldb.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/10-runner.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.runner.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/10-webcall.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.webcall.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/20-datalog.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.datalog.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/20-macros.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.macros.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{{ warp10.path }}/etc/conf.d/20-warpfleet.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.warpfleet.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running

{% if 'secret' in warp10.config %}
{{ warp10.path }}/etc/conf.d/20-warpscript.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.warpscript.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}
