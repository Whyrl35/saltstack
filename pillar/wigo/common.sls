{% set roles = salt.grains.get('roles', []) %}

wigo:
  extra:
    packages: ~
    pip: ~
  probes:
    restic: true
    beamium: true
    resolver: true
  probes_actives:
    restic: 300
    beamium: 300
    resolver: 300
  probes_config:
    check_process:
      enabled: 'true'
      processList:
        - /usr/sbin/sshd
        - /usr/bin/beamium
        - /usr/bin/noderig
        - /usr/bin/salt-minion
        - /opt/promtail/bin/promtail-linux-amd64
    check_uptime:
      enabled: 'true'
      minimum: 300
      maximum: 7776000 # 90 days
    resolver:
      enabled: 'true'
      nameservers:
        {% if grains['id'] == 'srv002.whyrl.fr' %}
        - 192.168.0.1
        - 192.168.0.254
        {% elif grains['id'] == 'ks001.whyrl.fr' %}
        - 127.0.0.1
        - 213.186.33.99
        {% else %}
        {% set ns_ipv4s = salt.saltutil.runner('mine.get', tgt='ns[0-9]*', fun='network.ip_addrs') %}
        {%- for name, ips in ns_ipv4s.items() %}
        {%- for ip in ips %}
        {%- if (ip | is_ip(options='private')) %}
        - {{ ip }}
        {%- endif %}
        {%- endfor %}
        {%- endfor %}
        {%- endif %}
