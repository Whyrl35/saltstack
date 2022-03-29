cis_2534_aslr:
  file.managed:
    - name: '/etc/sysctl.d/10-aslr.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'kernel.randomize_va_space = 2'
  cmd.run:
    - name: 'sysctl -w kernel.randomize_va_space=2'
    - unless: 'sysctl kernel.randomize_va_space | grep 2'
    - onchanges:
      - file: cis_2534_aslr

cis_2536_core_dump:
  file.managed:
    - name: '/etc/sysctl.d/80-core-dump.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'fs.suid_dumpable = 0'
  cmd.run:
    - name: 'sysctl -w fs.suid_dumpable=0'
    - unless: 'sysctl fs.suid_dumpable | grep 0'
    - onchanges:
      - file: cis_2536_core_dump

cis_2536_core_dump_2:
  file.managed:
    - name: '/etc/security/limits.d/core-dump.conf'
    - user: root
    - group: root
    - mode: '0644'
    - contents: '* hard core 0'
