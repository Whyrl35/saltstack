cis_2500_remove_freevxfs:
  file.managed:
    - name: /etc/modprobe.d/freevxfs.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install freevxfs /bin/true"
  kmod.absent:
    - name: freevxfs
    - persist: true
    - onchanges:
      - file: cis_2500_remove_freevxfs

cis_2501_remove_jffs2:
  file.managed:
    - name: /etc/modprobe.d/jffs2.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install jffs2 /bin/true"
  kmod.absent:
    - name: jffs2
    - persist: true
    - onchanges:
      - file: cis_2501_remove_jffs2

cis_2502_remove_hfs:
  file.managed:
    - name: /etc/modprobe.d/hfs.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install hfs /bin/true"
  kmod.absent:
    - name: hfs
    - persist: true
    - onchanges:
      - file: cis_2502_remove_hfs

cis_2503_remove_hfsplus:
  file.managed:
    - name: /etc/modprobe.d/hfsplus.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install hfsplus /bin/true"
  kmod.absent:
    - name: hfsplus
    - persist: true
    - onchanges:
      - file: cis_2503_remove_hfsplus

cis_2504_remove_squashfs:
  file.managed:
    - name: /etc/modprobe.d/squashfs.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install squashfs /bin/true"
  kmod.absent:
    - name: squashfs
    - persist: true
    - onchanges:
      - file: cis_2504_remove_squashfs

cis_2505_remove_udf:
  file.managed:
    - name: /etc/modprobe.d/udf.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install udf /bin/true"
  kmod.absent:
    - name: udf
    - persist: true
    - onchanges:
      - file: cis_2505_remove_udf

cis_2506_remove_vfat:
  file.managed:
    - name: /etc/modprobe.d/vfat.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install vfat /bin/true"
  kmod.absent:
    - name: vfat
    - persist: true
    - onchanges:
      - file: cis_2506_remove_vfat

#cis_2507
#...
#cis_2522
#TODO: check if partitioning over cloud is possible and needed

cis_2524_disable_usb_storage:
  file.managed:
    - name: /etc/modprobe.d/usb-storage.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "install usb-storage /bin/true"
  kmod.absent:
    - name: usb-storage
    - persist: true
    - onchanges:
      - file: cis_2524_disable_usb_storage

cis_2526_sudo_remove_default_cloud_file:
  file.absent:
    - name: '/etc/sudoers.d/90-cloud-init-users'

cis_2526_sudo_use_putty:
  file.managed:
    - name: /etc/sudoers.d/pty.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: "Defaults use_pty"

cis_2526_sudo_log:
  file.managed:
    - name: /etc/sudoers.d/log.conf
    - user: root
    - group: root
    - mode: "0600"
    - contents: 'Defaults logfile="/var/log/sudo.log"'

cis_2528_aide:
  pkg.installed:
    - pkgs:
      - aide
      - aide-common
  cmd.run:
    - name: 'aideinit'
    - creates: '/var/lib/aide/aide.db'
    - require:
      - pkg: cis_2528_aide

cis_2529_aide_cronab:
  cron.present:
    - name: '/usr/bin/aide --config /etc/aide/aide.conf --check'
    - user: root
    - minute: {{ salt['random.rand_int'](start=0, end=59, seed=grains['id']) }}
    - hour: {{  salt['random.rand_int'](start=1, end=5, seed=grains['id']) }}
    - daymonth: '*'
    - month: '*'
    - dayweek: '*'
    - identifier: 'root-cis-2529'
    - comment: 'Scan binaries using aide as root'

cis_2530_grub_permission:
  file.managed:
    - name: '/boot/grub/grub.cfg'
    - user: root
    - group: root
    - mode: '0600'

#cis_2531_grub_password:
  #TODO: set a password in grub file

#cis_2532_root_password:
  #TODO: create a password, store it in vault or get it in vault, apply password for root

cis_2534_aslr:
  file.managed:
    - name: '/etc/sysctl.d/10-aslr.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'kernel.randomize_va_space = 2'
  cmd.run:
    - name: 'sysctl -w kernel.randomize_va_space=2'
    - unless: 'sysctl kernel.randomize_va_space | grep 2'
    - onchanges:
      - file: cis_2534_aslr

cis_2536_core_dump:
  file.managed:
    - name: '/etc/sysctl.d/80-core-dump.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'fs.suid_dumpable = 0'
  cmd.run:
    - name: 'sysctl -w fs.suid_dumpable=0'
    - unless: 'sysctl fs.suid_dumpable | grep 0'
    - onchanges:
      - file: cis_2536_core_dump

cis_2536_core_dump_2:
  file.managed:
    - name: '/etc/security/limits.d/core-dump.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'file: * hard core 0'

