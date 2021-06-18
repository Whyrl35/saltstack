#- Install gluster-fs
swarm_prerequisits:
  pkg.installed:
    - pkgs:
      - glusterfs-client

#- Change the host files to put the swarm masters (those who get the glusterfs)
{% for master, ips in pillar['swarm']['masters'].items()  %}
{% if master != grains['id'] %}
{% set short_name = master.split('.', 1)[0] %}
{% for ip in ips %}
add_master_in_hosts_{{master}}_{{ip}}:
  host.only:
    - name: {{ ip }}
    - hostnames:
      - {{ master }}
      - {{ short_name }}
{% endfor %}
{% endif %}
{% endfor %}

glusterfs_volume_definition:
  file.managed:
    - name: /etc/glusterfs/datastore.vol
    - source: salt://swarm/files/datastore.vol
    - user: root
    - group: root
    - makedirs: True
    - dir_mode: "0750"
    - mode: "0640"
    - require:
      - pkg: swarm_prerequisits

mount glusterfs volume:
  mount.mounted:
    - name: /srv/swarm/volumes
    - device: /etc/glusterfs/datastore.vol
    - fstype: glusterfs
    - opts: _netdev,rw,defaults,direct-io-mode=disable
    - mkmnt: True
    - persist: True
    - dump: 0
    - pass_num: 0
