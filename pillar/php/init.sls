php:
  use_external_repo: true
  external_repo_name: 'packages.sury.org/php'
  version: "8.2"

  fpm:
    service:
      enabled: true
    config:
      ini:
        opts:
          recurse: true
        settings:
          PHP:
            engine: 'Off'
            extension_dir: '/usr/lib/php/modules/'
            extension: [pdo_mysql.so, iconv.so, openssl.so]
      conf:
        opts:
          recurse: true
        settings:
          global:
            pid: /var/run/php-fpm/special-pid.file

    pools:
      defaults:
        user: nginx
        group: nginx
        listen: /var/run/php-fpm-default.sock

      'wordpress.conf':
        enabled: true
        phpversion: "8.2"
        settings:
          wordpress:
            user: www-data
            group: www-data
            listen: /var/run/php8.2-fpm-wp.sock
            listen.owner: www-data
            listen.group: www-data
            listen.mode: '0660'
            pm: dynamic
            pm.max_children: 5
            pm.start_servers: 2
            pm.min_spare_servers: 1
            pm.max_spare_servers: 3
            'php_admin_value[memory_limit]': 300M
