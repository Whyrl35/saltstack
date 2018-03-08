openssl dhparam -out /etc/postfix/dh2048.pem 2048:
  cmd:
    - run
    - unless: ls /etc/postfix/dh2048.pem
  watch:
    - service: postfix
  require:
    - pkg: postfix
