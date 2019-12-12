{% from "rspamd/map.jinja" import rspamd with context %}

rspamd_packages:
  pkg.installed:
    - pkgs: {{ rspamd.packages }}
    - watch_in:
      - service: rspamd_service

rspamd_arc:
  file.directory:
    - name: {{ rspamd.config.arc_path }}
    - makedirs: True
    - user: _rspamd
    - group: root
    - dir_mode: "0755"
    - file_mode: "0644"

rspamd_dkim:
  file.directory:
    - name: {{ rspamd.config.dkim_path }}
    - makedirs: True
    - user: _rspamd
    - group: root
    - dir_mode: "0755"
    - file_mode: "0644"

rspamd_generate_keys:
  cmd.run:
    - name: rspamadm dkim_keygen -s 'dkim' -d {{ grains['domain'] }} > /var/lib/rspamd/_TO_PUT_IN_DNS_
    - unless:
      - ls {{ rspamd.config.dkim_path }}/{{ grains['domain'] }}.dkim.key
      - ls {{ rspamd.config.arc_path }}/{{ grains['domain'] }}.arc.key
    - require:
      - pkg: rspamd_packages
    - watch_in:
      - service: rspamd_service

rspamd_arc_key:
  file.copy:
    - name: {{ rspamd.config.arc_path }}/{{ grains['domain'] }}.arc.key
    - source: /var/lib/rspamd/_TO_PUT_IN_DNS_
    - user: _rspamd
    - group: _rspamd
    - mode: "0644"
    - onlyif:
      - ls /var/lib/rspamd/_TO_PUT_IN_DNS_
    - unless:
      - ls {{ rspamd.config.arc_path }}/{{ grains['domain'] }}.arc.key
    - require:
      - cmd: rspamd_generate_keys

rspamd_arc_key_remove_useless:
  file.line:
    - name: {{ rspamd.config.arc_path }}/{{ grains['domain'] }}.arc.key
    - mode: delete
    - match: (?:\;)

rspamd_dkim_key:
  file.copy:
    - name: {{ rspamd.config.dkim_path }}/{{ grains['domain'] }}.dkim.key
    - source: /var/lib/rspamd/_TO_PUT_IN_DNS_
    - user: _rspamd
    - group: _rspamd
    - mode: "0644"
    - onlyif:
      - ls /var/lib/rspamd/_TO_PUT_IN_DNS_
    - unless:
      - ls {{ rspamd.config.dkim_path }}/{{ grains['domain'] }}.dkim.key
    - require:
      - cmd: rspamd_generate_keys

rspamd_dkim_key_remove_useless:
  file.line:
    - name: {{ rspamd.config.dkim_path }}/{{ grains['domain'] }}.dkim.key
    - mode: delete
    - match: (?:\;)

rspamd_dont_remove_spam:
  file.managed:
    - name: /etc/rspamd/override.d/metrics.conf
    - content: |
        actions {
          add_header = 6;
          greylist = 4;
        }
    - require:
      - pkg: rspamd_packages
    - watch_in:
      - service: rspamd_service

rspamd_controller_password:
  file.managed:
    - name: /etc/rspamd/local.d/worker-controller.inc
    - contents: |
        password = "$2$dehoop6gz3anr7rxyxwioi6kqhh1y41b$g58j35dkspqufnoa4kyusmkkk6ofkuji1ejk5dncwi9389cb1qsb";
    - user: _rspamd
    - group: _rspamd
    - mode: "0640"
    - require:
      - pkg: rspamd_packages
    - watch_in:
      - service: rspamd_service


rspamd_service:
  service.running:
    - name: rspamd
    - watch:
      - pkg: rspamd_packages
    - require:
      - pkg: rspamd_packages
    - enable: True
