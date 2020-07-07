#!jinja|yaml|gpg

{% from 'hosts-ips.jinja' import ips %}
{% set host = salt.grains.get('host') %}

wigo:
  server:
    ip: 217.182.85.34
  client:
    ips: {{ ips.myhosts.ipv4 }}
  mail:
    enabled: 2
    server: 127.0.0.1:25
    mailto:
      - 'ludovic+wigo@whyrl.fr'
  notification:
    http:
      enabled: 1
      url: |
        -----BEGIN PGP MESSAGE-----

        hQIMA85QH7s0WVo+ARAAkaKRuhNGtPNgVBqqCKoZpRRaiBWGrtX3W+0irN1sX0kC
        iWEIbEFPhPkcP8OES5oRi0AF5Ndw2eGRME35xHQLy/XvDEcr7fsv+SAv1k+r+imr
        6jrH14nRLW5tYT7oI30LHwL3F2QIH2R76SRlro5U7bX1PJMyrC1sqj6koNn1QCTp
        9Wql4E6EEx2rXwyZKxV2IswrpZJYpUTye03SWlAG9Y1w1aoUf8/m5UkKYl52SN7H
        rQ88KzdVmqCHlKNBT2Qs+62v20N9TK4OVH99dTcBgh1LdnjFfBQutPi0OxGne3Vs
        0QdcmubaF/ROp9ZyERsKnLyawPjm75XDn+e5adLninirpXEaDQug67x0TreUrlll
        qlg/1FXPKcgBrDisrC7mp01sBwiAMSX+pdfimG25SrihD7uoOUmZeSuz07QK71zy
        fVsXCM0QdgyHD8wCOkIjFkld94YMfKACKxj86j3IQrNwiM8/e2a7HPQcDDjDSTwX
        WOiP3PStthjrSQ67MLWKEgC3PFTqV708fAj9YxCjGdJmesNSnkIpj8btzf0Hjd8N
        l/MQ4CprmktI6AZNW9Zn9y9thgLfdaEDUjPpLU9PhY9iIOoVr7lMTcWQyL+HNLdX
        e2ukMBGWN1VQggbwo7Su1VLrAJ9sLmS1xYgeTmuj7/EjfY1w7ig7x6cDFY7PDLrS
        igEnCFNjjc3+LdOypx8FPsQmRvfic324k/eTwaiw2lQ9/yAOFdmrQtfLtf7g27XQ
        g7hUIM1uyVWoEn5tkKWVOiBPlT5LsWOJnxCOXxBkA1Cmkmpul+97vqpQnkScGMZ0
        GbCnHgpq9q7wjLP7YTEiq2gBtQs0zpgCns506Z1xbiGS+ltJ7dG4AwcqYw==
        =sbuE
        -----END PGP MESSAGE-----

include:
    - wigo.common
    {% if 'roles' in grains %}
    {% for role in grains['roles'] %}
    - wigo.r_{{ role }}
    {% endfor %}
    {% endif %}
    - wigo.h_{{ host }}
