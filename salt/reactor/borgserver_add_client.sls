borgbackup_new_client:
  local.state.single:
    - tgt: 'roles:borgbackup'
    - tgt_type: grain
    - args:
      - fun:  ssh_auth.present
      - name: {{ data['data']['public_key'] }}
      - user: borg
      - options:
        - command="borg serve --restrict-to-path /srv/borg/{{ data['data']['server'] }}"
        - no-pty
        - no-agent-forwarding
        - no-port-forwarding
        - no-X11-forwarding
        - no-user-rc
