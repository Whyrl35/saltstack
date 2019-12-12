postfix_header_checks:
  file.managed:
    - name: /etc/postfix/header_checks
    - source: salt://postfix/header_checks.jinja
    - user: root
    - group: root
    - mode: "0600"
    - template: jinja
    - require:
      - file: /etc/postfix/main.cf
    - watch:
      - service: postfix
