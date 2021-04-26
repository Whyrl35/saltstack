{% set tag = salt.pillar.get('event_tag') %}
{% set data = salt.pillar.get('event_data') %}
{% set ip_pub = {'ip': None } %}
{% set ips = data['public_ips'] %}
{% for ip in ips %}
{% if not ':' in ip %}
{% if ip_pub.update({'ip': ip}) %}{% endif %}
{% endif %}
{% endfor %}

#- Wait for agent installation
orchestrate_tag_new_install_{{ ip_pub.ip }}:
  salt.function:
    - name: grains.set
    - tgt: {{ ip_pub.ip }}
    - tgt_type: ipcidr
    - kwarg:
        key: cloud_fresh_install
        val: True
