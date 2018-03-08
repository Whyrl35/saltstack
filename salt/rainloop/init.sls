rainloop.packages:
  pkg.installed:
    - pkgs:
      - php-cli
      - php-mcrypt
      - php-mysql
      - php-curl
      - php7.0-sqlite3
      - php7.0-xml

rainloop_dir:
  file.directory:
    - name: /var/www/rainloop
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644

rainloop_install_file:
  cmd.run:
    - name: curl -s http://repository.rainloop.net/installer.php > /var/www/rainloop/install.php
    - unless:
      - ls /var/www/rainloop/install.php

rainloop_install:
  cmd.run:
    - name: cd /var/www/rainloop && php install.php
    - unless:
      - ls /var/www/rainloop/index.php

rainloop_rights:
  file.directory:
    - name: /var/www/rainloop
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
