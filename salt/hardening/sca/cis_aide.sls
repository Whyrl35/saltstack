cis_2528_aide:
  pkg.installed:
    - pkgs:
      - aide
      - aide-common
  cmd.run:
    - name: 'aideinit'
    - creates: '/var/lib/aide/aide.db'
    - require:
      - pkg: cis_2528_aide

cis_2529_aide_cronab:
  cron.present:
    - name: '/usr/bin/aide --config /etc/aide/aide.conf --check'
    - user: root
    - minute: {{ salt['random.rand_int'](start=0, end=59, seed=grains['id']) }}
    - hour: {{  salt['random.rand_int'](start=1, end=5, seed=grains['id']) }}
    - daymonth: '*'
    - month: '*'
    - dayweek: '*'
    - identifier: 'root-cis-2529'
    - comment: 'Scan binaries using aide as root'
