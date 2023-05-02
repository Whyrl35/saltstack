{% set wp_secret = salt['vault'].read_secret('secret/salt/web/wordpress/nadine') %}
{% set db_secret = salt['vault'].read_secret('secret/salt/databases/mysql') %}
wordpress:
  cli:
    source: https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    hash:  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.sha512
    allowroot: False
  sites:
    nadine:
      username: {{ wp_secret['user'] }}
      password: {{ wp_secret['password'] }}
      database: wp_nadine
      dbhost: mysql-caaca600-o37d65b73.database.cloud.ovh.net:20184
      dbuser: wp_nadine
      dbpass: {{ db_secret['wp_nadine'] }}
      url: https://madame-de-compagnie.fr
      title: 'Dame de Compagnie'
      email: ludovic@whyrl.fr
  lookup:
    docroot: /srv/www
