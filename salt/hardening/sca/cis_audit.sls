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
