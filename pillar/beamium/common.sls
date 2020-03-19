#!jinja|yaml|gpg

beamium:
  scrapers:
    noderig:
      url: http://127.0.0.1:9100/metrics
      format: sensision
      period: 30000
      labels:
        host:         {{ grains['id'] }}

  sinks:
    warp10:
      url: https://warp10.ks.whyrl.fr/api/v0/update
      token-header: X-Warp10-Token
      token: |
        -----BEGIN PGP MESSAGE-----

        hQIMA85QH7s0WVo+ARAAiBtB0D5OZ+ADkQQhNdQnoETHHcuNb8tNeFaFAVdrmn+J
        FOl96H3pKPKpUSZWlovQH1y9MgNYceesxk6AMUg3BR4zgYdhxVgTVIvMSdMURVtm
        kdOh1Pb3giWrAiABz1uLmml8YMMncb8sJr0BoPyB4R/K1N68neBiD0TC7AsnMvdb
        5dQvvfHQzRcSzoK6JNYpwD1jQBTvcDf1zJP3o9WKCtq7brzqVpw5KvZOvo/UJXJC
        iOs6LA1RbW4OQx33ot+D41ki0OuSMHknQSPJh2kn8pPpikgBeDeSuEPWKgPz1xTr
        HiKJJjAJjihWNq5mw5fy2bowH0ZwMC5moItik6YZXgyA5x/GLM0YrUpcdWeVQxVz
        FP5YKiGAzkhj6NO99PAmsTJl00B2M44AzrddYNq6nMwaftsIBL9TJUovKvI/D49d
        S4pHKJCxkyvKGBJy4VauvdNbmcJqXcyi2USoRsoBOA8AIkpMswsQO9fQIYPP5kv+
        fc3fNxs1fGWlqGPsArbsmL8z/grb8YhPD/1gWHwBrzss+3xXKKT60YKwBubSR9wU
        D6l9FKn1CJdYDBFXGbuNnUmfZa+AQ+A80f5Sh16ibtNwILQnD97zCMcNUbN+9K21
        0TN25FScxrwB5YsFxT/LONbbcItOqnE/0zdjaMxstJKazs2/ghHrqRsIAKXnx37S
        uwF67iuvMlyk4B6SyLK4g+q4bHxxsQuLylYlmydS4wesxeNujs0ENOkKzbcSFTWf
        Vg81ebEaCkC7DJknYrfDl3iOqLA4EqyWTOWJiISZyyzM4YhWMNbQPaCJBLSlbSIZ
        UY8/2BidagU2GGfsyKaVpGt976c2gfKEbRLa0/EghBlbdCeTeKAnjevRJveF/Cqz
        Z/S6AsuwlZzHybL9z5RBTpwDSsvWRdZFWW1fxVDSFvqMSP9cvqXAM6cg86g=
        =IyWI
        -----END PGP MESSAGE-----
      ttl: 3600

  parameters:
    source-dir:   /opt/beamium/sources
    sink-dir:     /opt/beamium/sinks
    log-file:     /var/log/beamium/beamium.log
    scan-period:  5000
    batch-count:  250
    batch-size:   200000
    timeout:      500
    log-level:    3 # 1: critical / 2: errors / 3: warning / 4: info
