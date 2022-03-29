
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
