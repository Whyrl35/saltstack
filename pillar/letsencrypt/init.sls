#!jinja|yaml|gpg

{% set host = salt.grains.get('host') %}

letsencrypt:
  use_package: false
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

include:
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - letsencrypt.r_{{ role }}
    {% endfor %}
    {% endif %}
    - letsencrypt.h_{{ host }}
