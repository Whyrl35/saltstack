#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

nftables:
  configuration:
    common:
      #
      # create tables filter/nat/raw/mangle
      tables:
        - name: 'filter'
          family: 'ip'
        - name: 'filter'
          family: 'ip6'
      #
      # create chains
      # for filters : input/forward/output
      chains:
        - name: 'INPUT'
          table: 'filter'
          family: 'ip'
          hook: 'input'
          priority: 0
          table_type: 'filter'
          policy: 'drop'
        - name: 'FORWARD'
          table: 'filter'
          family: 'ip'
          hook: 'forward'
          policy: 'drop'
        - name: 'OUTPUT'
          table: 'filter'
          family: 'ip'
          hook: 'output'
          policy: 'accept'
        - name: 'INPUT'
          table: 'filter'
          family: 'ip6'
          hook: 'input'
          priority: 0
          table_type: 'filter'
          policy: 'drop'
        - name: 'FORWARD'
          table: 'filter'
          family: 'ip6'
          hook: 'forward'
          policy: 'drop'
        - name: 'OUTPUT'
          table: 'filter'
          family: 'ip6'
          hook: 'output'
          policy: 'accept'
      #
      # create sets (like ipset)
      # myhosts : all the public IP of my hosts
      # blacklist : used by wazuh to blacklist hosts
      sets:
        - name: 'bastion'
          table: 'filter'
          family: 'ip'
          type: ipv4_addr
          flags: [ 'interval' ]
        - name: 'bastion'
          table: 'filter'
          family: 'ip6'
          type: ipv6_addr
          flags: [ 'interval' ]
        - name: 'myhosts'
          table: 'filter'
          family: 'ip'
          type: ipv4_addr
          flags: [ 'interval' ]
        - name: 'myhosts'
          table: 'filter'
          family: 'ip6'
          type: ipv6_addr
          flags: [ 'interval' ]
        - name: 'blacklist'
          table: 'filter'
          family: 'ip'
          type: ipv4_addr
          timeout: 1h
        - name: 'blacklist'
          table: 'filter'
          family: 'ip6'
          type: ipv6_addr
          timeout: 1h
      #
      # Fill the sets with elements
      set_elements:
        - name: 'bastion_elements'
          table: 'filter'
          family: 'ip'
          set: 'bastion'
          elements: {{ ips.bastion.ipv4 }}
        - name: 'bastionv6_elements'
          table: 'filter'
          family: 'ip6'
          set: 'bastion'
          elements:
            {% for ip in ips.bastion.ipv6 %}
            - {{ ip }}
            {% endfor %}
        - name: 'myhosts_elements'
          table: 'filter'
          family: 'ip'
          set: 'myhosts'
          elements: {{ ips.myhosts.ipv4 }}
        - name: 'myhostsv6_elements'
          table: 'filter'
          family: 'ip6'
          set: 'myhosts'
          elements:
            {% for ip in ips.myhosts.ipv6 %}
            - {{ ip }}
            {% endfor %}
      #
      # create all the default rules
      # INPUT rules
      rules:
        - name: "allow related,established"
          family: 'ip'
          table: 'filter'
          chain: 'INPUT'
          rule: "ct state related,established accept"
        - name: "allow related,established"
          family: 'ip6'
          table: 'filter'
          chain: 'INPUT'
          rule: "ct state related,established accept"
        - name: "allow loopback traffic"
          family: 'ip'
          table: 'filter'
          chain: 'INPUT'
          rule: "iif lo accept"
        - name: "allow loopback traffic"
          family: 'ip6'
          table: 'filter'
          chain: 'INPUT'
          rule: "iif lo accept"
        - name: "drop invalid traffic"
          family: 'ip'
          table: 'filter'
          chain: 'INPUT'
          rule: "ct state invalid drop"
        - name: "drop invalid traffic"
          family: 'ip6'
          table: 'filter'
          chain: 'INPUT'
          rule: "ct state invalid drop"
        - name: "allow ICMP traffic"
          family: 'ip'
          table: 'filter'
          chain: 'INPUT'
          rule: "ip protocol icmp icmp type { destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem, echo-request } accept"  # noqa: 204
        - name: "allow ICMPv6 traffic"
          family: 'ip6'
          table: 'filter'
          chain: 'INPUT'
          rule: "ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept"  # noqa: 204
        - name: 'Allow ssh from bastion IPv4'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'tcp dport 22 ip saddr @bastion log counter accept'
        - name: 'Allow ssh from bastion IPv6'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'tcp dport 22 ip6 saddr @bastion log counter accept'
        - name: 'drop ossec blacklist IPs'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'ip saddr @blacklist counter drop'
        - name: 'drop ossec blacklist IPs'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'ip6 saddr @blacklist counter drop'
        - name: 'jump to salt chain'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'tcp dport { 4505, 4506 } counter accept'
        - name: 'jump to salt chain'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'tcp dport { 4505, 4506 } counter accept'