cis_2542_issue:
  file.managed:
    - name: '/etc/issue'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'Authorized uses only. All activity is monitored and will reported.'

cis_2543_issue_net:
  file.managed:
    - name: '/etc/issue.net'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'Authorized uses only. All activity is monitored and will reported.'

#cis_2552_systemd_timesyncd:
  #TODO: need to install, configure and enable timesyncd, disable ntp if installed

#cis_2576_disbale_ipv6:
  # TODO: disable IPv6 ????

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

#cis_2579_disable_ip_frowarding:
  # TODO: disable ipforwarding ?

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

#cis_2588_ipv6_router_adv:
  #TODO: disable router adv

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

#cis_2594_enable_ufw:
  #TODO:... not using ufw but directly nftables

#cis_2599_default_deny_policy:
  #TODO: deny output ?

#cis_2601_default_deny_policy_iptables:
  #TODO: wtf? no iptables here

#cis_2602_loopback_traffic_iptables:
  #TODO: iptables ??

#cis_2603_default_deny_policy_iptables_ipv6:
  #TODO: wtf? no iptables here

#cis_2604_loopback_traffic_iptables_ipv6:
  #TODO: iptables ??

cis_2605_audit_installed:
  pkg.installed:
    - pkgs:
      - auditd
      - audispd-plugins

cis_2606_audit_service_enabled:
  service.running:
    - name: auditd
    - enable: True
    - watch:
      - pkg: cis_2605_audit_installed
      - file: cis_2608_2610_audit_conf
      - file: cis_2611_audit_time
      - file: cis_2612_audit_user_group
      - file: cis_2613_audit_network
      - file: cis_2614_audit_access_control
      - file: cis_2615_audit_login
      - file: cis_2616_audit_session
      - file: cis_2617_audit_permission
      - file: cis_2618_audit_unauthorized
      - file: cis_2619_audit_successful_mount
      - file: cis_2620_audit_file_deletion
      - file: cis_2621_audit_sudoers
      - file: cis_2623_audit_modules
      - file: cis_2624_audit_immutable
    - require:
      - pkg: cis_2605_audit_installed
      - file: cis_2608_2610_audit_conf
      - file: cis_2611_audit_time
      - file: cis_2612_audit_user_group
      - file: cis_2613_audit_network
      - file: cis_2614_audit_access_control
      - file: cis_2615_audit_login
      - file: cis_2616_audit_session
      - file: cis_2617_audit_permission
      - file: cis_2618_audit_unauthorized
      - file: cis_2619_audit_successful_mount
      - file: cis_2620_audit_file_deletion
      - file: cis_2621_audit_sudoers
      - file: cis_2623_audit_modules
      - file: cis_2624_audit_immutable

#cis_2607_audit_priority:
  #TODO:change grub conf

cis_2608_2610_audit_conf:
  file.keyvalue:
    - name: '/etc/audit/auditd.conf'
    - key_values:
        max_log_file: 128
        max_log_file_action: keep_logs
        space_left_action: email
        action_mail_acct: root
        admin_space_left_action: halt
    - separator: ' = '
    - uncomment: '#'
    - key_ignore_case: True
    - append_if_not_found: True

cis_2611_audit_time:
  file.managed:
    - name: '/etc/audit/rules.d/10-time.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
        -a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
        -a always,exit -F arch=b64 -S clock_settime -k time-change
        -a always,exit -F arch=b32 -S clock_settime -k time-change
        -w /etc/localtime -p wa -k time-change

cis_2612_audit_user_group:
  file.managed:
    - name: '/etc/audit/rules.d/10-user-group.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -w /etc/group -p wa -k identity
        -w /etc/passwd -p wa -k identity
        -w /etc/gshadow -p wa -k identity
        -w /etc/shadow -p wa -k identity
        -w /etc/security/opasswd -p wa -k identity

cis_2613_audit_network:
  file.managed:
    - name: '/etc/audit/rules.d/15-network.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
        -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
        -w /etc/issue -p wa -k system-locale
        -w /etc/issue.net -p wa -k system-locale
        -w /etc/hosts -p wa -k system-locale
        -w /etc/network -p wa -k system-locale

cis_2614_audit_access_control:
  file.managed:
    - name: '/etc/audit/rules.d/20-access-controle.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -w /etc/apparmor/ -p wa -k MAC-policy
        -w /etc/apparmor.d/ -p wa -k MAC-policy

cis_2615_audit_login:
  file.managed:
    - name: '/etc/audit/rules.d/30-login.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -w /var/log/faillog -p wa -k logins
        -w /var/log/lastlog -p wa -k logins
        -w /var/log/tallylog -p wa -k logins

cis_2616_audit_session:
  file.managed:
    - name: '/etc/audit/rules.d/30-session.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -w /var/run/utmp -p wa -k session
        -w /var/log/wtmp -p wa -k logins
        -w /var/log/btmp -p wa -k logins

