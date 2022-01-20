{% for auth_file in pillar['apt']['auths'] %}
{{ auth_file }}:
  file.managed:
    - name: /etc/apt/auth.conf.d/{{ auth_file }}
    - contents:
        - machine {{ pillar['apt']['auths'][auth_file]['machine'] }} login {{ pillar['apt']['auths'][auth_file]['login'] }} password {{ pillar['apt']['auths'][auth_file]['password'] }}
    - user: root
    - group: root
    - mode: "0600"
{% endfor %}
