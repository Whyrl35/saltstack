#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    "specific_borgbackup":
      set_elements:
        - name: 'bastion_elements'
          table: 'filter'
          family: 'ip'
          set: 'bastion'
          elements: {{ ips.myhosts.ipv4 }}
        - name: 'bastionv6_elements'
          table: 'filter'
          family: 'ip6'
          set: 'bastion'
          elements: {{ ips.myhosts.ipv6 }}
