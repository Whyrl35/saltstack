#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_webserver_back":
      rules:
        - name: 'authorize vRack globaly'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'iif ens4 accept'
        - name: 'allow webhook'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'tcp dport 9000 counter log accept'
        - name: 'allow webhook'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'tcp dport 9000 counter log accept'
