cis_2552_systemd_timesyncd_install:
  pkg.installed:
    - name: systemd-timesyncd

cis_2552_systemd_timesyncd_configure:
  file.keyvalue:
    - name: /etc/systemd/timesyncd.conf
    - key_values:
        NTP: 0.debian.pool.ntp.org 1.debian.pool.ntp.org
        FallbackNTP: 2.debian.pool.ntp.org 3.debian.pool.ntp.org
    - separator: '='
    - uncomment: '#'
    - append_if_not_found: True

cis_2552_systemd_timesyncd_service:
  service.running:
    - name: systemd-timesyncd.service
    - enabe: True
    - unmask: True
    - onchanges:
      - file: cis_2552_systemd_timesyncd_configure
