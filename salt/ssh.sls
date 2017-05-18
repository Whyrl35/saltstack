openssh:
  pkg.installed:
    - pkgs:
      - openssh-client
      - openssh-server
      - openssh-sftp-server
  service.running:
    - name: ssh
    - watch:
      - file : openssh_config
    - require:
      - pkg : openssh

openssh_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://ssh/conf/sshd_config
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg : openssh
