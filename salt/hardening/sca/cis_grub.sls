{% set grub = salt['vault'].read_secret('secret/salt/account/grub') %}

cis_2530_grub_permission:
  file.managed:
    - name: '/boot/grub/grub.cfg'
    - user: root
    - group: root
    - mode: '0600'

cis_2531_grub_password:
  file.append:
    - name: /etc/grub.d/10_linux
    - text: |

        cat << EOF
        set superusers="admin"
        password_pbkdf2 admin {{ grub['pbkdf2'] }}
        EOF

cis_2531_grub_unrestricted:
  file.replace:
    - name: /etc/grub.d/10_linux
    - pattern: '^CLASS="(.*? os)"$'
    - repl: 'CLASS="\1 --unrestricted"'

cis_2531_grub_update:
  cmd.run:
    - name: /usr/sbin/update-grub
    - cwd: /
    - onchanges:
      - file: cis_2531_grub_password
      - file: cis_2531_grub_unrestricted
