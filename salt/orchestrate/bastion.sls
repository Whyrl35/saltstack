{% for host, haddrs in salt.saltutil.runner('mine.get', tgt='not G@roles:bastion', fun='network.ip_addrs', tgt_type='compound').items() %}
{% for bastion, baddrs in salt.saltutil.runner('mine.get', tgt='roles:bastion', fun='network.ip_addrs', tgt_type='grain').items() %}
add_{{ host }}_to_{{ bastion }}:
  cmd.run:
    - name: ssh -p 2222 admin@{{ bastion }} host create -n {{ host.split('.', 1)[0] }} --key salt --group ovh ssh://ludovic@{{ host }}
    - unless: ssh -p 2222 admin@{{ bastion }} host ls | grep {{ host }}
{% endfor %}
{% endfor %}
