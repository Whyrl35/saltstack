cis_2500_remove_freevxfs:
  file.managed:
    - name: /etc/modprobe.d/freevxfs.conf
    - user: root
    - group: root
    - mode: "0600"
    - content: "install freevxfs /bin/true"
    - watch_in:
      - cmd: cis_2500_remove_freevxfs
  kmod.absent:
    - name: freevxfs
    - persist: true
    - onchanges:
      - file: cis_2500_remove_freevxfs
