# Deploy here specific configuration for systemd
# to add value, create script, or override them

{% if 'roles' in grains and 'container' in grains['roles'] %}
override_docker_for_nftables:
  file.managed:
    - name: /etc/systemd/system/docker.service.d/override.conf
    - makedirs: True
    - dir_mode: "0755"
    - user: root
    - group: root
    - mode: "0644"
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

{% if 'roles' in grains and 'swarm' in grains['roles'] %}
override_docker_for_api:
  file.managed:
    - name: /etc/systemd/system/docker.service.d/api.conf
    - makedirs: True
    - dir_mode: "0755"
    - user: root
    - group: root
    - mode: "0644"
    - contents:
        - '[Service]'
        - 'ExecStart='
        - "ExecStart=/usr/bin/dockerd -H fd:// -H tcp://{{ grains['ip4_interfaces']['eth1'][0] }}:2375 --containerd=/run/containerd/containerd.sock"
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: override_docker_for_nftables
{% endif %}
