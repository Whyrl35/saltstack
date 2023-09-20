{%- set whyrl_fr = salt['vault'].read_secret('secret/salt/ssl/letsencrypt/whyrl.fr', default=None) %}

{%- if grains['id'][:3] == "web" or grains['id'][:2] == "lb" -%}
{%- set domains=['whyrl.fr', 'madame-de-compagnie.fr'] %}
{%- else -%}
{%- set domains=['whyrl.fr'] %}
{%- endif -%}

{% for d in domains %}
{%- set secret = salt['vault'].read_secret('secret/salt/ssl/letsencrypt/' + d, default=None) %}
{{ d }}_cert:
  file.managed:
    - name: /etc/ssl/certs/{{ d }}.pem
    - user: root
    - group: root
    - mode: "0640"
    - contents: {{ secret['cert'] | yaml_encode }}
    - listen_in:
      - service: postfix
      - service: nginx

{{ d }}_privkey:
  file.managed:
    - name: /etc/ssl/private/{{ d }}.key
    - user: root
    - group: ssl-cert
    - mode: "0600"
    - contents: {{ secret['privkey'] | yaml_encode }}
    - listen_in:
      - service: postfix
      - service: nginx

{{ d }}_chain:
  file.managed:
    - name: /etc/ssl/certs/{{ d }}.chain.pem
    - user: root
    - group: root
    - mode: "0640"
    - contents: {{ secret['chain'] | yaml_encode }}
    - listen_in:
      - service: postfix
      - service: nginx

{{ d }}_fullchain:
  file.managed:
    - name: /etc/ssl/certs/{{ d }}.fullchain.pem
    - user: root
    - group: root
    - mode: "0640"
    - contents:
      - {{ secret['cert'] | yaml_encode }}
      - {{ secret['chain'] | yaml_encode }}
    - listen_in:
      - service: postfix
      - service: nginx
{% endfor %}
