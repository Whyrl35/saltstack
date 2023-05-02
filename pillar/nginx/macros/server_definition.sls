{% from 'nginx/common.jinja' import defaults %}

{% macro server_monitoring_9180() -%}
server:
  - server_name: '_'
  - listen:
    - 9180
    - '[::]:9180'
  - root: /usr/share/nginx/html
  - location /stub_status:
    - stub_status: ''
    - allow:
      - 127.0.0.1
    - deny:
      - all
{%- endmacro %}

{% macro server_http_80(server_name) -%}
server:
  - server_name: {{ server_name }}
  - listen:
    - 80
    - '[::]:80'
  - root: /usr/share/nginx/html
  - location ~ /\.well-known/acme-challenge:
    - allow:
      - 'all'
  {# if server_name == salt.grains.get('id') #}
  - location /:
    - return:
      - '301 https://$server_name$request_uri'
{%- endmacro %}

{% macro server_https_443(server_name, locations, options=[], www=False) -%}
{% set ssn = server_name.split('.') %}
{% set domainname =  ssn[-2] + '.' + ssn[-1] %}
server:
  - server_name: {{ server_name }}{% if www %} www.{{ server_name }}{% endif %}
  - listen:
    - '443 ssl http2'
    - '[::]:443 ssl http2'
  - access_log:
    - /var/log/nginx/{{ server_name.split('.')[0] }}_access_log.json json_analytics
    - /var/log/nginx/{{ server_name.split('.')[0] }}_access.log
  - error_log: /var/log/nginx/{{ server_name.split('.')[0] }}_error.log
  - ssl_certificate: /etc/ssl/certs/{{ domainname }}.fullchain.pem
  - ssl_certificate_key: /etc/ssl/private/{{ domainname }}.key
  - ssl_session_timeout: {{ defaults.ssl.session_timeout }}
  - ssl_protocols: {{ defaults.ssl.protocol }}
  - ssl_prefer_server_ciphers: '{{ defaults.ssl.prefer_server_ciphers }}'
  - ssl_stapling: '{{ defaults.ssl.stapling }}'
  - ssl_stapling_verify: '{{ defaults.ssl.stapling_verify }}'
  {% for header in defaults.headers %}
  - add_header: {{ header }}
  {% endfor %}
  {% for option in options %}
  {% for k,v in option.items() %}
  - {{ k }}: {{ v }}
  {% endfor %}
  {% endfor %}
  - location /robots.txt:
    - return: '200 "User-agent: *\Disallow: /\n"'
{% for location in locations %}
  - {{ location }}:
    {% for item in locations[location] %}
    {% for k,v in item.items() %}
    - {{ k }}: {{ v }}
    {% endfor %}
    {% endfor %}
{% endfor %}
{%- endmacro %}
