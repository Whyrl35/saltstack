#!jinja|yaml|gpg

letsencrypt:
  use_package: true
  pkgs:
    - certbot
    - python3-certbot
  #version: 1.3.0
  create_init_cert_subcmd: certonly
  config:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: webmaster@whyrl.fr
    authenticator:  webroot
    webroot-path: /var/www/html
    agree-tos: True
    renew-by-default: False
    keep-until-expiring: True
    expand: true
  domainsets: {}
  post_renew:
    cmds:
      - systemctl restart nginx
      - systemctl restart postfix
