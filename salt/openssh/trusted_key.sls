ssh_vault_trusted_key:
  file.managed:
    - name: /etc/ssh/trusted-user-ca-keys.pem
    - source: https://vault.whyrl.fr/v1/ssh/public_key
    - source_hash: 258de8986c779d047b415def8da73effaff58b7a9c5ef22f9260e18c3f1034ebab56cd0a8ae0802a3b421acd4be775d2260a237666bfd6b6fd3de7c4fb7c8aaa
    - user: root
    - group: root
    - mode: "0600"
    - require:
      - pkg: openssh-server
    - watch_in:
      - service: ssh
