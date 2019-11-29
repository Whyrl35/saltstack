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
    - contents:
        - '[Service]'
        - 'ExecStartPre=-/usr/sbin/nft -f /etc/nftables.conf'
        - '[Unit]'
        - 'Requires=nftables.service'
        - 'After=nftables.service'
        - 'PartOf=nftables.service'
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: override_docker_for_nftables
{% endif %}
