orchestrate_restart_service:
  salt.function:
   - name: service.restart
   - tgt: 'roles:loadbalancer'
   - tgt_type: grain
   - arg:
     - haproxy
