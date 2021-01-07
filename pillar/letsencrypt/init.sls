#!jinja|yaml|gpg

letsencrypt:
  use_package: true
  config: |
     server = https://acme-v02.api.letsencrypt.org/directory
     email = webmaster@whyrl.fr
     authenticator = webroot
     webroot-path = /var/www/html
     agree-tos = True
     renew-by-default = True
  domainsets: {}
  post_renew:
    cmds:
      - systemctl restart nginx
      - systemctl restart postfix
