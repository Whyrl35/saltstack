# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

wazuh-manager-install-package:
  pkg.installed:
	- name: {{ wazuh.packages.manager }}

wazuh-manager-install-filebeat:
  pkg.installed:
	- name: filebeat
