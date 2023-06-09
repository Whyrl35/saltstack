{% set id = grains.get('id') %}
{% set short_name = id.split('.')[0] %}
{% set domain_name = id|replace(short_name, '')|replace('.', '', 1) %}

127.0.1.1:
  host.only:
    - hostnames:
      - {{ grains['id'] }}
      - {{ short_name }}

hostnamectl_from_id:
  cmd.run:
    - name: "hostnamectl set-hostname --static {{ short_name }}"
    - unless: "hostnamectl status --static | grep '^{{ short_name }}$'"

hostname_from_id:
  cmd.run:
    - name: "hostname {{ short_name }}"
    - unless: "hostname | grep '^{{ short_name }}$'"

domain_from_id:
  cmd.run:
    - name: "domainname {{ domain_name }}"
    - unless: "domainname | grep '^{{ domain_name }}$'"

hostname_file:
  file.managed:
    - name: /etc/hostname
    - contents:
      - {{ short_name }}

# For now, set the vault configuration to remote.
# FIXME : Won't work on new host, egg and chicken paradox
/etc/salt/minion.d/95_vault.conf:
  file.serialize:
    - dataset:
        vault:
          config_location: master
    - serializer: yaml
    - serializer_opts:
      - explicit_start: False
      - default_flow_style: False
      - indent: 2
    - user: root
    - group: root
    - mode: "0644"
