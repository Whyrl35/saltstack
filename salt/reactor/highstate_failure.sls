{%- if data['fun'] in ['state.highstate', 'state.apply'] -%}
push_to_prometheus:
  local.state.single:
    - tgt: {{ data['id'] }}
    - args:
      - fun: file.managed
      - name: /var/lib/prometheus/node-exporter/salt_highstate.prom
      - makedirs: True
      - mode: '0664'
      - contents: |
         # HELP salt_highstate_status to check Salt highstate run status. If value is 1 then highstate is getting failed.
         # TYPE salt_highstate_status gauge
         salt_highstate_status {{ data['retcode'] }}
         salt_highstate_total {{ data['return'] | length }}
         salt_highstate_jid {{ data['jid'] }}
{%- endif -%}
