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

{% if 'warp' in warp10.config %}
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
{% endif %}

{% if 'throttling' in warp10.config %}
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
{% endif %}

{% if 'directory' in warp10.config %}
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
{% endif %}

{% if 'egress' in warp10.config %}
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
{% endif %}

{% if 'ingress' in warp10.config %}
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
{% endif %}

{% if 'leveldb' in warp10.config %}
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
{% endif %}

{% if 'runner' in warp10.config %}
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
{% endif %}

{% if 'webcall' in warp10.config %}
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
{% endif %}

{% if 'datalog' in warp10.config %}
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
{% endif %}

{% if 'macros' in warp10.config %}
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
{% endif %}

{% if 'warpfleet' in warp10.config %}
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
{% endif %}

{% if 'warpscript' in warp10.config %}
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

{% if 'in_memory' in warp10.config %}
{{ warp10.path }}/etc/conf.d/30-in-memory.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.in_memory.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'ssl' in warp10.config %}
{{ warp10.path }}/etc/conf.d/30-ssl.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.ssl.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'extensions' in warp10.config %}
{{ warp10.path }}/etc/conf.d/70--extensions.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.extensions.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'http_plugin' in warp10.config %}
{{ warp10.path }}/etc/conf.d/80-http-plugin.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.http_plugin.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'influxdb_plugin' in warp10.config %}
{{ warp10.path }}/etc/conf.d/80-influxdb-plugin.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.influxdb_plugin.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'plugins' in warp10.config %}
{{ warp10.path }}/etc/conf.d/80--plugins.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.plugins.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'sharding_plugin' in warp10.config %}
{{ warp10.path }}/etc/conf.d/80-sharding-plugin.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.sharding_plugin.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'tcp_plugin' in warp10.config %}
{{ warp10.path }}/etc/conf.d/80-tcp-plugin.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.tcp_plugin.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}

{% if 'udp_plugin' in warp10.config %}
{{ warp10.path }}/etc/conf.d/80-udp-plugin.conf:
    file.keyvalue:
        - key_values:
            {% for k,v in warp10.config.udp_plugin.items() %}
            {{ k }}: {{ v }}
            {% endfor %}
        - separator: ' = '
        - uncomment: '#'
        - append_if_not_found: true
        - watch_in:
          - service: warp10-service-running
{% endif %}
