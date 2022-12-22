# ------------------------------------------------------------
# - Postfix Admin
# -
postfixadmin_prereq:
  pkg.installed:
    - pkgs:
      - debconf
      - dbconfig-common
      - wwwconfig-common
      - nginx
      - php-fpm
      - php-imap
      - php-mysql
      - mariadb-client
      #- postfixadmin

postfixadmin_install:


postfixadmin_config:
  file.managed:
    - name: /etc/postfixadmin/config.local.php
    - source: salt://postfixadmin/config.jinja
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - require:
      - pkg : postfixadmin
  group.present:
    - name: vmail
    - gid: 5000
    - system: True
  user.present:
    - name: vmail
    - home: /home/vmail
    - uid: 5000
    - gid: 5000
    - shell: /bin/false
    - createhome: True
    - nologinit: True
