cis_2542_issue:
  file.managed:
    - name: '/etc/issue'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'Authorized uses only. All activity is monitored and will reported.'

cis_2543_issue_net:
  file.managed:
    - name: '/etc/issue.net'
    - user: root
    - group: root
    - mode: '0644'
    - contents: 'Authorized uses only. All activity is monitored and will reported.'
