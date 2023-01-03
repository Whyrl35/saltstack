#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

# XXX: Add a test on number of public IPv6, if > 0 then add IPv6 filter, otherwise none
{% set ipv6 = True %}

nftables:
  configuration:
    common_v4:
      #
      # create tables filter/nat/raw/mangle
      tables:
        - name: 'filter'
          family: 'ip'
      #
      # create chains
      # for filters : input/forward/output
      chains:
        - name: 'input'
          table: 'filter'
          family: 'ip'
          hook: 'input'
          priority: 0
          table_type: 'filter'
          policy: 'drop'
        - name: 'output'
          table: 'filter'
          family: 'ip'
          hook: 'output'
          priority: 0
          table_type: 'filter'
          policy: 'accept'
        - name: 'forward'
          table: 'filter'
          family: 'ip'
          hook: 'forward'
          priority: 10
          table_type: 'filter'
          policy: 'accept'
        - name: 'bastion'
          table: 'filter'
          family: 'ip'
        - name: 'prometheus'
          table: 'filter'
          family: 'ip'
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
        - name: 'myhosts'
          table: 'filter'
          family: 'ip'
          type: ipv4_addr
          flags: [ 'interval' ]
        - name: 'blacklist'
          table: 'filter'
          family: 'ip'
          type: ipv4_addr
          flags: [ 'interval' ]
          # timeout: 1h
      #
      # Fill the sets with elements
      set_elements:
        - name: 'bastion_elements'
          table: 'filter'
          family: 'ip'
          set: 'bastion'
          elements: {{ ips.bastion.ipv4 | unique }}
        - name: 'myhosts_elements'
          table: 'filter'
          family: 'ip'
          set: 'myhosts'
          elements: {{ ips.myhosts.static_ipv4 | unique }}
      #
      # create all the default rules
      # input rules
      rules:
        - name: "allow related,established"
          family: 'ip'
          table: 'filter'
          chain: 'input'
          rule: "ct state related,established accept"
        - name: "allow loopback traffic"
          family: 'ip'
          table: 'filter'
          chain: 'input'
          rule: "iif lo accept"
        - name: "drop invalid traffic"
          family: 'ip'
          table: 'filter'
          chain: 'input'
          rule: "ct state invalid drop"
        - name: "allow ICMP traffic"
          family: 'ip'
          table: 'filter'
          chain: 'input'
          rule: "ip protocol icmp icmp type { destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem, echo-request } accept"  # noqa: 204
        - name: 'drop ossec blacklist IPs'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'ip saddr @blacklist counter drop'

        - name: 'jump to bastion'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump bastion'
        - name: 'Allow ssh from bastion IPv4'
          table: 'filter'
          chain: 'bastion'
          family: 'ip'
          rule: 'tcp dport 22 ip saddr @bastion log counter accept'

        - name: 'jump to prometheus scraping'
          table: 'filter'
          chain: 'input'
          family: 'ip'
          rule: 'jump prometheus'
        - name: 'Allow exporters scraping from prometheus IPv4'
          table: 'filter'
          chain: 'prometheus'
          family: 'ip'
          rule: 'tcp dport 9100 ip saddr { 10.0.3.197/32, 51.178.63.140/32 } log counter accept'

    # Activate IPv6 Filtering only if IPv6 is in used.
    {% if ipv6 %}
    common_v6:
      #
      # create tables filter/nat/raw/mangle
      tables:
        - name: 'filter'
          family: 'ip6'
      #
      # create chains
      # for filters : input/forward/output
      chains:
        - name: 'input'
          table: 'filter'
          family: 'ip6'
          hook: 'input'
          priority: 0
          table_type: 'filter'
          policy: 'drop'
        - name: 'output'
          table: 'filter'
          family: 'ip6'
          hook: 'output'
          priority: 0
          table_type: 'filter'
          policy: 'accept'
        - name: 'forward'
          table: 'filter'
          family: 'ip6'
          hook: 'forward'
          priority: 0
          table_type: 'filter'
          policy: 'drop'
        - name: 'bastion'
          table: 'filter'
          family: 'ip6'
      #
      # create sets (like ipset)
      # myhosts : all the public IP of my hosts
      # blacklist : used by wazuh to blacklist hosts
      sets:
        - name: 'bastion'
          table: 'filter'
          family: 'ip6'
          type: ipv6_addr
          flags: [ 'interval' ]
        - name: 'myhosts'
          table: 'filter'
          family: 'ip6'
          type: ipv6_addr
          flags: [ 'interval' ]
        - name: 'blacklist'
          table: 'filter'
          family: 'ip6'
          type: ipv6_addr
          flags: [ 'interval' ]
          # timeout: 1h
      #
      # Fill the sets with elements
      set_elements:
        - name: 'bastionv6_elements'
          table: 'filter'
          family: 'ip6'
          set: 'bastion'
          elements:
            {% for ip in ips.bastion.ipv6 | unique %}
            - {{ ip }}
            {% endfor %}
        - name: 'myhostsv6_elements'
          table: 'filter'
          family: 'ip6'
          set: 'myhosts'
          elements:
            {% for ip in ips.myhosts.ipv6 | unique %}
            - {{ ip }}
            {% endfor %}
      #
      # create all the default rules
      # input rules
      rules:
        - name: "allow related,established"
          family: 'ip6'
          table: 'filter'
          chain: 'input'
          rule: "ct state related,established accept"
        - name: "allow loopback traffic"
          family: 'ip6'
          table: 'filter'
          chain: 'input'
          rule: "iif lo accept"
        - name: "drop invalid traffic"
          family: 'ip6'
          table: 'filter'
          chain: 'input'
          rule: "ct state invalid drop"
        - name: "allow ICMPv6 traffic"
          family: 'ip6'
          table: 'filter'
          chain: 'input'
          rule: "ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept"  # noqa: 204
        - name: 'Allow ssh from bastion IPv6'
          table: 'filter'
          chain: 'input'
          family: 'ip6'
          rule: 'tcp dport 22 ip6 saddr @bastion log counter accept'
        - name: 'drop ossec blacklist IPs'
          table: 'filter'
          chain: 'input'
          family: 'ip6'
          rule: 'ip6 saddr @blacklist counter drop'
     {% endif %}
