satellite_generic:
  file.managed:
    - name: /etc/postfix/generic
    - source: salt://postfix/generic.jinja
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - file: /etc/postfix/main.cf
  cmd.run:
    - name: postmap /etc/postfix/generic
    - onchanges:
      - file: /etc/postfix/generic
    - watch_in:
      - service: postfix

satelitte_sasl:
  file.managed:
    - name: /etc/postfix/sasl/sasl_passwd
    - source: salt://postfix/sasl_passwd.jinja
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - file: /etc/postfix/main.cf
  cmd.run:
    - name: postmap /etc/postfix/sasl/sasl_passwd
    - onchanges:
      - file: satelitte_sasl
    - watch_in:
      - service: postfix
