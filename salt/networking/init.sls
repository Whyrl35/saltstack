# Used to have the right resolv.conf on my cloud infra

## check if cloud or not
{% if 'role' in grains and grains['deployment'] in ['gra7'] %}
## change /etc/network/interface.d/99-cloud-init
manage_lo_ns_dir:
  file.directory:
    - name: /etc/network/interfaces.d
    - user: root
    - group: root
    - mode: '0755'

manage_lo_nameservers:
  file.managed:
    - name: /etc/network/interfaces.d/99-cloud-init
    - source: salt://networking/files/99-cloud-init
    - user: root
    - group: root
    - mode: '0644'

## change /etc/dhcp/dhcpclient.conf
manage_dhclient_conf:
  file.managed:
    - name: /etc/dhcp/dhclient.conf
    - source: salt://networking/files/dhclient.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

## change /etc/systemd/resolved.conf
manage_resolved_conf:
  file.managed:
    - name: /etc/systemd/resolved.conf
    - source: salt://networking/files/resolved.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

## restart networking
networking_service:
  service.running:
    {% if grains.get('osmajorrelease') >= 12 %}
    - name: systemd-networkd
    {% else %}
    - name: networking
    {% endif %}
    - enable: true
    - watch:
      - file: manage_lo_nameservers
      - file: manage_dhclient_conf

{% endif %}
