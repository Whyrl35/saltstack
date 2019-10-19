nftables:
  configuration:
    common:
      #
      # create tables filter/nat/raw/mangle
      tables:
        - name: 'filter'
          family: 'inet'
      #
      # create chains
      # for filters : input/forward/output
      chains:
        - name: 'input'
          table: 'filter'
          family: 'inet'
          hook: 'input'
          priority: 0
          table_type: 'filter'
          policy: 'drop'
        - name: 'forward'
          table: 'filter'
          family: 'inet'
          hook: 'forward'
          policy: 'drop'
        - name: 'output'
          table: 'filter'
          family: 'inet'
          hook: 'output'
          policy: 'accept'
        - name: 'salt'
          table: 'filter'
          family: 'inet'
      #
      # create sets (like ipset)
      # myhosts : all the public IP of my hosts
      # blacklist : used by wazuh to blacklist hosts
      sets:
        - name: 'bastion'
          table: 'filter'
          family: 'inet'
          type: ipv4_addr
        - name: 'bastionv6'
          table: 'filter'
          family: 'inet'
          type: ipv6_addr
          flags: [ 'interval' ]
        - name: 'myhosts'
          table: 'filter'
          family: 'inet'
          type: ipv4_addr
          flags: [ 'interval' ]
        - name: 'myhostsv6'
          table: 'filter'
          family: 'inet'
          type: ipv6_addr
          flags: [ 'interval' ]
        - name: 'blacklist'
          table: 'filter'
          family: 'inet'
          type: ipv4_addr
          timeout: 1h
      #
      # Fill the sets with elements
      set_elements:
        - name: 'bastion_elements'
          table: 'filter'
          family: 'inet'
          set: 'bastion'
          elements:
            - 54.38.71.9      # bastion.whyrl.fr
            - 78.232.192.141  # whyrl.fr
            - 82.252.137.158  # whyrl.fr (4G aggregation)
            - 82.252.131.254  # whyrl.fr (4G aggregation, new)
        - name: 'bastionv6_elements'
          table: 'filter'
          family: 'inet'
          set: 'bastionv6'
          elements:
            - 2a01:e34:ee8c:8d0::/64    # whyrl.fr
            - 2001:a70:3:0::/64         # claranet
        - name: 'myhosts_elements'
          table: 'filter'
          family: 'inet'
          set: 'myhosts'
          elements:
            - 91.121.156.77/32      # ks001
            - 78.232.192.141/32     # srv001
            - 82.252.137.158/32     # srv001 since freebox delta (why???)
            - 217.182.169.71/32     # vps001
            - 217.182.85.34/32      # wazuh
            - 217.182.85.80/32      # mail
            - 54.38.71.9/32         # bastion
        - name: 'myhostsv6_elements'
          table: 'filter'
          family: 'inet'
          set: 'myhostsv6'
          elements:
            - 2a01:e34:ee8c:8d0::/64  # HOME (freebox, srv001, all @home computer)
            - 2001:41d0:1:dd4d::1/128 # ks001
      #
      # create all the default rules
      # INPUT rules
      rules:
        - name: "allow related,established"
          family: 'inet'
          table: 'filter'
          chain: 'input'
          rule: "ct state related,established accept"
        - name: "allow loopback traffic"
          family: 'inet'
          table: 'filter'
          chain: 'input'
          rule: "iif lo accept"
        - name: "drop invalid traffic"
          family: 'inet'
          table: 'filter'
          chain: 'input'
          rule: "ct state invalid drop"
        - name: "allow ICMP traffic"
          family: 'inet'
          table: 'filter'
          chain: 'input'
          rule: "ip protocol icmp icmp type { destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem, echo-request } accept"
        - name: "allow ICMPv6 traffic"
          family: 'inet'
          table: 'filter'
          chain: 'input'
          rule: "ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept"
        - name: 'Allow ssh from bastion IPv4'
          table: 'filter'
          chain: 'input'
          family: 'inet'
          rule: 'tcp dport 22 ip saddr @bastion log counter accept'
        - name: 'Allow ssh from bastion IPv6'
          table: 'filter'
          chain: 'input'
          family: 'inet'
          rule: 'tcp dport 22 ip6 saddr @bastionv6 log counter accept'
        - name: 'drop ossec blacklist IPs'
          table: 'filter'
          chain: 'input'
          family: 'inet'
          rule: 'ip saddr @blacklist counter drop'
        - name: 'jump to salt chain'
          table: 'filter'
          chain: 'input'
          family: 'inet'
          rule: 'tcp dport { 4505, 4506 } jump salt'
        - name: 'salt for my hosts'
          table: 'filter'
          chain: 'salt'
          family: 'inet'
          rule: 'ip saddr @myhosts counter accept'



