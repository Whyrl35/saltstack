wigo:
  server:
    ip: 217.182.85.34
  client:
    ips:
      - 91.121.156.77      # ks001
      - 78.232.192.141     # srv001
      - 217.182.169.71     # vps001
      - 217.182.85.34      # wazuh
      - 217.182.85.80      # mail
      - 54.38.245.69       # redash
  mail:
    enabled: 1
    server: 127.0.0.1:25
    mailto:
      - 'ludovic+wigo@whyrl.fr'
