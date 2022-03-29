#cis_2576_disbale_ipv6:
  # TODO: disable IPv6 ???? No need it !!

cis_2578_disable_icmp_redirects:
  file.managed:
    - name: '/etc/sysctl.d/20-packet-redirect.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        net.ipv4.conf.all.send_redirects = 0
        net.ipv4.conf.default.send_redirects = 0
  cmd.run:
    - name: 'sysctl -w net.ipv4.conf.default.send_redirects=0 && sysctl -w net.ipv4.conf.all.send_redirects=0 && sysctl -w net.ipv4.route.flush=1'
    - unless: 'sysctl net.ipv4.conf.default.send_redirects | grep 0'
    - onchanges:
      - file: cis_2578_disable_icmp_redirects

cis_2579_disable_ip_frowarding_ipv4:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '^(.*?)net.ipv4.ip_forward=1$'
    - repl: '\1net.ipv4.ip_forward=0'
  cmd.run:
    - name: 'sysctl -w net.ipv4.ip_forward = 0'
    - unless: 'sysctl net.ipv4.ip_forward | grep 0'
    - onchanges:
      - file: cis_2579_disable_ip_frowarding_ipv4

cis_2579_disable_ip_frowarding_ipv6:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '^(.*?)net.ipv6.conf.all.forwarding=1$'
    - repl: '\1net.ipv6.conf.all.forwarding=0'
  cmd.run:
    - name: 'sysctl -w net.ipv6.conf.all.forwarding = 0'
    - unless: 'sysctl net.ipv6.conf.all.forwarding | grep 0'
    - onchanges:
      - file: cis_2579_disable_ip_frowarding_ipv6

cis_2580_disable_source_routing:
  file.managed:
    - name: '/etc/sysctl.d/20-source-routing.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        net.ipv4.conf.all.accept_source_route = 0
        net.ipv4.conf.default.accept_source_route = 0
        net.ipv6.conf.all.accept_source_route = 0
        net.ipv6.conf.default.accept_source_route = 0
  cmd.run:
    - name: 'sysctl -w net.ipv4.conf.all.accept_source_route=0 && sysctl -w net.ipv4.conf.default.accept_source_route=0 && sysctl -w net.ipv6.conf.all.accept_source_route=0 && sysctl -w net.ipv6.conf.default.accept_source_route=0 && sysctl -w net.ipv4.route.flush=1 && sysctl -w net.ipv6.route.flush=1'
    - unless: 'sysctl net.ipv4.conf.all.accept_source_route | grep 0'
    - onchanges:
      - file: cis_2580_disable_source_routing

cis_2581_disable_icmp_redirect:
  file.managed:
    - name: '/etc/sysctl.d/20-icmp-redirects.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        net.ipv4.conf.all.accept_redirects = 0
        net.ipv4.conf.default.accept_redirects = 0
        net.ipv6.conf.all.accept_redirects = 0
        net.ipv6.conf.default.accept_redirects = 0
  cmd.run:
    - name: 'sysctl -w net.ipv4.conf.all.accept_redirects=0 && sysctl -w net.ipv4.conf.default.accept_redirects=0 && sysctl -w net.ipv6.conf.all.accept_redirects=0 && sysctl -w net.ipv6.conf.default.accept_redirects=0 && sysctl -w net.ipv4.route.flush=1 && sysctl -w net.ipv6.route.flush=1'
    - unless: 'sysctl net.ipv4.conf.all.accept_redirects | grep 0'
    - onchanges:
      - file: cis_2581_disable_icmp_redirect

cis_2582_disable_icmp_secure_redirect:
  file.managed:
    - name: '/etc/sysctl.d/20-icmp-secure-redirects.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        net.ipv4.conf.all.secure_redirects = 0
        net.ipv4.conf.default.secure_redirects = 0
  cmd.run:
    - name: 'sysctl -w net.ipv4.conf.all.secure_redirects=0 && sysctl -w net.ipv4.conf.default.secure_redirects=0 && sysctl -w net.ipv4.route.flush=1'
    - unless: 'sysctl net.ipv4.conf.all.secure_redirects | grep 0'
    - onchanges:
      - file: cis_2582_disable_icmp_secure_redirect

