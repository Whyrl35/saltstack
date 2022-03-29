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

fresh_install:
  grains.present:
    - name: cloud_fresh_install
    - value: True
    - unless:
      - grep cloud_fresh_install /etc/salt/grains

logrotate_duplicate_wtmp:
  file.absent:
    - name: /etc/logrotate.d/wtmp

logrotate_duplicate_btmp:
  file.absent:
    - name: /etc/logrotate.d/btmp
