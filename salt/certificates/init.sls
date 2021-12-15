{%- set whyrl_fr = salt['vault'].read_secret('secret/salt/ssl/letsencrypt/whyrl.fr', default=None) %}

whyrl_fr_cert:
  file.managed:
    - name: /etc/nginx/ssl/whyrl.fr.pem
    - user: root
    - group: root
    - mode: "0640"
    - contents: {{ whyrl_fr['cert'] | yaml_encode }}

whyrl_fr_privkey:
  file.managed:
    - name: /etc/nginx/ssl/whyrl.fr.key
    - user: root
    - group: root
    - mode: "0640"
    - contents: {{ whyrl_fr['privkey'] | yaml_encode }}

whyrl_fr_chain:
  file.managed:
    - name: /etc/nginx/ssl/whyrl.fr.chain.pem
    - user: root
    - group: root
    - mode: "0640"
    - contents: {{ whyrl_fr['chain'] | yaml_encode }}

whyrl_fr_fullchain:
  file.managed:
    - name: /etc/nginx/ssl/whyrl.fr.fullchain.pem
    - user: root
    - group: root
    - mode: "0640"
    - contents:
      - {{ whyrl_fr['cert'] | yaml_encode }}
      - {{ whyrl_fr['chain'] | yaml_encode }}