cis_2583_log_martians:
  file.managed:
    - name: '/etc/sysctl.d/20-martians-packet.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        net.ipv4.conf.all.log_martians = 1
        net.ipv4.conf.default.log_martians = 1
  cmd.run:
    - name: 'sysctl -w net.ipv4.conf.all.log_martians=1 && sysctl -w net.ipv4.conf.default.log_martians=1 && sysctl -w net.ipv4.route.flush=1'
    - unless: 'sysctl net.ipv4.conf.all.log_martians | grep 1'
    - onchanges:
      - file: cis_2583_log_martians

cis_2584_disable_icmp_broadcast:
  file.managed:
    - name: '/etc/sysctl.d/20-icmp-broadcast.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'net.ipv4.icmp_echo_ignore_broadcasts = 1'
  cmd.run:
    - name: 'sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1 && sysctl -w net.ipv4.route.flush=1'
    - unless: 'sysctl net.ipv4.conf.all.log_martians | grep 1'
    - onchanges:
      - file: cis_2584_disable_icmp_broadcast

cis_2585_bogus_icmp:
  file.managed:
    - name: '/etc/sysctl.d/20-icmp-bogus.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'net.ipv4.icmp_ignore_bogus_error_responses = 1'
  cmd.run:
    - name: 'sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1 && sysctl -w net.ipv4.route.flush=1'
    - unless: 'sysctl net.ipv4.icmp_ignore_bogus_error_responses | grep 1'
    - onchanges:
      - file: cis_2585_bogus_icmp

cis_2586_enabled_filtering_reverse_path:
  file.managed:
    - name: '/etc/sysctl.d/20-reverse-path-filtering.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        net.ipv4.conf.all.rp_filter = 1
        net.ipv4.conf.default.rp_filter = 1
  cmd.run:
    - name: 'sysctl -w net.ipv4.conf.all.rp_filter=1 && sysctl -w net.ipv4.conf.default.rp_filter=1 && sysctl -w net.ipv4.route.flush=1'
    - unless: 'sysctl net.ipv4.conf.all.rp_filter | grep 1'
    - onchanges:
      - file: cis_2586_enabled_filtering_reverse_path

cis_2587_tcp_syn_cookies:
  file.managed:
    - name: '/etc/sysctl.d/20-tcp-syn-cookies.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'net.ipv4.tcp_syncookies = 1'
  cmd.run:
    - name: 'sysctl -w net.ipv4.tcp_syncookies=1 && sysctl -w net.ipv4.route.flush=1'
    - unless: 'sysctl net.ipv4.tcp_syncookies | grep 1'
    - onchanges:
      - file: cis_2587_tcp_syn_cookies

cis_2588_ipv6_router_adv:
  file.managed:
    - name: '/etc/sysctl.d/30-ipv6-router-adv.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        net.ipv6.conf.all.accept_ra = 0
        net.ipv6.conf.default.accept_ra = 0
  cmd.run:
    - name: 'sysctl -w net.ipv6.conf.all.accept_ra=0 && sysctl -w net.ipv6.conf.default.accept_ra=0'
    - unless: 'sysctl net.ipv6.conf.default.accept_ra | grep 0'
    - onchanges:
      - file: cis_2588_ipv6_router_adv

cis_2589_disable_dccp:
  file.managed:
    - name: '/etc/modprobe.d/dccp.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'install dccp /bin/true'

cis_2590_disable_sctp:
  file.managed:
    - name: '/etc/modprobe.d/sctp.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'install sctp /bin/true'

cis_2591_disable_rds:
  file.managed:
    - name: '/etc/modprobe.d/rds.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'install rds /bin/true'

cis_2592_disable_tipc:
  file.managed:
    - name: '/etc/modprobe.d/tipc.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'install tipc /bin/true'
