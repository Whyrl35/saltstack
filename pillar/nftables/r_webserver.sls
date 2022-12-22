nftables:
  configuration:
    "webserver_specific":
      chains:
        - name: 'web'
          table: 'filter'
          family: 'ip'
        {% if ('deployment' in grains) and (grains['deployment'] in ['sac', 'rbx']) %}
        - name: 'web'
          table: 'filter'
          family: 'ip6'
        {% endif %}
      rules:
        - name: 'jump to web'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump web'
        - name: 'allow web'
          table: 'filter'
          chain: 'web'
          family: 'ip'
          {% if ('deployment' in grains) and (grains['deployment'] in ['sac', 'rbx']) %}
          rule: 'tcp dport { 80, 443 } counter accept'
          {% else %}
          rule: 'tcp dport { 80, 443 } ip saddr @myhosts counter accept'
          {% endif %}

        {% if ('deployment' in grains) and (grains['deployment'] in ['sac', 'rbx']) %}
        - name: 'jump to web'
          table: 'filter'
          chain: 'input'
          family: 'ip6'
          rule: 'jump web'
        - name: 'allow web'
          table: 'filter'
          chain: 'web'
          family: 'ip6'
          rule: 'tcp dport { 80, 443 } counter accept'
        {% endif %}
