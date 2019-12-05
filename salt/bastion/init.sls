{% set host = salt.grains.get('host') %}
{% set fqdn = salt.grains.get('fqdn') %}
{% for bastion, addrs in salt.saltutil.runner('mine.get', tgt='roles:bastion', fun='network.ip_addrs', tgt_type='grain').items() %}
add_host_to_{{ bastion }}:
  cmd.run:
    - name: ssh -p 2222 admin@{{ bastion }} host create -n {{ host }} --key salt --group ovh ssh://ludovic@{{ fqdn }}
    - unless: ssh -p 2222 admin@{{ bastion }} host ls | grep {{ host }}
{% endfor %}