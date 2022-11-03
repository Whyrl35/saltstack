{% set pkg_upgrades = salt['pkg.list_upgrades']() %}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import firezone with context %}

{% if 'firezone' in pkg_upgrades %}
stop-firezone-service:
  service.dead:
    - name: firezone-runsvdir-start.service
    - init_delay: 10

upgrade-firezone-to-latest:
  pkg.latest:
    - name: firezone
    - require:
      - service: stop-firezone-service

config-firezone-reconfigure:
  cmd.run:
    - name: {{ firezone.cmd }} reconfigure
    - require:
      - pkg: upgrade-firezone-to-latest

start-firezone-service:
  service.running:
    - name: firezone-runsvdir-start.service
    - enable: true
    - require:
      - cmd: config-firezone-reconfigure
{% endif %}
