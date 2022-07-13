# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "../map.jinja" import wazuh with context %}

##
## Standalone installation
##
{% if wazuh.installation.mode == "all-in-one" %}
