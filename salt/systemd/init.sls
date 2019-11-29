# Deploy here specific configuration for systemd
# to add value, create script, or override them

{% if 'roles' in grains and 'container' in grains['roles'] %}
override_docker_for_nftables:
  file.managed:
    - name: /etc/systemd/system/docker.service.d/override.conf
    - makedirs: True
    - dir_mode: 755
    - user: root
    - group: root
    - mode: 644
    - content:
        - '[Service]'
        - 'ExecStartPre=-/usr/sbin/nft -f /etc/nftables.conf'
        - '[unit]'
        - 'Requires=nftables.service'
        - 'After=nftables.service'
        - 'BindsTo=nftables.service'
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: override_docker_for_nftables
{% endif %}
