cis_2636_crontab_perm:
  file.managed:
    - name: '/etc/crontab'
    - user: root
    - group: root
    - mode: '0600'

cis_2637_cron_hourly_perm:
  file.directory:
    - name: '/etc/cron.hourly'
    - user: root
    - group: root
    - mode: '0700'

cis_2638_cron_daily_perm:
  file.directory:
    - name: '/etc/cron.daily'
    - user: root
    - group: root
    - mode: '0700'

cis_2639_cron_weekly_perm:
  file.directory:
    - name: '/etc/cron.weekly'
    - user: root
    - group: root
    - mode: '0700'

cis_2640_cron_monthly_perm:
  file.directory:
    - name: '/etc/cron.monthly'
    - user: root
    - group: root
    - mode: '0700'

cis_2641_cron_d_perm:
  file.directory:
    - name: '/etc/cron.d'
    - user: root
    - group: root
    - mode: '0700'

cis_2642_cron_allow_delete_cron.deny:
  file.absent:
    - name: /etc/cron.deny

cis_2642_cron_allow_delete_at.deny:
  file.absent:
    - name: /etc/at.deny

cis_2642_cron_allow_ensure:
  file.managed:
    - name: /etc/cron.allow
    - user: root
    - group: root
    - mode: '0600'

cis_2642_cron_allow_ensure_2:
  file.managed:
    - name: /etc/at.allow
    - user: root
    - group: root
    - mode: '0600'

