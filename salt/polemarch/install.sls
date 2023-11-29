# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import polemarch with context %}

polemarch-prerequisit-install:
  pkg.installed:
    - names: {{ polemarch.package.prerequisites }}

polemarch-user:
  user.present:
    - name: {{ polemarch.identity.user }}
    - mindays: 0
    - maxdays: 99999
    - inactdays: -1
    - warndays:
    - expire: -1

polemarch-app-directory:
  file.directory:
    - name: {{ polemarch.path.app }}
    - user: {{ polemarch.identity.user }}
    - group: {{ polemarch.identity.group }}
    - dir_mode: "0755"
    - recurse:
      - user
      - group

polemarch-pid-directory:
  file.directory:
    - name: {{ polemarch.path.pid }}
    - user: {{ polemarch.identity.user }}
    - group: {{ polemarch.identity.group }}
    - dir_mode: "0755"

polemarch-log-directory:
  file.directory:
    - name: {{ polemarch.path.log }}
    - user: {{ polemarch.identity.user }}
    - group: {{ polemarch.identity.group }}
    - dir_mode: "0755"

polemarch-hooks-directory:
  file.directory:
    - name: {{ polemarch.path.hooks }}
    - user: {{ polemarch.identity.user }}
    - group: {{ polemarch.identity.group }}
    - dir_mode: "0755"

polemarch-projects-directory:
  file.directory:
    - name: {{ polemarch.path.projects }}
    - user: {{ polemarch.identity.user }}
    - group: {{ polemarch.identity.group }}
    - dir_mode: "0755"


polemarch-etc-directory:
  file.directory:
    - name: {{ polemarch.path.etc }}
    - user: {{ polemarch.identity.user }}
    - group: {{ polemarch.identity.group }}
    - dir_mode: "0755"
    - recurse:
      - user
      - group

polemarch-virtualenv:
  virtualenv.managed:
    - name: {{ polemarch.path.app }}
    - cwd: {{ polemarch.path.app }}
    - pip_pkgs: {{ polemarch.python.pip.pkgs }}
