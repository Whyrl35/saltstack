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