cis_2617_audit_permission:
  file.managed:
    - name: '/etc/audit/rules.d/30-permission.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod
        -a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod
        -a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod
        -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod
        -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
        -a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod

cis_2618_audit_unauthorized:
  file.managed:
    - name: '/etc/audit/rules.d/30-unauthorized.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access
        -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access
        -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access
        -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access

cis_2619_audit_successful_mount:
  file.managed:
    - name: '/etc/audit/rules.d/40-mounts.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts
        -a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts

cis_2620_audit_file_deletion:
  file.managed:
    - name: '/etc/audit/rules.d/40-files.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete
        -a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete

cis_2621_audit_sudoers:
  file.managed:
    - name: '/etc/audit/rules.d/40-sudoers.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -w /etc/sudoers -p wa -k scope
        -w /etc/sudoers.d/ -p wa -k scope
        -w /var/log/auth.log -p wa -k actions

cis_2623_audit_modules:
  file.managed:
    - name: '/etc/audit/rules.d/40-modules.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        -w /sbin/insmod -p x -k modules
        -w /sbin/rmmod -p x -k modules
        -w /sbin/modprobe -p x -k modules
        -a always,exit -F arch=b64 -S init_module -S delete_module -k modules

cis_2624_audit_immutable:
  file.managed:
    - name: '/etc/audit/rules.d/99-finalize.rules'
    - user: root
    - group: root
    - mode: '0644'
    - contents: '-e 2'

#cis_2628_remote_syslog:
  #TODO: not needed as wazuh/loki centralized the logs, not all but all necessary

cis_2629_2632_rsyslog_server:
  file.keyvalue:
    - name: '/etc/systemd/journald.conf'
    - key_values:
        ForwardToSyslog: 'yes'
        Compress: 'yes'
        Storage: 'persistent'
    - separator: '='
    - uncomment: '#'
    - key_ignore_case: True
    - append_if_not_found: True

cis_2636_crontab_perm:
  file.managed:
    - name: '/etc/crontab'
    - user: root
    - group: root
    - mode: '0600'

cis_2637_cron_hourly_perm:
  file.directory:
    - name: '/etc/cron.hourly'
    - user: root
    - group: root
    - mode: '0700'

cis_2638_cron_daily_perm:
  file.directory:
    - name: '/etc/cron.daily'
    - user: root
    - group: root
    - mode: '0700'

cis_2639_cron_weekly_perm:
  file.directory:
    - name: '/etc/cron.weekly'
    - user: root
    - group: root
    - mode: '0700'

cis_2640_cron_monthly_perm:
  file.directory:
    - name: '/etc/cron.monthly'
    - user: root
    - group: root
    - mode: '0700'

cis_2641_cron_d_perm:
  file.directory:
    - name: '/etc/cron.d'
    - user: root
    - group: root
    - mode: '0700'

cis_2642_cron_allow_delete_cron.deny:
  file.absent:
    - name: /etc/cron.deny

cis_2642_cron_allow_delete_at.deny:
  file.absent:
    - name: /etc/at.deny

cis_2642_cron_allow_ensure:
  file.managed:
    - name: /etc/cron.allow
    - user: root
    - group: root
    - mode: '0600'

cis_2642_cron_allow_ensure_2:
  file.managed:
    - name: /etc/at.allow
    - user: root
    - group: root
    - mode: '0600'

#cis_2643_sshd_config_perm => see pillar for openssh formulas/state
#cis_2656_sshd_macs => see pillar for openssh formulas/state
#cis_2658_sshd_timeout => see pillar for openssh formulas/state
#cis_2660_sshd_allow_deny => see pillar for openssh formulas/state
#cis_2661_sshd_banner => see pillar for openssh formulas/state
#cis_2663_sshd_forwarding => see pillar for openssh formulas/state
#cis_2664_sshd_startups => see pillar for openssh formulas/state

#cis_2666_password_quality:
  #TODO: install and configure pwquality for pam

#cis_2667_lockout:
  #TODO: configure lock-out after n unsuccessful attempts

#cis_2669_sh512_password:
  #TODO: change pam configuration

#cis_2670_2671_password_expiration:
  #TODO: change login.defs

#cis_2672_default_inactive_grace:
  #TODO: change default

#cis_2676_shell_timeout:
  #TODO: add default timeout in profiles

#cis_2677_restrict_su:
  #TODO: restric su to a group in pam

cis_2682_passwd_perm:
  file.managed:
    - name: /etc/passwd-
    - user: root
    - group: root
    - mode: '0600'

cis_2683_group_perm:
  file.managed:
    - name: /etc/group-
    - user: root
    - group: root
    - mode: '0600'
