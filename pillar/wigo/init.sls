#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}

wigo:
  server:
    ip: 217.182.85.34
  client:
    ips: {{ ips.myhosts.ipv4 }}
  mail:
    enabled: 1
    server: 127.0.0.1:25
    mailto:
      - 'ludovic+wigo@whyrl.fr'
