---
logrotate:
  jobs:
    nginx:
      contents: |
        /var/log/nginx/*.json
        /var/log/nginx/*.log
        {
          daily
          missingok
          rotate 10
          compress
          delaycompress
          notifempty
          create 640 nginx adm
          sharedscripts
          postrotate
                if [ -f /var/run/nginx.pid ]; then
                        kill -USR1 `cat /var/run/nginx.pid`
                fi
          endscript
        }
