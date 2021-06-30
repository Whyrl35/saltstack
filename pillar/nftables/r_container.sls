nftables:
  configuration:
    "container_specific":
      chains:
        - name: 'CONTAINER'
          table: 'filter'
          family: 'ip'
        - name: 'CONTAINER'
          table: 'filter'
          family: 'ip6'
      rules:
        - name: 'jump to CONTAINER'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip'
          rule: 'jump CONTAINER'
        - name: 'jump to CONTAINER'
          table: 'filter'
          chain: 'INPUT'
          family: 'ip6'
          rule: 'jump CONTAINER'
        - name: 'allow portainer'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr @myhosts tcp dport 9001 counter accept'
        - name: 'allow portainer'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts tcp dport 9001 counter accept'
        - name: 'allow swarm'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr @myhosts tcp dport 2377 counter accept'
        - name: 'allow docker api vrack'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr 192.168.0.0/24 tcp dport 2375 counter accept'
        - name: 'allow docker api'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts tcp dport 2377 counter accept'
        - name: 'allow swarm vrack'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr 192.168.0.0/24 tcp dport 2375 counter accept'
        - name: 'allow swarm'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts tcp dport 2377 counter accept'
        - name: 'allow swarm network tcp'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr 192.168.0.0/24 tcp dport 7946 counter accept'
        - name: 'allow swarm network tcp'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts tcp dport 7946 counter accept'
        - name: 'allow swarm network udp'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr 192.168.0.0/24 udp dport 4789 counter accept'
        - name: 'allow swarm network udp'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts udp dport 4789 counter accept'
        - name: 'allow swarm glusterfs vrack'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip'
          rule: 'ip saddr 192.168.0.0/24 tcp dport {24007-24009,49152-49200} counter accept'
        - name: 'allow swarm glusterfs'
          table: 'filter'
          chain: 'CONTAINER'
          family: 'ip6'
          rule: 'ip6 saddr @myhosts tcp dport {24007-24009,49152-49200} counter accept'
